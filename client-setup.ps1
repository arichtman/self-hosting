$Extensions = @(
    ms-vscode-remote.remote-containers
    ms-vscode-remote.remote-ssh
    ms-vscode-remote.remote-ssh-edit
    ms-vscode-remote.remote-wsl
    ms-vscode-remote.vscode-remote-extensionpack
)

Install-Script Install-VSCode -Scope CurrentUser; Install-VSCode.ps1 -AdditionalExtensions $Extensions

pip install hcloud