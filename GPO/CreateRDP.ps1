# Список соответствия групп доступа и терминальных серверов
$GroupsAndServers = @{
    # Группа доступа    # DNS-имя сервера
    'G_TermSrv1'      = 'TerminalServer1';
    'G_TermSrv2'      = 'TerminalServer2';
    'G_TermSrv3'      = 'TerminalServer3';
    'G_TermSrv4'      = 'TerminalServer4';
    'G_TermSrv5'      = 'TerminalServer5';
    'G_TermSrv6'      = 'TerminalServer6';
    'G_TermSrv7'      = 'TerminalServer7';
    'G_TermSrv8'      = 'TerminalServer8';
    'G_TermSrv9'      = 'TerminalServer9'
}

function CreateRDPFile {
    <#
    .SYNOPSIS
    Создаёт RDP-файл, для указанного сервера, на рабочем столе запустившего пользователя

    .DESCRIPTION

    .EXAMPLE
    CreateRDPFile -Server 'ServerName'
    #>

    param (
        [Parameter(Mandatory = $true)]
        [String]$Server
    )

    # Путь к создаваемому файлу. По умолчанию - Рабочий стол текущего пользователя.
    # Например C:\Users\ipetrov\Desktop\ServerName.rdp
    $PathFile = [Environment]::GetFolderPath("Desktop") + '\' + $Server + '.rdp'

    # Шаблон RDP-файла
    $template = @(
        'screen mode id:i:2'
        'use multimon:i:0'
        'desktopwidth:i:1920'
        'desktopheight:i:1080'
        'session bpp:i:32'
        'winposstr:s:0,1,-1920,48,-493,1047'
        'compression:i:1'
        'keyboardhook:i:2'
        'audiocapturemode:i:0'
        'videoplaybackmode:i:1'
        'connection type:i:7'
        'networkautodetect:i:1'
        'bandwidthautodetect:i:1'
        'displayconnectionbar:i:1'
        'enableworkspacereconnect:i:0'
        'disable wallpaper:i:0'
        'allow font smoothing:i:0'
        'allow desktop composition:i:0'
        'disable full window drag:i:1'
        'disable menu anims:i:1'
        'disable themes:i:0'
        'disable cursor setting:i:0'
        'bitmapcachepersistenable:i:1'
        'full address:s:'
        'audiomode:i:2'
        'redirectprinters:i:1'
        'redirectcomports:i:0'
        'redirectsmartcards:i:0'
        'redirectclipboard:i:1'
        'redirectposdevices:i:0'
        'autoreconnection enabled:i:1'
        'authentication level:i:2'
        'prompt for credentials:i:0'
        'negotiate security layer:i:1'
        'remoteapplicationmode:i:0'
        'alternate shell:s:'
        'shell working directory:s:'
        'gatewayhostname:s:'
        'gatewayusagemethod:i:4'
        'gatewaycredentialssource:i:4'
        'gatewayprofileusagemethod:i:0'
        'promptcredentialonce:i:0'
        'gatewaybrokeringtype:i:0'
        'use redirection server name:i:0'
        'rdgiskdcproxy:i:0'
        'kdcproxyname:s:'
        'drivestoredirect:s:*'
        'server port:i:3389'
    )

    # Проверка существования RDP-файла
    if (!(Test-Path -PathType Leaf -Path $PathFile)) {
        # Если отсутствует - сформирвать RDP-файл
        $template = $template | ForEach-Object {
            # Разделение каждой строки шаблона на составляющие
            $newLine = $_.Split(":")
            # Подстановка имени сервера в нужную строку
            If ($newLine[0] -eq "full address") {
                "$($newLine[0]):$($newLine[1]):$($Server)"
            }
            # Подстановка имени пользователя
            elseif ($newLine[0] -eq "username") {
                "$($newLine[0]):$($newLine[1]):domain\$($env:USERNAME)"
            }
            # При необходимости, можно добавить обработку других строк с парамерами
            # Например:
            # elseif ($newLine[0] -eq "server port") {
            #    "$($newLine[0]):$($newLine[1]):$($ServerPort)"
            #}
            else {
                "$($newLine[0]):$($newLine[1]):$($newLine[2])"
            }
        }
        # Запись измененного шаблона в готовый RDP-файл
        $template | Set-Content -Path $PathFile
    }
}

# Получение всех групп в которые входит пользователь
$userGroups = ([ADSISEARCHER]"samaccountname=$($env:USERNAME)").Findone().Properties.memberof -replace '^CN=([^,]+).+$', '$1'

# Проверка наличия прав доступа к терминальным серверам
$userGroups | ForEach-Object {
    if ($GroupsAndServers[$_]) {
        # Вызов функции создания RDP-файла
        CreateRDPFile -Server $GroupsAndServers[$_]
    }
}
