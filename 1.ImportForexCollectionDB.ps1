#RUN AS ADMINISTRATOR
#Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Undefined
#Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#$PSVersionTable
#Get-ExecutionPolicy -List

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

$startjob=4


If ($startjob -lt 2){

    $ZipSource = $PSScriptRoot+'\_3rdPartyMT4Code\forexcollection\2020'
    $TrgtRt = $PSScriptRoot + '\..\_MQL4_PREBUILD'
    $UnzipJobs = New-Object System.Collections.Generic.List[System.Object]
    $JobNo=0

    Remove-Item $TrgtRt -Recurse -Force
    New-item $TrgtRt -ItemType directory
    
    'Unzipping -In Progress...'
    
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
    $command   =    "Delete from dbo.ForexCollection"
    $dataset = $database.ExecuteNonQuery($command)
    
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

<#
If ($startjob -lt 4){
    '3.Mark unwanted folders. Processing... '
    $command   =    "Update dbo.ForexCollection 
                    Set [1_DeleteInstaltionManTxt] = 1 where
                    NoOfEx4 =0 and NoSubFolder=0 and NoofMQ4=0 and TotalCountOfFiles=0
                    "
    $dataset = $database.ExecuteNonQuery($command)
    'Finished'
}
#>

If ($startjob -lt 4){
    '3.Delete .EX4 from base folders and child folders.  Processing...'
    Get-ChildItem -Path $TrgtRt -Recurse -Directory |ForEach-Object{
        Try{
                
            foreach ($2 in ([System.IO.Directory]::EnumerateFiles($_.FullName, '*.mq4'))){
                #Base Folder
                [System.IO.File]::Delete($2.Replace('.mq4', 'ex4'))
            }

        }
        Catch{
            $_.Exception
            Break 
        }
    }
    'Finished.'
}
If ($startjob -lt 5){

    '4.Process Remaining files.  This will be lengthy.  Processing...'
    Get-ChildItem -Path $TrgtRt  -Directory |ForEach-Object{
        Try{
                
 

        }
        Catch{
            $_.Exception
            Break 
        }
    }
    'Finished.'
}
