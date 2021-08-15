

$Depth = 3
$Root = 'C:\forexcollection\2020'
$Targe

$Levels = '/*' * 2
$DirObjects=Get-ChildItem -Directory $Root/$Levels
ForEach ($SubDir in ($DirObjects | ?{$_.PSIsContainer})){

    $ObjectCount=Get-ChildItem $SubDir -Recurse | Measure-Object | %{$_.Cou}
    
    $FolderCount = Get-ChildItem $SubDir -Recurse -Directory | Measure-Object | %{$_.Count}
    
    $FileCount= Get-ChildItem $SubDir -Recurse -File | Measure-Object | %{$_.Count}
    
    $Mql4Files =  Get-ChildItem $SubDir -Filter *.mql4| Measure-Object | %{$_.Count}
    
    $ex4Files = Get-ChildItem $SubDir -Filter *.ex4| Measure-Object | %{$_.Count}
    
    if(($FileCount.ToDecimal()=1) -And ($FolderCount=1))
    {
        ''
        $SubDir.Name
        '-----------------------------------------------------------------------------'
        Get-ChildItem -Path $SubDir.FullName -Recurse | Where-Object {$_.PSIsContainer -eq $false}  
    }


    <#
    if (-not(Test-Path -Path $SubDir/Indicator)){  
        $SubDir.FullName
    } else {
        #"Path doesn't exist."
    }
    #>
    
}

