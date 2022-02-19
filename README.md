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