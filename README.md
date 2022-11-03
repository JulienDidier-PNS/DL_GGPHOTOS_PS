# *************************************************************************
#  Download ⏬ photos from google photos and upload it via SFTP to my NAS
# *************************************************************************

I'm a beginner in the powershell langage and in the use of git 😏 be merciful

The Download GooglePhoto script is strongly inspired of this one 
https://github.com/PowershellPunk/GooglePhotosAPIPowershell/blob/master/Get-GooglePhotos.psm1
with some modifications :

- Errors are processed (if a download failed 7 times, the link to download it will be added in a txt file)
- Multiple account is possible
