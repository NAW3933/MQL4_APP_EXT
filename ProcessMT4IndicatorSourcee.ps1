
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
$Depth = 3
$Root = 'C:\forexcollection\2020'
$TrgtRt = ''
$MQLFilesNum= 0
$EX4FileNum=0

$Levels = '/*' * 2
$DirObjects=Get-ChildItem -Directory $Root/$Levels
ForEach ($SubDir in ($DirObjects | ?{$_.PSIsContainer})){

    $ObjectCount = Get-ChildItem $SubDir -Recurse | Measure-Object | %{$_.Count}
    $FolderCount = Get-ChildItem $SubDir -Recurse -Directory | Measure-Object| %{$_.Count}
    $FilesCount = Get-ChildItem $SubDir -Recurse -File | Measure-Object| %{$_.Count}
    
    $MQLFilesNum= Get-ChildItem $SubDir -Recurse -File -Filter *.MQ4| Measure-Object| %{$_.Count}
    $EX4FileNum = Get-ChildItem $SubDir -Recurse -File -Filter *.MQ4| Measure-Object| %{$_.Count}


    if(($FilesCount -eq 2) -And ($FolderCount -eq 0))
    {
 
        $FolderCount
        $FileCount
        
        ''
        $SubDir.Name
        #'-----------------------------------------------------------------------------'
        #Get-ChildItem -Path $SubDir.FullName -Recurse | Where-Object {$_.PSIsContainer -eq $false}  
        #$MQLFilesNum.ToString() + ' MQL files'
        #$EX4FileNum.ToString() + ' EX4 files'
        
        if($MQLFilesNum -eq 1 -and $EX4FileNum -eq 1)
        {
            'HERE'
            Get-ChildItem -Path $SubDir.FullName -Recurse | Where-Object {$_.PSIsContainer -eq $false}
        }
    }


    <#
    if (-not(Test-Path -Path $SubDir/Indicator)){  
        $SubDir.FullName
    } else {
        #"Path doesn't exist."
    }
    #>
    
}

