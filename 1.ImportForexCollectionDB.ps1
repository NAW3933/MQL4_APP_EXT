class BackgroundJob
{
    # Properties
    hidden $PowerShell = [powershell]::Create()
    hidden $Handle = $null
    hidden $Runspace = $null
    $Result = $null
    $RunspaceID = $This.PowerShell.Runspace.ID
    $PSInstance = $This.PowerShell
 
    # Constructor (just code block)
    BackgroundJob ([scriptblock]$Code)
    {
        $This.PowerShell.AddScript($Code)
    }
 
    # Constructor (code block + arguments)
    BackgroundJob ([scriptblock]$Code,$Arguments)
    {
        $This.PowerShell.AddScript($Code)
        foreach ($Argument in $Arguments)
        {
            $This.PowerShell.AddArgument($Argument)
        }
    }
 
    # Constructor (code block + arguments + functions)
    BackgroundJob ([scriptblock]$Code,$Arguments,$Functions)
    {
        $InitialSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
        $Scope = [System.Management.Automation.ScopedItemOptions]::AllScope
        foreach ($Function in $Functions)
        {
            $FunctionName = $Function.Split('\')[1]
            $FunctionDefinition = Get-Content $Function -ErrorAction Stop
            $SessionStateFunction = New-Object -TypeName System.Management.Automation.Runspaces.SessionStateFunctionEntry -ArgumentList $FunctionName, $FunctionDefinition, $Scope, $null
            $InitialSessionState.Commands.Add($SessionStateFunction)
        }
        $This.Runspace = [runspacefactory]::CreateRunspace($InitialSessionState)
        $This.PowerShell.Runspace = $This.Runspace
        $This.Runspace.Open()
        $This.PowerShell.AddScript($Code)
        foreach ($Argument in $Arguments)
        {
            $This.PowerShell.AddArgument($Argument)
        }
    }
 
    # Start Method
    Start()
    {
        $THis.Handle = $This.PowerShell.BeginInvoke()
    }
 
    # Stop Method
    Stop()
    {
        $This.PowerShell.Stop()
    }
 
    # Receive Method
    [object]Receive()
    {
        $This.Result = $This.PowerShell.EndInvoke($This.Handle)
        return $This.Result
    }
 
    # Remove Method
    Remove()
    {
        $This.PowerShell.Dispose()
        If ($This.Runspace)
        {
            $This.Runspace.Dispose()
        }
    }
 
    # Get Status Method
    [object]GetStatus()
    {
        return $This.PowerShell.InvocationStateInfo
    }
}



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
$env:COMPUTERNAME
$machine = "$env:COMPUTERNAME"
$server  = New-Object Microsoft.Sqlserver.Management.Smo.Server("$machine")
$server.ConnectionContext.LoginSecure=$true;
$database  = $server.Databases["Indicators"]

$ZipSource = $PSScriptRoot+'\_3rdPartyMT4Code\forexcollection\2020'
$TrgtRt = $PSScriptRoot + '\..\_MQL4_PREBUILD'

#PROCESSING forexcollection
#1.Create a temp folder to unzip contents
$TrgtRt = $TrgtRt + '\temp'  

If (-not( Test-Path -Path $TrgtRt)){
    
    $command   = "Delete from dbo.ForexCollection" 
    $database.ExecuteNonQuery($command)

    #Remove-Item $TrgtRt -Recurse -Force
    New-item $TrgtRt -ItemType directory

    $DirObjects=Get-ChildItem -Directory $PSScriptRoot+ $ZipSource -Depth 1
    ForEach ($SubDir in ($DirObjects | Where-Object{$_.PSIsContainer})){
        $SubDir.FullName
        Get-ChildItem  -Path $PSScriptRoot+$ZipSource\$SubDir -Filter '*.zip' |Foreach-Object{
            'Unzipping '+$_.FullName
            Expand-Archive -Path $_.FullName -DestinationPath $TrgtRt -Force
        }
    }

}
else{
    Write-Host('It looks like forexcollection\2020 has been unzipped.')
}

$DirObjects=Get-ChildItem -Directory $TrgtRt 
$LastPos = $DirObjects.Count
$ItemPos =1

#Check stage 1
$command = 'If(Select count([1_DeleteInstaltionManTxt] ) from dbo.ForexCollection where [1_DeleteInstaltionManTxt]=1)>1
            BEgin
                Select 1
            End 
            Else
            Begin
                Select 0
            End'

$DataTable = $database.ExecuteWithResults($command)
$Stage1=$DataTable.Tables[0].Rows[0].Column1

if($Stage1=0){
    ForEach ($SubDir in ($DirObjects)) { # | ?{$_.PSIsContainer})){

    
        foreach ($2 in ([System.IO.Directory]::EnumerateFiles($SubDir.FullName, '*.txt'))){
            [System.IO.File]::Delete($2)
        } 
        foreach ($2 in ([System.IO.Directory]::EnumerateFiles($SubDir.FullName, '*.htm'))){
            [System.IO.File]::Delete($2)
        }
        foreach ($2 in ([System.IO.Directory]::EnumerateFiles($SubDir.FullName, '*.html'))){
            [System.IO.File]::Delete($2)
        }
    
        $NoOfex4Files = [System.IO.Directory]::EnumerateFiles($SubDir.FullName, '*.ex4')| Measure-Object| ForEach-Object{$_.Count}
        $NoOfmq4Files = [System.IO.Directory]::EnumerateFiles($SubDir.FullName, '*.mq4')| Measure-Object| ForEach-Object{$_.Count}
        $NoOfSubFolder = [System.IO.Directory]::EnumerateDirectories($SubDir.FullName, '*')| Measure-Object| ForEach-Object{$_.Count}
        $CountTotalFiles = [System.IO.Directory]::EnumerateFiles($SubDir.FullName, '*.*')| Measure-Object| ForEach-Object{$_.Count}
    
        $SubDir.FullName
        'Item ' + $ItemPos + ' ' + ' of ' + $LastPos + ': ex4 =' +  $NoOfex4Files + ': mq4 =' + $NoOfmq4Files +' : TotalFileCount ='+ $CountTotalFiles + ': SubFolders =' +  $NoOfSubFolder
        $ItemPos = $ItemPos+1

        $command   =    "insert into dbo.ForexCollection(Name, NoOfex4, NoOfMq4, NoSubFolder,TotalCountOfFiles)
                        values ('$SubDir', $NoOfex4Files, $NoOfmq4Files, $NoOfSubFolder, $CountTotalFiles);"
    
        $database.ExecuteNonQuery($command)
    }

    #Mark unwanted folders
    $command   =    "Update dbo.ForexCollection 
                    Set [1_DeleteInstaltionManTxt] = 1 where
                    NoOfEx4 =0 and NoSubFolder=0 and NoofMQ4=0 and TotalCountOfFiles=0
                    "
    
    $dataset = $database.ExecuteNonQuery($command)
}
else{
    Write-Host('Stage 1 aleady complete.')
}

#Chceck stage 2 Build MT4 scripts
$command = 'If(Select count([2_DeleteEx4] ) from dbo.ForexCollection where [1_DeleteInstaltionManTxt]=1)>1
            BEgin
                Select 1
            End 
            Else
            Begin
                Select 0
            End'

$DataTable = $database.ExecuteWithResults($command)
$Stage2=$DataTable.Tables[0].Rows[0].Column1

$Levels = '/*' * 2
$DirObjects=Get-ChildItem -Directory $$TrgtRt/$Levels
ForEach ($SubDir in ($DirObjects | ?{$_.PSIsContainer})){


    if(($FilesCount -gt 0) -And ($FolderCount -eq 0))
    {
    
        if($MQLFilesNum -eq $EX4FileNum)
        {
            Get-ChildItem -Filter "*.mq4"|Foreach-Object{
                   Remove-Item $_.BaseName+".ex4";
                   Move-Item -Path $_.FullName -Destination $TrgtRt
            }
            
        }

    }
}
#Check for compilers 
<#
mql.exe [<flags>] filename.mq5
        /mql5     - compile mql5 source
        /mql4     - compile mql4 source
        /s        - syntax check only
        /i:<path> - set working directory
        /o        - use code optimizer
#>
#C:\Program Files\MetaTrader 5\metaeditor64.exe {[Path][Indicator Name].mql4} /mql4 /i:[Path]/log:[Indicator Name].log /compile
#eg

#queue the jobs
# How many jobs we should run simultaneously
$maxConcurrentJobs = 3;
$command="Select * from dbo.ForexCollection where [1_DeleteInstaltionManTxt]=1"
$DataResults = $database.ExecuteWithResults($command)

$data = $DataResults.Tables[0]
$queue = [System.Collections.Queue]::Synchronized( (New-Object System.Collections.Queue) )
foreach($row in $data){
    
}
#>

