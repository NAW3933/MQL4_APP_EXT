#Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Undefined
#Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned

#Get-ExecutionPolicy -List
# Determine script location for PowerShell

$ZipSource = $PSScriptRoot+'\_3rdPartyMT4Code\forexcollection\2020'
$TrgtRt = $PSScriptRoot + '\..\_MQL4_PREBUILD'
$MQLFilesNum=0
$EX4FileNum=0


#PROCESSING forexcollection
#1.Create a temp folder to unzip contents
$TrgtRt = $TrgtRt + '\temp'  

If (-not( Test-Path -Path $TrgtRt)){
    
    #Remove-Item $TrgtRt -Recurse -Force
    New-item $TrgtRt -ItemType directory

    $DirObjects=Get-ChildItem -Directory $ZipSource -Depth 1
    ForEach ($SubDir in ($DirObjects | ?{$_.PSIsContainer})){
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

    $NoOfex4Files = [System.IO.Directory]::EnumerateFiles($SubDir.FullName, '*.ex4')| Measure-Object| %{$_.Count}
    $NoOfmq4Files = [System.IO.Directory]::EnumerateFiles($SubDir.FullName, '*.mq4')| Measure-Object| %{$_.Count}
    $NoOfSubFolder = [System.IO.Directory]::EnumerateDirectories($SubDir.FullName, '*')| Measure-Object| %{$_.Count}
    
    $SubDir.FullName
    'Item ' + $ItemPos + ' ' + ' of ' + $LastPos + ': ex4 =' +  $NoOfex4Files + ': mq4 =' + $NoOfmq4Files + ': SubFolders =' +  $NoOfSubFolder
    $ItemPos = $ItemPos+1

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



