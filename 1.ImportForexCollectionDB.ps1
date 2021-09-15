#RUN AS ADMINISTRATOR
#Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Undefined
#Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#$PSVersionTable
#Get-ExecutionPolicy -List

chdir C:\CODE\_MQL4_PREBUILD

$assemblies = 
    "Microsoft.SqlServer.ConnectionInfo", 
    "Microsoft.SqlServer.ConnectionInfoExtended", 
    "Microsoft.SqlServer.Dmf", 
    "Microsoft.SqlServer.Management.Collector", 
    "Microsoft.SqlServer.Management.CollectorEnum", 
    "Microsoft.SqlServer.Management.RegisteredServers", 
    "Microsoft.SqlServer.Management.Sdk.Sfc", 
    "Microsoft.SqlServer.RegSvrEnum", 
    "Microsoft.SqlServer.ServiceBrokerEnum", 
    "Microsoft.SqlServer.Smo", 
    "Microsoft.SqlServer.SmoExtended", 
    "Microsoft.SqlServer.SqlEnum", 
    "Microsoft.SqlServer.SqlWmiManagement", 
    "Microsoft.SqlServer.WmiEnum"

foreach ($assembly in $assemblies) 
{
    [void][Reflection.Assembly]::LoadWithPartialName($assembly)
}


$machine = "$env:COMPUTERNAME"
$server  = New-Object Microsoft.Sqlserver.Management.Smo.Server("$machine")
$server.ConnectionContext.LoginSecure=$true;
$database  = $server.Databases["Indicators"]

#Job1
    $ZipSource = $PSScriptRoot+'\_3rdPartyMT4Code\forexcollection\2020'
    $TrgtRt = $PSScriptRoot + '\..\_MQL4_PREBUILD'

#Job3
    #Global prime dev 4 forex collection
    $DevMT4Path = 'C:\Users\Amos\AppData\Roaming\MetaQuotes\Terminal\73A0F6A7AFD1C71F9BDB0DDF74C5C5F2\MQL4\Indicators'
    $MT4Indis = '\001\'
    $DevIndis = $DevMT4Path+$MT4Indis

$startjob=3


If ($startjob -lt 2){


    $UnzipJobs = New-Object System.Collections.Generic.List[System.Object]
    $JobNo=0

    Remove-Item $TrgtRt -Recurse -Force
    New-item $TrgtRt -ItemType directory
    
    '1. Unzipping -In Progress...'
    
    Get-ChildItem -Path $ZipSource -Recurse |ForEach-Object{
        
        if($_.Extension -eq '.zip'){
            
            Try{
            Expand-Archive -Path $_.FullName -DestinationPath $TrgtRt -Force
            }
            Catch{
                $_.Exception 
                Break
            }

        }
    }
    
'FINISHED!'
}


If ($startjob -lt 3){
    '2. Updating database.  Processing...'
    $Job2command   =    "Delete from dbo.ForexCollection"
    $dataset = $database.ExecuteNonQuery($Job2command)
    
    Get-ChildItem -Path $TrgtRt -Recurse -Directory |ForEach-Object{

        Try{

            foreach ($2 in ([System.IO.Directory]::EnumerateFiles($_.FullName, '*.txt'))){
                [System.IO.File]::Delete($2)
            } 
            foreach ($2 in ([System.IO.Directory]::EnumerateFiles($_.FullName, '*.htm'))){
                [System.IO.File]::Delete($2)
            }
            foreach ($2 in ([System.IO.Directory]::EnumerateFiles($_.FullName, '*.html'))){
                [System.IO.File]::Delete($2)
            }
            foreach ($2 in ([System.IO.Directory]::EnumerateFiles($_.FullName, '*.png'))){
                [System.IO.File]::Delete($2)
            }
            foreach ($2 in ([System.IO.Directory]::EnumerateFiles($_.FullName, '*.mq4'))){
                    [System.IO.File]::Delete($2.Replace('.mq4', 'ex4'))
            } 
                       
            $NoOfex4Files = [System.IO.Directory]::EnumerateFiles($_.FullName, '*.ex4')| Measure-Object| ForEach-Object{$_.Count}
            $NoOfmq4Files = [System.IO.Directory]::EnumerateFiles($_.FullName, '*.mq4')| Measure-Object| ForEach-Object{$_.Count}
            $NoOfSubFolder = [System.IO.Directory]::EnumerateDirectories($_.FullName, '*')| Measure-Object| ForEach-Object{$_.Count}
            $CountTotalFiles = [System.IO.Directory]::EnumerateFiles($_.FullName, '*.*')| Measure-Object| ForEach-Object{$_.Count}

            #$SubDir.FullName
            #'Item ' + $ItemPos + ' ' + ' of ' + $LastPos + ': ex4 =' +  $NoOfex4Files + ': mq4 =' + $NoOfmq4Files +' : TotalFileCount ='+ $CountTotalFiles + ': SubFolders =' +  $NoOfSubFolder
            $ItemPos = $ItemPos+1

            $command   =   'insert into dbo.ForexCollection(Name, NoOfex4, NoOfMq4, NoSubFolder,TotalCountOfFiles) values (N''' + 
                             $_.FullName.Replace("'", "''") + ''', ' + $NoOfex4Files+ ', ' + $NoOfmq4Files+ ', ' + $NoOfSubFolder+ ', ' + $CountTotalFiles + ')'
            $dataset = $database.ExecuteNonQuery($command)
            
        }
        Catch{
            $_.Exception
            $command
            Break 
        }
    }
    'FINISHED!'
}


If ($startjob -lt 4){


    '3.Processing...'

        Try{
            'Just MQ4 files...'
            $command   =   'SELECT [NoOfEx4]
                            ,[NoOfMq4]
                            ,[NoSubFolder]
                            ,[Status]
                            ,[TotalCountOfFiles]
                            ,[Name]
                            FROM [Indicators].[dbo].[ForexCollection]'
            $IndicatorPath                
            $dataTab= $database.ExecuteWithResults($command)
            #$IndicatorPath
            ForEach($Row in $dataTab.tables[0].Select("NoOfMq4 = 1 and TotalCountOfFiles=1")){
               
                foreach ($2 in ([System.IO.Directory]::EnumerateFiles($Row.Name, '*.mq4'))){
                  
                    $SubFolder = $2.Substring($2.LastIndexOf('\')+1,1)
                    $FileName = $2.Substring($2.LastIndexOf('\')+1)
                    $MoveTo=$DevIndis+ $SubFolder+'\'+$FileName
                 $DevIndis+ $SubFolder
                    If(![System.IO.Directory]::Exists($DevIndis+ $SubFolder)){
                        [System.IO.Directory]::CreateDirectory($DevIndis+ $SubFolder)
                    }
                    else{
                        #Remove-Item $TrgtRt -Recurse -Force
                        [System.IO.Directory]::Delete($DevIndis+ $SubFolder, 1)
                        [System.IO.Directory]::CreateDirectory($DevIndis+ $SubFolder)
                    }
                    
                    [System.IO.File]::Copy($2,  $MoveTo,1)
                } 
            }
           #$Job2command   =    ''
           #$DevMT4Path $MT4Indis

        }
        Catch{
            $_.Exception
            Break 
        }
    
    'Finished.'
}


