#Read in our special info
$Secrets = Get-Content -Raw '.\secrets.json' | ConvertFrom-Json

#region ConfigureInfra

ssh-keygen -t ed25519 -f "$Home\.ssh\hetzner"


<# TODO: configure virtual python environment
$venvName = 'hetzner'
pip install virtualenv==20.0.15 virtualenvwrapper-win==1.2.6 
mkvirtualenv $venvName
workon $venvName

New-Item -Path venv -ItemType Directory
virtualenv .\venv
source .\venv\bin\activate #>

pip install -r requirements.txt 
#TODO: Actually setup the infra xb
#python .\infra-setup.py

#endregion

#region ConfigureSSH

# Install 
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile Ubuntu.appx -UseBasicParsing
Add-AppxPackage .\Ubuntu.appx
Remove-Item -Force .\Ubuntu.appx

# Set OpenSSH host alias, identity file, and user
Install-Module -Name EPS
Import-Module EPS
Invoke-EpsTemplate -Path .\config.eps | Set-Content -Path "$Home\.ssh\config"

# Override/add fingerprint to known hosts
ssh-keygen -R $Secrets.ssh.hostAddress | Out-Null
ssh-keyscan -H $Secrets.ssh.hostAddress | Add-Content -Path "$Home\.ssh\known_hosts"

# Remote in and do the actual setup
Get-Content -Raw .\host-setup.sh | ssh $Secrets.ssh.hostAddress

#endregion

#region ConfigureVSC
$Extensions = @(
    ms-vscode-remote.remote-containers
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode-remote.remote-wsl
    ms-vscode-remote.vscode-remote-extensionpack
)

Install-Script Install-VSCode -Scope CurrentUser; Install-VSCode.ps1 -AdditionalExtensions $Extensions

$SettingsFile = '.\.vscode\settings.json'

$Settings = Get-Content -Raw $SettingsFile | ConvertFrom-Json

$DesiredSettings = @{
    "remote.SSH.configFile" = "$Home\.ssh\config"
    "docker.host"           = "ssh://root@$($Secrets.sshAlias)"
    #TODO: Nested JSON - this just dumps an escaped string
    #"remote.SSH.remotePlatform" = "{""$($Secrets.sshAlias)"": ""linux""}"
}

ForEach ( $NewEntry in $DesiredSettings.Keys) {
    Add-Member -InputObject $Settings -MemberType NoteProperty -Name $NewEntry -Value $DesiredSettings.Item($NewEntry)
}

$Settings | ConvertTo-Json -depth 32 | Set-Content $SettingsFile

Write-Host "Now you need to attempt to connect Remote-SSH to the host."
Write-Host "This will fail - this is ok. It is part of the process." -ForegroundColor Red

#endregion
