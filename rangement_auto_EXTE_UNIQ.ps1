#SAME CODE FOR ONE USER
#ADDING PARAMETER PROCESSING

if($args.Count -ne 3){
    Write-Output 'ENTRER DANS CET ORDRE : NOM DE LA PERSONNE / ANNEE / MOIS ' 
    exit
}

Install-Module -Name Posh-SSH
Import-Module "<YOUR GOOGLE_PHOTO_MODULE>"

#$user= Read-Host -Prompt 'Quel user ?'
$user = $args[0]

Write-Output 'ENTREZ LES LOGS DE LA CONNEXION SFTP'

$password = ConvertTo-SecureString "<SFTP_PASSWORD>" -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential ("<SFTP_LOGIN>", $password)

$SFTPSession = New-SFTPSession -ComputerName 1.1.1.1 -port 1 -Verbose -Credential $Cred

$annee = $args[1]
$mois = $args[2]
#$annee = Read-Host -Prompt 'Quelle année ?'
#$mois = Read-Host -Prompt 'Quel mois ?'
$moisN = (Get-Date).month

Write-Output '$user / $annee / $mois'

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
    Write-Output "****************************"
    Write-Output "Traitement pour : $user"
    Write-Output "****************************"
    
    #FOLDER WHERE PHOTOS WILL BE STORED
    $folderpath = "<YOUR_FOLDERPATH>"

    if(!(Test-Path -Path $folderpath)){
        New-Item -Path $folderpath -ItemType Directory
    }
    Write-Output "***TELECHARGEMENT DES MEDIAS***"
    #Get-GooglePhotos -SavePath $folderpath -Year $annee -Month $moisN -AccountOwner $user

    #CREATION DES DOSSIERS CORRESPONDANT SUR LA DESTINATION

    #Write-Output "SUPPRESSION DU DOSSIER : [ /homes/$user/Photos/$annee/$mois ] (SI DEJA CREE) "
    #Remove-SFTPItem -SFTPSession $SFTPSession -Path "/homes/$user/Photos/$annee/$mois" -Force

    if(!(Test-SFTPPath -SFTPSession $SFTPSession -Path "<SFTP_DESTINATION_PATH_DIRECTORY>")){
        Write-Output "CREATION DU NOUVEAU DOSSIER : [ <SFTP_DESTINATION_PATH_DIRECTORY> ] "
        New-SFTPItem -SFTPSession $SFTPSession -Path "<SFTP_DESTINATION_PATH_DIRECTORY>" -ItemType Directory
    }

    $nbFichiers=0
    $nbTraite=0
    Get-ChildItem  $folderpath | ForEach-Object{$nbFichiers++;}

    Write-Output "****************************"
    Write-Output "Traitement pour : $user"
    Write-Output "****************************"
    Write-Output "TRANSFERT SFTP"
    Get-ChildItem "<THE ARCHIVE YOU WANT TO PROCEED>" | ForEach-Object{
        Set-SFTPItem -SFTPSession $SFTPSession -Path $_.FullName -Destination "<SFTP_DESTINATION_PATH_DIRECTORY>" -Force
        $nbTraite++
        Write-Output " $nbTraite/$nbFichiers traités "
    }


pause 10