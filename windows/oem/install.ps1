$ErrorActionPreference = "Stop"


$SSHPublicKey = Get-Content '\\host.lan\Data\id_rsa.pub'

function Set-SSHPublicKey {
    $authorizedKeysFile = Join-Path $env:ProgramData "ssh\administrators_authorized_keys"
    Set-Content -Path $authorizedKeysFile -Value $SSHPublicKey -Encoding ascii
    $acl = Get-Acl $authorizedKeysFile
    $acl.SetAccessRuleProtection($true, $false)
    $administratorsRule = New-Object system.security.accesscontrol.filesystemaccessrule("Administrators", "FullControl", "Allow")
    $systemRule = New-Object system.security.accesscontrol.filesystemaccessrule("SYSTEM", "FullControl", "Allow")
    $acl.SetAccessRule($administratorsRule)
    $acl.SetAccessRule($systemRule)
    $acl | Set-Acl
}

# Install OpenSSH
$(

Get-WindowsCapability -Online -Name OpenSSH* | Add-WindowsCapability -Online
Set-Service -Name sshd -StartupType Automatic
Start-Service sshd

# Authorize SSH key
Set-SSHPublicKey

# Set PowerShell as default shell
New-ItemProperty -Force -Path "HKLM:\SOFTWARE\OpenSSH" -PropertyType String `
                 -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
) *>$1 >> c:\output.txt

# get latest download url for git-for-windows 64-bit exe
$git_url = "https://api.github.com/repos/git-for-windows/git/releases/latest"
$asset = Invoke-RestMethod -Method Get -Uri $git_url | % assets | where name -like "*64-bit.exe"
# download installer
$installer = "$env:temp\$($asset.name)"
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $installer
# run installer
$git_install_inf = "<install inf file>"
$install_args = "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=""$git_install_inf"""
Start-Process -FilePath $installer -ArgumentList $install_args -Wait
[System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
