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
enum CollectionNo {
   ForexCollection2020  = 0
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

#  FUNCTIONS -----------------------------------------------------------------


function Remove-FileSystemItem {
  <#
  .SYNOPSIS
    Removes files or directories reliably and synchronously.

  .DESCRIPTION
    Removes files and directories, ensuring reliable and synchronous
    behavior across all supported platforms.

    The syntax is a subset of what Remove-Item supports; notably,
    -Include / -Exclude and -Force are NOT supported; -Force is implied.
    
    As with Remove-Item, passing -Recurse is required to avoid a prompt when 
    deleting a non-empty directory.

    IMPORTANT:
      * On Unix platforms, this function is merely a wrapper for Remove-Item, 
        where the latter works reliably and synchronously, but on Windows a 
        custom implementation must be used to ensure reliable and synchronous 
        behavior. See https://github.com/PowerShell/PowerShell/issues/8211

    * On Windows:
      * The *parent directory* of a directory being removed must be 
        *writable* for the synchronous custom implementation to work.
      * The custom implementation is also applied when deleting 
         directories on *network drives*.

    * If an indefinitely *locked* file or directory is encountered, removal is aborted.
      By contrast, files opened with FILE_SHARE_DELETE / 
      [System.IO.FileShare]::Delete on Windows do NOT prevent removal, 
      though they do live on under a temporary name in the parent directory 
      until the last handle to them is closed.

    * Hidden files and files with the read-only attribute:
      * These are *quietly removed*; in other words: this function invariably
        behaves like `Remove-Item -Force`.
      * Note, however, that in order to target hidden files / directories
        as *input*, you must specify them as a *literal* path, because they
        won't be found via a wildcard expression.

    * The reliable custom implementation on Windows comes at the cost of
      decreased performance.

  .EXAMPLE
    Remove-FileSystemItem C:\tmp -Recurse

    Synchronously removes directory C:\tmp and all its content.
  #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium', DefaultParameterSetName='Path', PositionalBinding=$false)]
    param(
      [Parameter(ParameterSetName='Path', Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
      [string[]] $Path
      ,
      [Parameter(ParameterSetName='Literalpath', ValueFromPipelineByPropertyName)]
      [Alias('PSPath')]
      [string[]] $LiteralPath
      ,
      [switch] $Recurse
    )
    begin {
      # !! Workaround for https://github.com/PowerShell/PowerShell/issues/1759
      if ($ErrorActionPreference -eq [System.Management.Automation.ActionPreference]::Ignore) { $ErrorActionPreference = 'Ignore'}
      $targetPath = ''
      $yesToAll = $noToAll = $false
      function trimTrailingPathSep([string] $itemPath) {
        if ($itemPath[-1] -in '\', '/') {
          # Trim the trailing separator, unless the path is a root path such as '/' or 'c:\'
          if ($itemPath.Length -gt 1 -and $itemPath -notmatch '^[^:\\/]+:.$') {
            $itemPath = $itemPath.Substring(0, $itemPath.Length - 1)
          }
        }
        $itemPath
      }
      function getTempPathOnSameVolume([string] $itemPath, [string] $tempDir) {
        if (-not $tempDir) { $tempDir = [IO.Path]::GetDirectoryName($itemPath) }
        [IO.Path]::Combine($tempDir, [IO.Path]::GetRandomFileName())
      }
      function syncRemoveFile([string] $filePath, [string] $tempDir) {
        # Clear the ReadOnly attribute, if present.
        if (($attribs = [IO.File]::GetAttributes($filePath)) -band [System.IO.FileAttributes]::ReadOnly) {
          [IO.File]::SetAttributes($filePath, $attribs -band -bnot [System.IO.FileAttributes]::ReadOnly)
        }
        $tempPath = getTempPathOnSameVolume $filePath $tempDir
        [IO.File]::Move($filePath, $tempPath)
        [IO.File]::Delete($tempPath)
      }
      function syncRemoveDir([string] $dirPath, [switch] $recursing) {
          if (-not $recursing) { $dirPathParent = [IO.Path]::GetDirectoryName($dirPath) }
          # Clear the ReadOnly attribute, if present.
          # Note: [IO.File]::*Attributes() is also used for *directories*; [IO.Directory] doesn't have attribute-related methods.
          if (($attribs = [IO.File]::GetAttributes($dirPath)) -band [System.IO.FileAttributes]::ReadOnly) {
            [IO.File]::SetAttributes($dirPath, $attribs -band -bnot [System.IO.FileAttributes]::ReadOnly)
          }
          # Remove all children synchronously.
          $isFirstChild = $true
          foreach ($item in [IO.directory]::EnumerateFileSystemEntries($dirPath)) {
            if (-not $recursing -and -not $Recurse -and $isFirstChild) { # If -Recurse wasn't specified, prompt for nonempty dirs.
              $isFirstChild = $false
              # Note: If -Confirm was also passed, this prompt is displayed *in addition*, after the standard $PSCmdlet.ShouldProcess() prompt.
              #       While Remove-Item also prompts twice in this scenario, it shows the has-children prompt *first*.
              if (-not $PSCmdlet.ShouldContinue("The item at '$dirPath' has children and the -Recurse switch was not specified. If you continue, all children will be removed with the item. Are you sure you want to continue?", 'Confirm', ([ref] $yesToAll), ([ref] $noToAll))) { return }
            }
            $itemPath = [IO.Path]::Combine($dirPath, $item)
            ([ref] $targetPath).Value = $itemPath
            if ([IO.Directory]::Exists($itemPath)) {
              syncremoveDir $itemPath -recursing
            } else {
              syncremoveFile $itemPath $dirPathParent
            }
          }
          # Finally, remove the directory itself synchronously.
          ([ref] $targetPath).Value = $dirPath
          $tempPath = getTempPathOnSameVolume $dirPath $dirPathParent
          [IO.Directory]::Move($dirPath, $tempPath)
          [IO.Directory]::Delete($tempPath)
      }
    }

    process {
      $isLiteral = $PSCmdlet.ParameterSetName -eq 'LiteralPath'
      if ($env:OS -ne 'Windows_NT') { # Unix: simply pass through to Remove-Item, which on Unix works reliably and synchronously
        Remove-Item @PSBoundParameters
      } else { # Windows: use synchronous custom implementation
        foreach ($rawPath in ($Path, $LiteralPath)[$isLiteral]) {
          # Resolve the paths to full, filesystem-native paths.
          try {
            # !! Convert-Path does find hidden items via *literal* paths, but not via *wildcards* - and it has no -Force switch (yet)
            # !! See https://github.com/PowerShell/PowerShell/issues/6501
            $resolvedPaths = if ($isLiteral) { Convert-Path -ErrorAction Stop -LiteralPath $rawPath } else { Convert-Path -ErrorAction Stop -path $rawPath}
          } catch {
            Write-Error $_ # relay error, but in the name of this function
            continue
          }
          try {
            $isDir = $false
            foreach ($resolvedPath in $resolvedPaths) {
              # -WhatIf and -Confirm support.
              if (-not $PSCmdlet.ShouldProcess($resolvedPath)) { continue }
              if ($isDir = [IO.Directory]::Exists($resolvedPath)) { # dir.
                # !! A trailing '\' or '/' causes directory removal to fail ("in use"), so we trim it first.
                syncRemoveDir (trimTrailingPathSep $resolvedPath)
              } elseif ([IO.File]::Exists($resolvedPath)) { # file
                syncRemoveFile $resolvedPath
              } else {
                Throw "Not a file-system path or no longer extant: $resolvedPath"
              }
            }
          } catch {
            if ($isDir) {
              $exc = $_.Exception
              if ($exc.InnerException) { $exc = $exc.InnerException }
              if ($targetPath -eq $resolvedPath) {
                Write-Error "Removal of directory '$resolvedPath' failed: $exc"
              } else {
                Write-Error "Removal of directory '$resolvedPath' failed, because its content could not be (fully) removed: $targetPath`: $exc"
              }
            } else {
              Write-Error $_  # relay error, but in the name of this function
            }
            continue
          }
        }
      }
    }
}

#[Parameter(Mandatory, ValueFromPipeline)] [string]$FIleNamePipe
function Build-MT4Indi{
    [cmdletbinding()]
    Param (
        [Parameter(Mandatory)] [string] $FIleName, 
	    [Parameter(Mandatory)] [CollectionNo] $CollectionNo
    )
   
    process{
    
    switch ($CollectionNo){
        ForexCollection2020{

        break;
        }
    }

    $CMD = 'C:\Program Files (x86)\Global Prime - MetaTrader 4 DEV\metaeditor.exe '
    $arg1=' /compile:'+ $FIleName +' /log'
    $arg2=' /include:C:\Users\Amos\AppData\Roaming\MetaQuotes\Terminal\73A0F6A7AFD1C71F9BDB0DDF74C5C5F2\MQL4 '  #path
    $arg3=' /log'      #indicatorName.log
    $arg4=' /s'         #Check syntaxg
    

    $FIleName 
    & $CMD $arg1+$arg2+$arg3
    
    #& $CMD $arg1
    
    #$p = Start-Process ping -ArgumentList "invalidhost" -wait -NoNewWindow -PassThru
    #$p.HasExited
    #$p.Exit
    }
}
#-----------------------------------------------------------------------------

If ($startjob -lt 2){


    #$UnzipJobs = New-Object System.Collections.Generic.List[System.Object]
    $JobNo=0
    
    '1. Removing files and folders in and including ' + $TrgtRt
    
    Remove-FileSystemItem $TrgtRt
    #Remove-Item $TrgtRt -Recurse -Force
    'Creating New Folder ' + $TrgtRt
    New-item $TrgtRt -ItemType directory
    #rmd ($TrgtR)

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
    '2. Updating database, updates simple stats and clearing unwanted files.  Processing...'
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
 

    '3.Processing indis with just single mq4 file ...'

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
                        #[System.IO.Directory]::Delete($DevIndis+ $SubFolder, 1)
                        #[System.IO.Directory]::CreateDirectory($DevIndis+ $SubFolder)
                    }
                    #$2 + ' -> ' + $MoveTo
                    [System.IO.File]::Copy($2,  $MoveTo, 1)
                    
                    $Command = 'Update [Indicators].[dbo].[ForexCollection] ' +
                                'Set Status = ' + [ProcessStatus]::CopiedToCompPath.value__ +
                                ' Where Name=''' + $Row.Name + ''''
                    
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
 
        'Job 4'
        Try{
            
            $command   =   'SELECT Top 100 *
                            FROM  [Indicators].[dbo].[ForexCollection] where status=' + [ProcessStatus]::CopiedToCompPath.value__ 
                           
            
            $dataTab= $database.ExecuteWithResults($command)
            
            ForEach($Row in $dataTab.tables[0]){
                $LastIndx = $Row.Name.LastIndexOf('\')+1
                $FileName = $Row.Name.Substring($LastIndx)

                Build-MT4Indi -FileName $FileName -CollectionNo ForexCollection2020
            }
        }
        catch{
            $_.Exception
           
            Break 
        }
}