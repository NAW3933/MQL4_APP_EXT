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
$command   = "Delete from dbo.ForexCollection" 
$database.ExecuteNonQuery($command)

$ZipSource = $PSScriptRoot+'\_3rdPartyMT4Code\forexcollection\2020'
$TrgtRt = $PSScriptRoot + '\..\_MQL4_PREBUILD'

#PROCESSING forexcollection
#1.Create a temp folder to unzip contents
$TrgtRt = $TrgtRt + '\temp'  

If (-not( Test-Path -Path $TrgtRt)){
    
    #Remove-Item $TrgtRt -Recurse -Force
    New-item $TrgtRt -ItemType directory

    $DirObjects=Get-ChildItem -Directory $ZipSource -Depth 1
    ForEach ($SubDir in ($DirObjects | Where-Object{$_.PSIsContainer})){
        $SubDir.FullName
        Get-ChildItem  -Path $ZipSource\$SubDir -Filter '*.zip' |Foreach-Object{
            'Unzipping '+$_.FullName
            Expand-Archive -Path $_.FullName -DestinationPath $TrgtRt -Force
        }
    }
}
else{
    Write-Host('It looks like forexcollection\2020 has been unzipped')
}

$DirObjects=Get-ChildItem -Directory $TrgtRt 
$LastPos = $DirObjects.Count
$ItemPos =1
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

<#
$Levels = '/*' * 2
$DirObjects=Get-ChildItem -Directory $Root/$Levels
ForEach ($SubDir in ($DirObjects | ?{$_.PSIsContainer})){

    $ObjectCount = Get-ChildItem $SubDir -Recurse | Measure-Object | %{$_.Count}
    $FolderCount = Get-ChildItem $SubDir -Recurse -Directory | Measure-Object| %{$_.Count}
    $FilesCount = Get-ChildItem $SubDir -Recurse -File | Measure-Object| %{$_.Count}
    
    $MQLFilesNum= Get-ChildItem $SubDir -Recurse -File -Filter *.MQ4| Measure-Object| %{$_.Count}
    $EX4FileNum = Get-ChildItem $SubDir -Recurse -File -Filter *.EX4| Measure-Object| %{$_.Count}


    if(($FilesCount -gt 0) -And ($FolderCount -eq 0))
    {
 
        #$FolderCount
        #$FileCount
        
        #''
        #$SubDir.Name
        #'-----------------------------------------------------------------------------'
        #Get-ChildItem -Path $SubDir.FullName -Recurse | Where-Object {$_.PSIsContainer -eq $false}  
        #$MQLFilesNum.ToString() + ' MQL files'
        #$EX4FileNum.ToString() + ' EX4 files'
        
        if($MQLFilesNum -eq $EX4FileNum)
        {
            Get-ChildItem -Filter "*.mq4"|Foreach-Object{
                   Remove-Item $_.BaseName+".ex4";
                   Move-Item -Path $_.FullName -Destination $TrgtRt
            }

            #Get-ChildItem -Filter "*.mq4"|Foreach-Object{
            #       Move-Item -Path $($_.FullName) -Destination $dstDir
            #}            
        }

    }
    if(($FilesCount -gt 0) -And ($FolderCount -eq 0))
    {
            Get-ChildItem |Foreach-Object{
                   Move-Item -Path $_.FullName -Destination $TrgtRt
            }    
    }
    #>
    <#
    if (-not(Test-Path -Path $SubDir/Indicator)){  
        $SubDir.FullName
    } else {
        #"Path doesn't exist."
    }
    #>



