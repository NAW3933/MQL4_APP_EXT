#Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#$PSVersionTable
#Get-ExecutionPolicy -List
#Install-Module -Name SqlServer -RequiredVersion 21.1.18256

#import SQL Server module
chdir C:\CODE\_MQL4_PREBUILD

# Loads the SQL Server Management Objects (SMO)  
$ErrorActionPreference = "Stop"
  
$sqlpsreg="HKLM:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.SqlServer.Management.PowerShell.sqlps"  

if (Get-ChildItem $sqlpsreg -ErrorAction "SilentlyContinue")  
{  
    throw "SQL Server Provider for Windows PowerShell is not installed."  
}  
else  
{  
    #$item = Get-ItemProperty C:\Windows\Microsoft.NET\assembly\GAC_MSIL\Microsoft.SqlServer.Smo\v4.0_15.0.0.0__89845dcd8080cc91 
    $sqlpsPath = [System.IO.Path]::GetDirectoryName('C:\Windows\Microsoft.NET\assembly\GAC_MSIL\Microsoft.SqlServer.Smo\v4.0_15.0.0.0__89845dcd8080cc91') #$item.Path)  
}  
  
$assemblylist =
"Microsoft.SqlServer.Management.Common",  
"Microsoft.SqlServer.Smo",  
"Microsoft.SqlServer.Dmf ",  
"Microsoft.SqlServer.Instapi ",  
"Microsoft.SqlServer.SqlWmiManagement ",  
"Microsoft.SqlServer.ConnectionInfo ",  
"Microsoft.SqlServer.SmoExtended ",  
"Microsoft.SqlServer.SqlTDiagM ",  
"Microsoft.SqlServer.SString ",  
"Microsoft.SqlServer.Management.RegisteredServers ",  
"Microsoft.SqlServer.Management.Sdk.Sfc ",  
"Microsoft.SqlServer.SqlEnum ",  
"Microsoft.SqlServer.RegSvrEnum ",  
"Microsoft.SqlServer.WmiEnum ",  
"Microsoft.SqlServer.ServiceBrokerEnum ",  
"Microsoft.SqlServer.ConnectionInfoExtended ",  
"Microsoft.SqlServer.Management.Collector ",  
"Microsoft.SqlServer.Management.CollectorEnum",  
"Microsoft.SqlServer.Management.Dac",  
"Microsoft.SqlServer.Management.DacEnum",  
"Microsoft.SqlServer.Management.Utility"  
  
foreach ($asm in $assemblylist)  
{  
    $asm = [Reflection.Assembly]::LoadWithPartialName($asm)  
}  

 
##Push-Location  
#cd $sqlpsPath  
##update-FormatData -prependpath SQLProvider.Format.ps1xml
#Pop-Location  

$machine = "$env:COMPUTERNAME"
$server  = New-Object Microsoft.Sqlserver.Management.Smo.Server("$machine")
$server.ConnectionContext.LoginSecure=$true;
$database  = $server.Databases["Indicators"]

enum ProcessStatus {
    NoFiles = 0
    CopiedToCompPath = 1
}

#Job1
    $ZipSource = $PSScriptRoot+'\_3rdPartyMT4Code\forexcollection\2020'
    $TrgtRt = $PSScriptRoot + '\..\_MQL4_PREBUILD'

#Job3
    #Global prime dev 4 forex collection
    $IndiDir= '\Indicators'
    $DevMT4Path = 'C:\Users\Amos\AppData\Roaming\MetaQuotes\Terminal\73A0F6A7AFD1C71F9BDB0DDF74C5C5F2\MQL4'+$IndiDir
    $MT4Indis = '\001\'
    $DevIndis = $DevMT4Path+$MT4Indis

$startjob=4


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

            $command   =   'insert into dbo.ForexCollection(Name, NoOfEx4, NoOfMq4, NoSubFolder,TotalCountOfFiles) values (N''' + 
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
                           
            $dataTab= $database.ExecuteWithResults($command)
            
            ForEach($Row in $dataTab.tables[0].Select("NoOfMq4 = 1 and TotalCountOfFiles=1")){
               
                foreach ($2 in ([System.IO.Directory]::EnumerateFiles($Row.Name, '*.mq4'))){
                  
                    $SubFolder = $2.Substring($2.LastIndexOf('\')+1,1)
                    $FileName = $2.Substring($2.LastIndexOf('\')+1)
                    $MoveTo=$DevIndis+ $SubFolder+'\'+$FileName
                   
                    If(![System.IO.Directory]::Exists($DevIndis+ $SubFolder)){
                        [System.IO.Directory]::CreateDirectory($DevIndis+ $SubFolder)
                    }
                    else{
                        #Remove-Item $TrgtRt -Recurse -Force
                        [System.IO.Directory]::Delete($DevIndis+ $SubFolder, 1)
                        [System.IO.Directory]::CreateDirectory($DevIndis+ $SubFolder)
                    }
                    
                    [System.IO.File]::Copy($2,  $MoveTo)
                    
                    $Command = 'Update [Indicators].[dbo].[ForexCollection] ' +
                                'Set Status = ' + [ProcessStatus]::CopiedToCompPath.value__ +
                                ' Where Name=''' + $Row.Name + ''''
                    $Command
                    $dataTab= $database.ExecuteWithResults($command)
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



If ($startjob -lt 5){
 
            'Job 5'
         Try{
            
            $command   =   'SELECT Top 1 *
                            FROM [Indicators].[dbo].[ForexCollection]'
                           
            $dataTab= $database.ExecuteWithResults($command)
            
            ForEach($Row in $dataTab.tables[0].Select("NoOfMq4 = 1 and TotalCountOfFiles=1")){
                $Row.Name
                #Build-MT4Indi($Row.Name)
            }
        }
        catch{
            $_.Exception
            Break 
        }
        #
        #Get-ChildItem -Path ($DevMT4Path + $MT4Indis) -Recurse -File|ForEach-Object{
        #    $_.FullName
        # }
}
<#
# #[Parameter(Mandatory, ValueFromPipeline)] [string]$FIleNamePipe
function Build-MT4Indi{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory)] [string] $FIleName 
	  
    )

    process{
    
    $CMD = 'C:\Program Files (x86)\Global Prime - MetaTrader 4 DEV\metaeditor.exe'
    $arg1=' /compile:'+ $FIleName +' /log'
    $arg2=' /include:C:\Users\Amos\AppData\Roaming\MetaQuotes\Terminal\73A0F6A7AFD1C71F9BDB0DDF74C5C5F2\MQL4 '  #path
    $arg3=' /log'      #indicatorName.log
    $arg4='/s'         #Check syntaxg
    #$FIleName 
    & $CMD 
    #$arg1+$arg2+$arg3

    
    #$p = Start-Process ping -ArgumentList "invalidhost" -wait -NoNewWindow -PassThru
    #$p.HasExited
    #$p.Exit
    }
}

#>