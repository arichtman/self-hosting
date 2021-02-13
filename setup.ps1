
#Read in our info

Install-Module powershell-yaml
Import-Module powershell-yaml
$Secrets = Get-Content .\secrets.yml | ConvertFrom-Yaml
$Config = Get-Content .\config.yml | ConvertFrom-Yaml

# Create key if needed TODO: Find a noclobber option for ssh-keygen
$KeyFilePath = "{0}\.ssh\{1}" -f $Home, $Config.instanceName
if ( -Not $(Test-Path $KeyFilePath) ) { ssh-keygen -t ed25519 -f $KeyFilePath -N $Secrets.keyPassphrase }

#region ConfigureInfra

Install-Module -Name HetznerCloud -Force -Scope CurrentUser
Import-Module -Name HetznerCloud

# Authenticate
$SecureString = ConvertTo-SecureString $Secrets.apiToken -AsPlainText -Force
Set-HetznerCloud -Token $SecureString

# Add key
Add-HetznerCloudSshKey -Name $Config.instanceName -PublicKey $(Get-Content -Raw "${KeyFilePath}.pub")
# In order for the module to update it's validation sets to allow that new key we have to reload it, which also wipes your auth.
Import-Module -Name HetznerCloud -Force
Set-HetznerCloud -Token $SecureString

$Server = New-HetznerCloudServer -Name $Config.instanceName -Type $Config.machineModel -Image $Config.imageName -SshKey $Config.instanceName -Datacenter $Config.dataCenter
ConvertTo-Yaml $Server | Set-Content -Path $(".\output\{0}.yml" -f $Config.instanceName)
$DNSAddress = $Server.public_net.ipv4.dns_ptr
#endregion

#region ConfigureSSH

# Install 
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile Ubuntu.appx -UseBasicParsing
Add-AppxPackage .\Ubuntu.appx
Remove-Item -Force .\Ubuntu.appx

# Set OpenSSH host alias, identity file, and user
Install-Module -Name EPS -Force -Scope CurrentUser
Import-Module EPS
Invoke-EpsTemplate -Path .\config.eps | Add-Content -Path "$Home\.ssh\config"

# Override fingerprint to known hosts
ForEach ($Address in @($DNSAddress, $Server.public_net.ipv4.ip)) {
    ssh-keygen -R $Address | Out-Null
    ssh-keyscan -H $Address | Add-Content -Path "$Home\.ssh\known_hosts"
}

# TODO: Finish adding the key passphrase to the agent for non interactive login
Set-Service sshd -StartupType Automatic
Start-Service sshd
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent

# Remote in and do the actual setup
Write-Host "You are about to be prompted to enter your key passphrase." -ForegroundColor Green
Write-Host "This will then add your private key to the ssh agent, and log in to configure the server. The value you need has been added to your clipboard for convenience."

Set-Clipboard -Value $Secrets.keyPassphrase
ssh-add $KeyFilePath
Set-Clipboard -Value $null
Get-Content -Raw .\vscode-server-setup.sh | ssh $Config.instanceName

#endregion

#region ConfigureVSC
$Extensions = @(
    "ms-vscode-remote.remote-containers",
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-ssh-edit",
    "ms-vscode-remote.remote-wsl",
    "ms-vscode-remote.vscode-remote-extensionpack"
)

Install-Script Install-VSCode -Scope CurrentUser -Force
Install-VSCode.ps1 -AdditionalExtensions $Extensions

$SettingsFile = '.\.vscode\settings.json'

$Settings = Get-Content -Raw $SettingsFile | ConvertFrom-Json

$DesiredSettings = @{
    "remote.SSH.configFile" = "$Home\.ssh\config"
    "docker.host"           = "ssh://root@$DNSAddress"
    #TODO: Nested JSON - this just dumps an escaped string
    #"remote.SSH.remotePlatform" = "{""$($Secrets.sshAlias)"": ""linux""}"
}

ForEach ( $NewEntry in $DesiredSettings.Keys) {
    Add-Member -InputObject $Settings -MemberType NoteProperty -Name $NewEntry -Value $DesiredSettings.Item($NewEntry) -Force
}

$Settings | ConvertTo-Json -depth 32 | Set-Content $SettingsFile

Write-Host "Now you should be able to connect Remote-SSH to the host."

#endregion
