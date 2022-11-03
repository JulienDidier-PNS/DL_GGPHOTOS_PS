#AUTHOR : Julien D.
#Last Modification date : 03/11/2022

# THIS SCRIPT ALLOWS TO DOWNLOAD CUSTOM DATE PERIOD FROM GOOGLE PHOTO TO LOCAL FOLDER AND UPLOAD IT TO AN SFTP SERVER 

Install-Module -Name Posh-SSH
Import-Module "<YOUR GOOGLE_PHOTO_MODULE>"

#User list is used if you want to use it on muliple account (for my use, i use it for all my family account)
$userslist=("Person A","Person B")

#Here is the SFTP IGNITION, COMPUTER NAME IS THE IP OF THE SERVER AND PORT THE PORT OF YOUR SERVER (CREDENTIAL ARE AUTOMATICALY ASKED)
$SFTPSession = New-SFTPSession -ComputerName 1.1.1.1 -port 1 -Verbose

#annee is the year in numbers -> ex : 2022
$annee = Read-Host -Prompt 'Quelle année ?'

#mois is the month -> ex : Septembre (THE SCRIPT WORKS ONLY IN FRENCH)
$mois = Read-Host -Prompt 'Quel mois ?'

#moisN convert the choosen month in number for command
$moisN = (Get-Date).month

switch ($mois) {
    "Janvier" { $moisN=1 }
    "Fevrier" { $moisN=2 }
    "Mars" { $moisN=3 }
    "Avril" { $moisN=4 }
    "Mai" { $moisN=5 }
    "Juin" { $moisN=6 }
    "Juillet" { $moisN=7 }
    "Aout" { $moisN=8 }
    "Septembre" { $moisN=9 }
    "Octobre" { $moisN=10 }
    "Novembre" { $moisN=11 }
    "Decembre" { $moisN=12 }
    Default {}
}

#EXTRACTION DES ARCHIVES DANS LES DOSSIERS RESPECTIFS
foreach($name in $userslist){
    Write-Output "****************************"
    Write-Output "Traitement pour : $name"
    Write-Output "****************************"

    
    #FOLDER WHERE PHOTOS WILL BE STORED
    $folderpath = "<YOUR_FOLDERPATH>"

    if(!(Test-Path -Path $folderpath)){
        New-Item -Path $folderpath -ItemType Directory
    }
    Write-Output "***TELECHARGEMENT DES MEDIAS***"

    #DOWNLOAD GOOGLE PHOTO PROCESS
    Get-GooglePhotos -SavePath $folderpath -Year $annee -Month $moisN -AccountOwner $name


    #CREATION DES DOSSIERS CORRESPONDANT SUR LA DESTINATION

    #Write-Output "SUPPRESSION DU DOSSIER : [ /homes/$name/Photos/$annee/$mois ] (SI DEJA CREE) "
    #Remove-SFTPItem -SFTPSession $SFTPSession -Path "/homes/$name/Photos/$annee/$mois" -Force
    
    if(!(Test-SFTPPath -SFTPSession $SFTPSession -Path "<SFTP_DESTINATION_PATH_DIRECTORY>")){
        Write-Output "CREATION DU NOUVEAU DOSSIER : [ <SFTP_DESTINATION_PATH_DIRECTORY> ] "
        New-SFTPItem -SFTPSession $SFTPSession -Path "<SFTP_DESTINATION_PATH_DIRECTORY>" -ItemType Directory
    }
}

foreach($name in $userslist){
    $nbFichiers=0
    $nbTraite=0
    Get-ChildItem  $folderpath | ForEach-Object{$nbFichiers++;}

    Write-Output "****************************"
    Write-Output "Traitement pour : $name"
    Write-Output "****************************"
    Write-Output "TRANSFERT SFTP"
    Get-ChildItem "<THE ARCHIVE YOU WANT TO PROCEED>" | ForEach-Object{
        Set-SFTPItem -SFTPSession $SFTPSession -Path $_.FullName -Destination "<SFTP_DESTINATION_PATH_DIRECTORY>" -Force
        $nbTraite++
        Write-Output " $nbTraite/$nbFichiers traités "
    }
}

pause 10