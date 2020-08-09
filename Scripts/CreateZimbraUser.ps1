#Install-Module -Name Posh-SSH
Import-Module Posh-SSH

# Необходимо быть членом группы sudo
$SSHUser = "ssh_user"
$SSHPasswd = "ssh_user_password"
$SSHHost = "192.168.0.1"

# Достаточно прав для чтения домена
$ADReadUser = "ad-read_user"
$ADReadUser_Password = "ad_read_user_password"
$ADHost = "local.example.com"

# Имя и домен для нового пользователя
$zUser = "nik2test"
$zDomain = "example.com"


$SSHADReadUser_password = ConvertTo-SecureString $SSHPasswd -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($SSHUser, $SSHADReadUser_password)
$SSHSession = New-SSHSession -ComputerName $SSHHost -Credential $creds
$SSHStream = New-SSHShellStream -SSHSession $SSHSession

$ADReadUser_password = ConvertTo-SecureString $ADReadUser_Password -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ($ADReadUser, $ADReadUser_password)
$ADUser = Get-ADUser -Identity $zUser -Server $ADHost -Credential $mycreds -Properties *


$mail = $ADUser.SamAccountName + "@$($zDomain)" # nik2test@example.com
$GivenName = $ADUser.GivenName # Nik
$Surname = $ADUser.Surname # 2Test
$DisplayName = $ADUser.DisplayName # Nik 2Test
$Description = $ADUser.Description # Test description
$Title = $ADUser.Title # Test user

$zCommand = 'sudo /opt/zimbra/bin/zmprov ca ' + $mail + ' "" givenName "' + $GivenName + '" sn "' + $Surname + '" title "' + $Title + '" description "' + $Description + '" displayname "' + $DisplayName + '" zimbraPrefFromDisplay "' + $DisplayName + '"'
# локаль пользователя дожна быть английской
$sudoPassPropmp = "[sudo] password for $($SSHUser):"
Invoke-SSHStreamExpectSecureAction -ShellStream $SSHStream -Command $zCommand -ExpectString $sudoPassPropmp -SecureAction $SSHADReadUser_password | Out-Nul
Start-Sleep -Seconds 10
$SSHStream.Read()

Remove-SSHSession -SSHSession $SSHSession | Out-Null