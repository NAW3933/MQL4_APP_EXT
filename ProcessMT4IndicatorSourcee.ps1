#RUN AS ADMINISTRATOR
#Set-ExecutionPolicy -Scope LocalMachine -ExecutionPolicy Undefined
#Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
#$PSVersionTable
#Get-ExecutionPolicy -List
#Invoke-WebRequest -Uri "http://system.data.sqlite.org/blobs/1.0.113.0/sqlite-netFx45-binary-x64-2012-1.0.113.0.zip" -OutFile C:\CODE\MQL4_APP_EXT\Dependancies\SQLLite\sqlite.zip
#Expand-Archive C:\CODE\MQL4_APP_EXT\Dependancies\SQLLite\sqlite.zip -DestinationPath C:\CODE\MQL4_APP_EXT\Dependancies\SQLLite\sqlite.net -Force
#[Reflection.Assembly]::LoadFile("C:\CODE\MQL4_APP_EXT\Dependancies\SQLLite\sqlite.net\System.Data.SQLite.dll")

[System.Data.SQLite.SQLiteConnection]::CreateFile($sDatabasePath)
$sDatabasePath = "C:\CODE\MQL4_APP_EXT\Dependancies\SQLLite\ForexCollection2000.sqlite"
[System.Data.SQLite.SQLiteConnection]::CreateFile($sDatabasePath)
$sDatabaseConnectionString = [string]::Format("data source={0}", $sDatabasePath)
$oSQLiteDBConnection = New-Object System.Data.SQLite.SQLiteConnection
$oSQLiteDBConnection.ConnectionString = $sDatabaseConnectionString
$oSQLiteDBConnection.open()

$oSQLiteDBCommand=$oSQLiteDBConnection.CreateCommand()
$oSQLiteDBCommand.Commandtext="create table IndicatorFolder 
    (   index int, 
        name varchar(100), 
        EX4 int,
        MQL4 int,
        SubFolders int )"
$oSQLiteDBCommand.CommandType = [System.Data.CommandType]::Text
$oSQLiteDBCommand.ExecuteNonQuery()

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

    $NoOfex4Files = [System.IO.Directory]::EnumerateFiles($SubDir.FullName, '*.ex4')| Measure-Object| ForEach-Object{$_.Count}
    $NoOfmq4Files = [System.IO.Directory]::EnumerateFiles($SubDir.FullName, '*.mq4')| Measure-Object| ForEach-Object{$_.Count}
    $NoOfSubFolder = [System.IO.Directory]::EnumerateDirectories($SubDir.FullName, '*')| Measure-Object| ForEach-Object{$_.Count}
    
    $SubDir.FullName
    'Item ' + $ItemPos + ' ' + ' of ' + $LastPos + ': ex4 =' +  $NoOfex4Files + ': mq4 =' + $NoOfmq4Files + ': SubFolders =' +  $NoOfSubFolder
    $ItemPos = $ItemPos+1

    <#
    $oSQLiteDBCommand.Commandtext="INSERT INTO IndicatorFolder (NAME , EX4, EX4, MQL4) VALUES (@BandName, @MyScore)";
    $oSQLiteDBCommand.Parameters.AddWithValue("BandName", "Kataklysm");
    $oSQLiteDBCommand.Parameters.AddWithValue("MyScore", 10);
    $oSQLiteDBCommand.ExecuteNonQuery()
    #>
}

$oSQLiteDBConnection.Close()

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



