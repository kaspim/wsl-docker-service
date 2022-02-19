## Installation notes

<details>
<summary>Import wsl image</summary>

### Import wsl image
- ``` mkdir $env:LOCALAPPDATA\Packages\wsl.docker.service\ ```
- ``` wsl --set-default-version 2 ```
- ``` wsl --import wsl-docker-service $env:LOCALAPPDATA\Packages\wsl.docker.service\ .\wsl-docker-service.tar ```
- ``` wsl --shutdown ```

</details>

<details>
<summary>Add windows support</summary>

### Add windows support
- copy ```docker.exe``` and ```docker-compose.exe``` to ```C:\Windows\System32\```

</details>

<details>
<summary>Unregister older version</summary>

### Unregister older version
- ``` wsl --unregister wsl-docker-service ```

</details>

## Usage notes
<details>
<summary>JetBrains IDEs</summary>

### JetBrains IDEs
![Connection settings](assets/docker_jetbrains_01.jpg?raw=true)
![Tool settings](assets/docker_jetbrains_02.jpg?raw=true)

</details>

## Articles and documentation
- [Import any Linux distribution to use with WSL](https://docs.microsoft.com/en-us/windows/wsl/use-custom-distro)
- [Configure per distro launch settings with wslconf](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-per-distro-launch-settings-with-wslconf)
- [Install Docker on Windows (WSL) without Docker Desktop](https://dev.to/bowmanjd/install-docker-on-windows-wsl-without-docker-desktop-34m9)