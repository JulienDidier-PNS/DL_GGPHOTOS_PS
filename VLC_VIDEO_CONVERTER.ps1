$folderpath = "D:\photos\Julien\"
#EXTRACTION DES ARCHIVES DANS LES DOSSIERS RESPECTIFS
#CONVERSION VIDEOS

$nbFichiers = 0

Get-ChildItem $folderpath | ForEach-Object{
    if ([IO.Path]::GetExtension($_.Name) -eq ".MP4" -or [IO.Path]::GetExtension($_.Name) -eq ".MOV"){$nbFichiers++}
}

Get-ChildItem $folderpath | ForEach-Object{
    if ([IO.Path]::GetExtension($_.Name) -eq ".MP4" -or [IO.Path]::GetExtension($_.Name) -eq ".MOV"){
        $filename = $([System.IO.Path]::GetFileNameWithoutExtension($_.FullName))
        $filepath = $_.FullName

        Write-Output "*************************"
        Write-Output "Conversion de -> "$_.FullName
        Write-Output "*************************"

        $filename_converted = $filename + "_converted"
        $final_path = "$folderpath$filename_converted.mp4"
        #Write-Output "$final_path"

       vlc -I dummy $ filepath --sout="#transcode{vcodec=h264,vb=4096,acodec=mp4a,ab=128,channels=2,samplerate=44100}:file{dst=$final_path}" vlc://quit
       $nid = (Get-Process vlc).Id
       Wait-Process -Id $nid

        $origin_size = (Get-Item $_.FullName).Length/1MB
        $convert_size = (Get-Item $final_path).Length/1MB
        Write-Output("Non compréssé : "+ (Get-Item $_.FullName).Length/1MB)
        Write-Output("Compréssé : " + (Get-Item $final_path).Length/1MB)

        if ((Test-Path $final_path -PathType leaf)){
            if($origin_size -lt $convert_size){Remove-Item $final_path -Force}
            else{Remove-Item $_.FullName -Force}
        }        
    }
}