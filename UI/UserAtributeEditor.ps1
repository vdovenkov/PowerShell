[void][Reflection.Assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')
[void][Reflection.Assembly]::Load('System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
[void][Reflection.Assembly]::Load('System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')

function Main {

    Param ([String]$Commandline)

    #--------------------------------------------------------------------------
    #TODO: Add initialization script here (Load modules and check requirements)
    #Requires -Modules ActiveDirectory
    ##Requires -RunAsAdministrator
    Import-Module ActiveDirectory -ErrorAction Stop
    $Global:ADConnectionState = $true

    #--------------------------------------------------------------------------

    if ((Show-MainForm_psf) -eq 'OK') {

    }

    $script:ExitCode = 0 #Set the exit code for the Packager
}


[byte[]]$global:pictureData = $null
$Global:ADConnectionState = $false
$Global:ChangePhoto = $false
$global:errorSearch = $false


function GetUserInfo {
    Param (
        [parameter(Mandatory = $true)]
        [string]$userName
    )
    Try {
        $getADUser = Get-ADUser $userName -Properties * -ErrorAction Stop
    }
    Catch [system.exception] {
        $global:errorSearch = $true
        $pictureboxPhoto.Image = $null
        $dialogResult = [System.Windows.Forms.MessageBox]::Show($($_.Exception.Message), "Внмание!", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        switch ($dialogResult) {
            "OK" {
                return
            }
        }
    }
    $pictureboxPhoto.Image = $getADUser.thumbnailPhoto
    $textboxName.Text = $getADUser.GivenName
    $textboxSurname.Text = $getADUser.Surname
    $textboxEmail.Text = $getADUser.mail
    $textboxPhone.Text = $getADUser.OfficePhone
    $textboxMobile.Text = $getADUser.MobilePhone
    $textboxFax.Text = $getADUser.Fax
    $textboxCountry.Text = $getADUser.Country
    $textboxCity.Text = $getADUser.City
    $textboxStreet.Text = $getADUser.StreetAddress
    $textboxHouse.Text = $getADUser.POBox
    $textboxOffice.Text = $getADUser.Office
    $textboxTitle.Text = $getADUser.Title
    $textboxDepartment.Text = $getADUser.Department
    $textboxManager.Text = $getADUser.Manager
    $textboxCompany.Text = $getADUser.Company
    $textboxDescription.Text = $getADUser.Description
    $textboxInfo.Text = $getADUser.info
    $textboxOU.Text = $getADUser.CanonicalName
    $infoBar.Text = ConvertUserAccountControl -UAC $getADUser.userAccountControl
    if ($getADUser.LockedOut) {
        $infoBar.Text += " | LockedOut"
    }
}

function UpdateUserPhoto {
    Param (
        [parameter(Mandatory = $true)]
        [string]$userName,
        $photo
    )
    try {
        Set-ADUser $userName -Replace @{ thumbnailPhoto = $photo; jpegPhoto = $photo } -ErrorAction Stop
    }
    catch {
        $dialogResult = [System.Windows.Forms.MessageBox]::Show($($_.Exception.Message), "Внмание!", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        switch ($dialogResult) {
            "OK" {
                return
            }
        }
    }

}


function UpdateUserInfo {
    Param (
        [parameter(Mandatory = $true)]
        [string]$userName
    )

    if ($textboxPhone.Text -ne [String]::Empty) {
        Set-ADUser -Identity $userName -OfficePhone $textboxPhone.Text
    }
    else {
        Set-ADUser -Identity $userName -OfficePhone $null
    }
    if ($textboxMobile.Text -ne [String]::Empty) {
        Set-ADUser -Identity $userName -MobilePhone $textboxMobile.Text
    }
    else {
        Set-ADUser -Identity $userName -MobilePhone $null
    }
    if ($textboxFax.Text -ne [String]::Empty) {
        Set-ADUser -Identity $userName -Fax $textboxFax.Text
    }
    else {
        Set-ADUser -Identity $userName -Fax $null
    }
    if ($textboxCountry.Text -ne [String]::Empty) {
        Set-ADUser -Identity $userName -Country $textboxCountry.Text
    }
    else {
        Set-ADUser -Identity $userName -Country $null
    }
    if ($textboxCity.Text -ne [String]::Empty) {
        Set-ADUser -Identity $userName -City $textboxCity.Text
    }
    else {
        Set-ADUser -Identity $userName -City $null
    }
    if ($textboxStreet.Text -ne [String]::Empty) {
        Set-ADUser -Identity $userName -StreetAddress $textboxStreet.Text
    }
    else {
        Set-ADUser -Identity $userName -StreetAddress $null
    }
    if ($textboxHouse.Text -ne [String]::Empty) {
        Set-ADUser -Identity $userName -POBox $textboxHouse.Text
    }
    else {
        Set-ADUser -Identity $userName -POBox $null
    }
    if ($textboxOffice.Text -ne [String]::Empty) {
        Set-ADUser -Identity $userName -Office $textboxOffice.Text
    }
    else {
        Set-ADUser -Identity $userName -Office $null
    }
    if ($textboxTitle.Text -ne [String]::Empty) {
        Set-ADUser -Identity $userName -Title $textboxTitle.Text
    }
    else {
        Set-ADUser -Identity $userName -Title $null
    }
    if ($textboxDepartment.Text -ne [String]::Empty) {
        Set-ADUser -Identity $userName -Department $textboxDepartment.Text
    }
    else {
        Set-ADUser -Identity $userName -Department $null
    }
    if ($textboxManager.Text -ne [String]::Empty) {
        if (Get-ADUser -Identity $textboxManager.Text) {
            Set-ADUser -Identity $userName -Manager $textboxManager.Text
        }
    }
    else {
        Set-ADUser -Identity $userName -Manager $null
    }
    if ($textboxCompany.Text -ne [String]::Empty) {
        Set-ADUser -Identity $userName -Company $textboxCompany.Text
    }
    else {
        Set-ADUser -Identity $userName -Company $null
    }
    if ($textboxDescription.Text -ne [String]::Empty) {
        Set-ADUser -Identity $userName -Description $textboxDescription.Text
    }
    else {
        Set-ADUser -Identity $userName -Description $null
    }
    if ($textboxInfo.Text -ne [String]::Empty) {
        Set-ADUser -Identity $userName -Replace @{ info = $textboxInfo.Text }
    }
    else {
        Set-ADUser -Identity $userName -Replace @{ info = "" }
    }
}

function Resize-Image {
    <#
	    .SYNOPSIS
	        Resize-Image resizes an image file

	    .DESCRIPTION
	    This function uses the native .NET API to resize an image file

	    .EXAMPLE
	    Resize the image to a specific size:
	        Resize-Image -InputFile "C:\userpic.jpg"
	    #>
    Param (
        [Parameter(Mandatory)]
        [string]$InputFile
    )
    $SquareHeight = 150
    $Quality = 85

    # Add System.Drawing assembly
    #Add-Type -AssemblyName System.Drawing

    # Open image file
    $Image = [System.Drawing.Image]::FromFile($InputFile)

    # Create empty square canvas for the new image
    # Calculate the offset for centering the image
    $OffsetY = 0
    $OffsetX = 0
    $SquareSide = if ($Image.Height -lt $Image.Width) {
        $Image.Width
    }
    else {
        $Image.Height
    }

    $SquareImage = New-Object System.Drawing.Bitmap($SquareSide, $SquareSide)
    $SquareImage.SetResolution($Image.HorizontalResolution, $Image.VerticalResolution)

    # Draw new image on the empty canvas
    $Canvas = [System.Drawing.Graphics]::FromImage($SquareImage)
    $Canvas.Clear([System.Drawing.Color]::White)
    $Canvas.DrawImage($Image, $OffsetX, $OffsetY)

    # Resize image
    $ResultImage = New-Object System.Drawing.Bitmap($SquareHeight, $SquareHeight)
    $Canvas = [System.Drawing.Graphics]::FromImage($ResultImage)
    $Canvas.Clear([System.Drawing.Color]::White)

    if ($Image.Width -lt $Image.Height) {
        $dx = ($SquareHeight - (($Image.Width * $SquareHeight) / $Image.Height)) / 2
        $dy = 0
    }
    else {
        $dx = 0
        $dy = ($SquareHeight - (($Image.Height * $SquareHeight) / $Image.Width)) / 2
    }

    $Canvas.DrawImage($SquareImage, $dx, $dy, $SquareHeight, $SquareHeight)

    $ImageCodecInfo = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object MimeType -eq 'image/jpeg'

    # https://msdn.microsoft.com/ru-ru/library/hwkztaft(v=vs.110).aspx
    $EncoderQuality = [System.Drawing.Imaging.Encoder]::Quality
    $EncoderParameters = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $EncoderParameters.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter($EncoderQuality, $Quality)

    $stream = New-Object System.IO.MemoryStream
    $ResultImage.Save($stream, $ImageCodecInfo, $EncoderParameters)
    $global:pictureData = $stream.ToArray()
    $stream.Dispose()
}

# https://support.microsoft.com/en-us/help/305144/how-to-use-useraccountcontrol-to-manipulate-user-account-properties
Function ConvertUserAccountControl ([int]$UAC) {
    $UACPropertyFlags = @(
        "SCRIPT",
        "ACCOUNTDISABLE",
        "RESERVED",
        "HOMEDIR_REQUIRED",
        "LOCKOUT",
        "PASSWD_NOTREQD",
        "PASSWD_CANT_CHANGE",
        "ENCRYPTED_TEXT_PWD_ALLOWED",
        "TEMP_DUPLICATE_ACCOUNT",
        "NORMAL_ACCOUNT",
        "RESERVED",
        "INTERDOMAIN_TRUST_ACCOUNT",
        "WORKSTATION_TRUST_ACCOUNT",
        "SERVER_TRUST_ACCOUNT",
        "RESERVED",
        "RESERVED",
        "DONT_EXPIRE_PASSWORD",
        "MNS_LOGON_ACCOUNT",
        "SMARTCARD_REQUIRED",
        "TRUSTED_FOR_DELEGATION",
        "NOT_DELEGATED",
        "USE_DES_KEY_ONLY",
        "DONT_REQ_PREAUTH",
        "PASSWORD_EXPIRED",
        "TRUSTED_TO_AUTH_FOR_DELEGATION",
        "RESERVED",
        "PARTIAL_SECRETS_ACCOUNT"
        "RESERVED"
        "RESERVED"
        "RESERVED"
        "RESERVED"
        "RESERVED"
    )
    $Attributes = ""
    0 .. ($UACPropertyFlags.Length) | Where-Object { $UAC -bAnd [math]::Pow(2, $_) } | ForEach-Object {
        if ($Attributes.Length -EQ 0) {
            $Attributes = $UACPropertyFlags[$_]
        }
        else {
            $Attributes = $Attributes + " | " + $UACPropertyFlags[$_]
        }
    }
    Return $Attributes
}

function Show-MainForm_psf {

    [void][reflection.assembly]::Load('System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089')
    [void][reflection.assembly]::Load('System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a')

    [System.Windows.Forms.Application]::EnableVisualStyles()
    $formHR = New-Object 'System.Windows.Forms.Form'
    $buttonClear = New-Object 'System.Windows.Forms.Button'
    $statusbar1 = New-Object 'System.Windows.Forms.StatusBar'
    $buttonApply = New-Object 'System.Windows.Forms.Button'
    $checkboxEdit = New-Object 'System.Windows.Forms.CheckBox'
    $labelSearch = New-Object 'System.Windows.Forms.Label'
    $buttonSearch = New-Object 'System.Windows.Forms.Button'
    $textboxSearch = New-Object 'System.Windows.Forms.TextBox'
    $groupbox1 = New-Object 'System.Windows.Forms.GroupBox'
    $labelOU = New-Object 'System.Windows.Forms.Label'
    $textboxOU = New-Object 'System.Windows.Forms.TextBox'
    $textboxInfo = New-Object 'System.Windows.Forms.TextBox'
    $textboxCompany = New-Object 'System.Windows.Forms.TextBox'
    $textboxDescription = New-Object 'System.Windows.Forms.TextBox'
    $textboxManager = New-Object 'System.Windows.Forms.TextBox'
    $labelManager = New-Object 'System.Windows.Forms.Label'
    $labelInfo = New-Object 'System.Windows.Forms.Label'
    $labelDescription = New-Object 'System.Windows.Forms.Label'
    $labelCompany = New-Object 'System.Windows.Forms.Label'
    $labelDepartment = New-Object 'System.Windows.Forms.Label'
    $textboxFax = New-Object 'System.Windows.Forms.TextBox'
    $labelFax = New-Object 'System.Windows.Forms.Label'
    $buttonOpenPhoto = New-Object 'System.Windows.Forms.Button'
    $textboxDepartment = New-Object 'System.Windows.Forms.TextBox'
    $textboxTitle = New-Object 'System.Windows.Forms.TextBox'
    $labelTitle = New-Object 'System.Windows.Forms.Label'
    $textboxOffice = New-Object 'System.Windows.Forms.TextBox'
    $labelOffice = New-Object 'System.Windows.Forms.Label'
    $textboxHouse = New-Object 'System.Windows.Forms.TextBox'
    $labelHouse = New-Object 'System.Windows.Forms.Label'
    $textboxStreet = New-Object 'System.Windows.Forms.TextBox'
    $labelStreet = New-Object 'System.Windows.Forms.Label'
    $textboxCity = New-Object 'System.Windows.Forms.TextBox'
    $labelCity = New-Object 'System.Windows.Forms.Label'
    $textboxCountry = New-Object 'System.Windows.Forms.TextBox'
    $labelCountry = New-Object 'System.Windows.Forms.Label'
    $textboxMobile = New-Object 'System.Windows.Forms.TextBox'
    $labelМобильный = New-Object 'System.Windows.Forms.Label'
    $textboxPhone = New-Object 'System.Windows.Forms.TextBox'
    $labelPhone = New-Object 'System.Windows.Forms.Label'
    $textboxEmail = New-Object 'System.Windows.Forms.TextBox'
    $labelEMail = New-Object 'System.Windows.Forms.Label'
    $textboxSurname = New-Object 'System.Windows.Forms.TextBox'
    $labelSurname = New-Object 'System.Windows.Forms.Label'
    $textboxName = New-Object 'System.Windows.Forms.TextBox'
    $labelName = New-Object 'System.Windows.Forms.Label'
    $pictureboxPhoto = New-Object 'System.Windows.Forms.PictureBox'
    $ADConnection = New-Object 'System.Windows.Forms.StatusBarPanel'
    $InfoBar = New-Object 'System.Windows.Forms.StatusBarPanel'
    $openPhoto = New-Object 'System.Windows.Forms.OpenFileDialog'
    $InitialFormWindowState = New-Object 'System.Windows.Forms.FormWindowState'
    #endregion Generated Form Objects

    #----------------------------------------------
    # User Generated Script
    #----------------------------------------------

    $formHR_Load = {
        #TODO: Initialize Form Controls here
        if ($global:ADConnectionState) {
            $ADConnection.Text = "Модули загружены"
        }

    }

    function ClearFilds {
        $checkboxEdit.Checked = $false
        $textboxName.Text = $null
        $textboxSurname.Text = $null
        $textboxEmail.Text = $null
        $textboxPhone.Text = $null
        $textboxMobile.Text = $null
        $textboxFax.Text = $null
        $textboxCountry.Text = $null
        $textboxCity.Text = $null
        $textboxStreet.Text = $null
        $textboxHouse.Text = $null
        $textboxOffice.Text = $null
        $textboxTitle.Text = $null
        $textboxDepartment.Text = $null
        $textboxManager.Text = $null
        $textboxDescription.Text = $null
        $textboxInfo.Text = $null
        $textboxOU.Text = $null
        $textboxCompany.Text = $null
        $InfoBar.Text = $null
        $pictureboxPhoto.Image = $null
    }

    function DisableEdit {
        $textboxSearch.ReadOnly = $true
        $buttonSearch.Enabled = $false

        $textboxPhone.ReadOnly = $false
        $textboxMobile.ReadOnly = $false
        $textboxFax.ReadOnly = $false
        $textboxCountry.ReadOnly = $false
        $textboxCity.ReadOnly = $false
        $textboxStreet.ReadOnly = $false
        $textboxHouse.ReadOnly = $false
        $textboxOffice.ReadOnly = $false
        $textboxTitle.ReadOnly = $false
        $textboxDepartment.ReadOnly = $false
        $textboxManager.ReadOnly = $false
        $textboxCompany.ReadOnly = $false
        <#$comboboxOformlenie.Enabled = $true
		$comboboxCorp.Enabled = $true
		$comboboxSubcluster.Enabled = $true#>
        $textboxDescription.ReadOnly = $false
        $textboxInfo.ReadOnly = $false
        $buttonOpenPhoto.Enabled = $true
        $buttonApply.Enabled = $true
    }

    function EnableEdit {
        $textboxSearch.ReadOnly = $false
        $buttonSearch.Enabled = $true

        $textboxPhone.ReadOnly = $true
        $textboxMobile.ReadOnly = $true
        $textboxFax.ReadOnly = $true
        $textboxCountry.ReadOnly = $true
        $textboxCity.ReadOnly = $true
        $textboxStreet.ReadOnly = $true
        $textboxHouse.ReadOnly = $true
        $textboxOffice.ReadOnly = $true
        $textboxTitle.ReadOnly = $true
        $textboxDepartment.ReadOnly = $true
        $textboxManager.ReadOnly = $true
        $textboxCompany.ReadOnly = $true
        <#$comboboxOformlenie.Enabled = $false
		$comboboxCorp.Enabled = $false
		$comboboxSubcluster.Enabled = $false#>
        $textboxDescription.ReadOnly = $true
        $textboxInfo.ReadOnly = $true
        $buttonOpenPhoto.Enabled = $false
        $buttonApply.Enabled = $false
    }

    # Enable/Disable edit user info
    function ChangeEnableEdit {
        if ($checkboxEdit.Checked) {
            DisableEdit
        }
        else {
            EnableEdit
        }
    }

    $checkboxEdit_CheckedChanged = {
        #TODO: Place custom script here
        ChangeEnableEdit
        #if ($textboxSearch.Text -and ($checkboxEdit.Checked -eq $false)) { GetUserInfo -userName $textboxSearch.Text }
    }

    $buttonSearch_Click = {
        #TODO: Place custom script here
        ClearFilds
        if ($textboxSearch.Text) {
            GetUserInfo -userName $textboxSearch.Text
            $textboxSearch.Enabled = $false
            $buttonSearch.Enabled = $false
        }
        else {
            $textboxSearch.Enabled = $true
            $buttonSearch.Enabled = $true
        }
        if ($global:errorSearch) {
            $textboxSearch.Enabled = $true
            #$textboxSearch.Text = $null
            $buttonSearch.Enabled = $true
        }

    }

    $buttonApply_Click = {
        #TODO: Place custom script here
        $dialogResult = [System.Windows.Forms.MessageBox]::Show("Обновить данные пользователя $($textboxSearch.Text)?", "Внмание!", [System.Windows.Forms.MessageBoxButtons]::OKCancel, [System.Windows.Forms.MessageBoxIcon]::Warning)
        switch ($dialogResult) {
            "OK" {
                if ($checkboxEdit.Checked = $true) {
                    $checkboxEdit.Checked = $false
                    ChangeEnableEdit
                }
                if ($Global:ChangePhoto) {
                    UpdateUserInfo -userName $textboxSearch.Text
                    UpdateUserPhoto -userName $textboxSearch.Text -photo $pictureData
                }
                else {
                    UpdateUserInfo -userName $textboxSearch.Text
                }
                if ($textboxSearch.Text) { GetUserInfo -userName $textboxSearch.Text }
                $textboxSearch.Enabled = $true
                $buttonSearch.Enabled = $true
                $Global:ChangePhoto = $false
            }
            "Cancel" {
                return
            }
        }
    }


    $buttonOpenPhoto_Click = {
        #TODO: Place custom script here
        $openPhoto.ShowDialog()

    }

    $openPhoto_FileOk = [System.ComponentModel.CancelEventHandler] {
        #Event Argument: $_ = [System.ComponentModel.CancelEventArgs]
        #TODO: Place custom script here
        Resize-Image -InputFile (get-item $openPhoto.FileName)
        $pictureboxPhoto.Image = $pictureData
        $Global:ChangePhoto = $true
    }

    $buttonClear_Click = {
        #TODO: Place custom script here
        $textboxSearch.Enabled = $true
        $textboxSearch.Text = $null
        $buttonSearch.Enabled = $true
        ClearFilds
    }


    # --End User Generated Script--
    #----------------------------------------------
    #region Generated Events
    #----------------------------------------------

    $Form_StateCorrection_Load =
    {
        #Correct the initial state of the form to prevent the .Net maximized form issue
        $formHR.WindowState = $InitialFormWindowState
    }

    $Form_StoreValues_Closing =
    {
        #Store the control values
        $script:MainForm_checkboxEdit = $checkboxEdit.Checked
        $script:MainForm_textboxSearch = $textboxSearch.Text
        $script:MainForm_textboxOU = $textboxOU.Text
        $script:MainForm_textboxInfo = $textboxInfo.Text
        $script:MainForm_textboxCompany = $textboxCompany.Text
        $script:MainForm_textboxDescription = $textboxDescription.Text
        $script:MainForm_textboxManager = $textboxManager.Text
        $script:MainForm_textboxFax = $textboxFax.Text
        $script:MainForm_textboxDepartment = $textboxDepartment.Text
        $script:MainForm_textboxTitle = $textboxTitle.Text
        $script:MainForm_textboxOffice = $textboxOffice.Text
        $script:MainForm_textboxHouse = $textboxHouse.Text
        $script:MainForm_textboxStreet = $textboxStreet.Text
        $script:MainForm_textboxCity = $textboxCity.Text
        $script:MainForm_textboxCountry = $textboxCountry.Text
        $script:MainForm_textboxMobile = $textboxMobile.Text
        $script:MainForm_textboxPhone = $textboxPhone.Text
        $script:MainForm_textboxEmail = $textboxEmail.Text
        $script:MainForm_textboxSurname = $textboxSurname.Text
        $script:MainForm_textboxName = $textboxName.Text
    }


    $Form_Cleanup_FormClosed =
    {
        #Remove all event handlers from the controls
        try {
            $buttonClear.remove_Click($buttonClear_Click)
            $buttonApply.remove_Click($buttonApply_Click)
            $checkboxEdit.remove_CheckedChanged($checkboxEdit_CheckedChanged)
            $buttonSearch.remove_Click($buttonSearch_Click)
            $buttonOpenPhoto.remove_Click($buttonOpenPhoto_Click)
            $formHR.remove_Load($formHR_Load)
            $openPhoto.remove_FileOk($openPhoto_FileOk)
            $formHR.remove_Load($Form_StateCorrection_Load)
            $formHR.remove_Closing($Form_StoreValues_Closing)
            $formHR.remove_FormClosed($Form_Cleanup_FormClosed)
        }
        catch { Out-Null <# Prevent PSScriptAnalyzer warning #> }
    }
    #endregion Generated Events

    #----------------------------------------------
    #region Generated Form Code
    #----------------------------------------------
    $formHR.SuspendLayout()
    $groupbox1.SuspendLayout()
    $ADConnection.BeginInit()
    $InfoBar.BeginInit()
    #
    # formHR
    #
    $formHR.Controls.Add($buttonClear)
    $formHR.Controls.Add($statusbar1)
    $formHR.Controls.Add($buttonApply)
    $formHR.Controls.Add($checkboxEdit)
    $formHR.Controls.Add($labelSearch)
    $formHR.Controls.Add($buttonSearch)
    $formHR.Controls.Add($textboxSearch)
    $formHR.Controls.Add($groupbox1)
    $formHR.AutoScaleDimensions = '6, 13'
    $formHR.AutoScaleMode = 'Font'
    $formHR.ClientSize = '499, 587'
    $formHR.FormBorderStyle = 'FixedSingle'
    $formHR.MaximizeBox = $False
    $formHR.Name = 'formHR'
    $formHR.Text = 'HR: Редактор атрибутов пользователя'
    $formHR.add_Load($formHR_Load)
    #
    # buttonClear
    #
    $buttonClear.Location = '417, 11'
    $buttonClear.Name = 'buttonClear'
    $buttonClear.Size = '75, 23'
    $buttonClear.TabIndex = 2
    $buttonClear.Text = 'Сброс'
    $buttonClear.UseCompatibleTextRendering = $True
    $buttonClear.UseVisualStyleBackColor = $True
    $buttonClear.add_Click($buttonClear_Click)
    #
    # statusbar1
    #
    $statusbar1.Location = '0, 565'
    $statusbar1.Name = 'statusbar1'
    [void]$statusbar1.Panels.Add($ADConnection)
    [void]$statusbar1.Panels.Add($InfoBar)
    $statusbar1.ShowPanels = $True
    $statusbar1.Size = '499, 22'
    $statusbar1.TabIndex = 7
    $statusbar1.Text = 'statusbar1'
    #
    # buttonApply
    #
    $buttonApply.Enabled = $False
    $buttonApply.Location = '408, 536'
    $buttonApply.Name = 'buttonApply'
    $buttonApply.Size = '75, 23'
    $buttonApply.TabIndex = 4
    $buttonApply.Text = 'Применить'
    $buttonApply.UseCompatibleTextRendering = $True
    $buttonApply.UseVisualStyleBackColor = $True
    $buttonApply.add_Click($buttonApply_Click)
    #
    # checkboxEdit
    #
    $checkboxEdit.Location = '174, 536'
    $checkboxEdit.Name = 'checkboxEdit'
    $checkboxEdit.Size = '224, 24'
    $checkboxEdit.TabIndex = 3
    $checkboxEdit.Text = 'Редактировать данные пользователя'
    $checkboxEdit.UseCompatibleTextRendering = $True
    $checkboxEdit.UseVisualStyleBackColor = $True
    $checkboxEdit.add_CheckedChanged($checkboxEdit_CheckedChanged)
    #
    # labelSearch
    #
    $labelSearch.AutoSize = $True
    $labelSearch.Location = '12, 16'
    $labelSearch.Name = 'labelSearch'
    $labelSearch.Size = '35, 17'
    $labelSearch.TabIndex = 2
    $labelSearch.Text = 'Логин'
    $labelSearch.UseCompatibleTextRendering = $True
    #
    # buttonSearch
    #
    $buttonSearch.Location = '335, 11'
    $buttonSearch.Name = 'buttonSearch'
    $buttonSearch.Size = '75, 23'
    $buttonSearch.TabIndex = 1
    $buttonSearch.Text = 'Найти'
    $buttonSearch.UseCompatibleTextRendering = $True
    $buttonSearch.UseVisualStyleBackColor = $True
    $buttonSearch.add_Click($buttonSearch_Click)
    #
    # textboxSearch
    #
    $textboxSearch.CharacterCasing = 'Lower'
    $textboxSearch.Location = '53, 13'
    $textboxSearch.Name = 'textboxSearch'
    $textboxSearch.Size = '271, 20'
    $textboxSearch.TabIndex = 0
    #
    # groupbox1
    #
    $groupbox1.Controls.Add($labelOU)
    $groupbox1.Controls.Add($textboxOU)
    $groupbox1.Controls.Add($textboxInfo)
    $groupbox1.Controls.Add($textboxCompany)
    $groupbox1.Controls.Add($textboxDescription)
    $groupbox1.Controls.Add($textboxManager)
    $groupbox1.Controls.Add($labelManager)
    $groupbox1.Controls.Add($labelInfo)
    $groupbox1.Controls.Add($labelDescription)
    $groupbox1.Controls.Add($labelCompany)
    $groupbox1.Controls.Add($labelDepartment)
    $groupbox1.Controls.Add($textboxFax)
    $groupbox1.Controls.Add($labelFax)
    $groupbox1.Controls.Add($buttonOpenPhoto)
    $groupbox1.Controls.Add($textboxDepartment)
    $groupbox1.Controls.Add($textboxTitle)
    $groupbox1.Controls.Add($labelTitle)
    $groupbox1.Controls.Add($textboxOffice)
    $groupbox1.Controls.Add($labelOffice)
    $groupbox1.Controls.Add($textboxHouse)
    $groupbox1.Controls.Add($labelHouse)
    $groupbox1.Controls.Add($textboxStreet)
    $groupbox1.Controls.Add($labelStreet)
    $groupbox1.Controls.Add($textboxCity)
    $groupbox1.Controls.Add($labelCity)
    $groupbox1.Controls.Add($textboxCountry)
    $groupbox1.Controls.Add($labelCountry)
    $groupbox1.Controls.Add($textboxMobile)
    $groupbox1.Controls.Add($labelМобильный)
    $groupbox1.Controls.Add($textboxPhone)
    $groupbox1.Controls.Add($labelPhone)
    $groupbox1.Controls.Add($textboxEmail)
    $groupbox1.Controls.Add($labelEMail)
    $groupbox1.Controls.Add($textboxSurname)
    $groupbox1.Controls.Add($labelSurname)
    $groupbox1.Controls.Add($textboxName)
    $groupbox1.Controls.Add($labelName)
    $groupbox1.Controls.Add($pictureboxPhoto)
    $groupbox1.Location = '12, 50'
    $groupbox1.Name = 'groupbox1'
    $groupbox1.Size = '480, 480'
    $groupbox1.TabIndex = 4
    $groupbox1.TabStop = $False
    $groupbox1.Text = 'Информация о пользователе'
    $groupbox1.UseCompatibleTextRendering = $True
    #
    # labelOU
    #
    $labelOU.AutoSize = $True
    $labelOU.Location = '64, 449'
    $labelOU.Name = 'labelOU'
    $labelOU.Size = '21, 17'
    $labelOU.TabIndex = 65
    $labelOU.Text = 'OU'
    $labelOU.UseCompatibleTextRendering = $True
    #
    # textboxOU
    #
    $textboxOU.Location = '91, 446'
    $textboxOU.Name = 'textboxOU'
    $textboxOU.ReadOnly = $True
    $textboxOU.Size = '380, 20'
    $textboxOU.TabIndex = 64
    $textboxOU.TabStop = $False
    #
    # textboxInfo
    #
    $textboxInfo.Location = '91, 399'
    $textboxInfo.Multiline = $True
    $textboxInfo.Name = 'textboxInfo'
    $textboxInfo.ReadOnly = $True
    $textboxInfo.Size = '380, 40'
    $textboxInfo.TabIndex = 18
    $textboxInfo.TabStop = $False
    #
    # textboxCompany
    #
    $textboxCompany.Location = '91, 327'
    $textboxCompany.Name = 'textboxCompany'
    $textboxCompany.ReadOnly = $True
    $textboxCompany.Size = '380, 20'
    $textboxCompany.TabIndex = 57
    $textboxCompany.TabStop = $False
    #
    # textboxDescription
    #
    $textboxDescription.Location = '91, 353'
    $textboxDescription.Multiline = $True
    $textboxDescription.Name = 'textboxDescription'
    $textboxDescription.ReadOnly = $True
    $textboxDescription.Size = '380, 40'
    $textboxDescription.TabIndex = 17
    $textboxDescription.TabStop = $False
    #
    # textboxManager
    #
    $textboxManager.Location = '91, 301'
    $textboxManager.Name = 'textboxManager'
    $textboxManager.ReadOnly = $True
    $textboxManager.Size = '380, 20'
    $textboxManager.TabIndex = 12
    $textboxManager.TabStop = $False
    #
    # labelManager
    #
    $labelManager.AutoSize = $True
    $labelManager.Location = '10, 304'
    $labelManager.Name = 'labelManager'
    $labelManager.Size = '78, 17'
    $labelManager.TabIndex = 35
    $labelManager.Text = 'Руководитель'
    $labelManager.UseCompatibleTextRendering = $True
    #
    # labelInfo
    #
    $labelInfo.AutoSize = $True
    $labelInfo.Location = '17, 412'
    $labelInfo.Name = 'labelInfo'
    $labelInfo.Size = '71, 17'
    $labelInfo.TabIndex = 32
    $labelInfo.Text = 'Примечание'
    $labelInfo.UseCompatibleTextRendering = $True
    #
    # labelDescription
    #
    $labelDescription.AutoSize = $True
    $labelDescription.Location = '29, 366'
    $labelDescription.Name = 'labelDescription'
    $labelDescription.Size = '57, 17'
    $labelDescription.TabIndex = 30
    $labelDescription.Text = 'Описание'
    $labelDescription.UseCompatibleTextRendering = $True
    #
    # labelCompany
    #
    $labelCompany.AutoSize = $True
    $labelCompany.Location = '13, 330'
    $labelCompany.Name = 'labelCompany'
    $labelCompany.Size = '73, 17'
    $labelCompany.TabIndex = 28
    $labelCompany.Text = 'Организация'
    $labelCompany.UseCompatibleTextRendering = $True
    #
    # labelDepartment
    #
    $labelDepartment.AutoSize = $True
    $labelDepartment.Location = '47, 277'
    $labelDepartment.Name = 'labelDepartment'
    $labelDepartment.Size = '38, 17'
    $labelDepartment.TabIndex = 26
    $labelDepartment.Text = 'Отдел'
    $labelDepartment.UseCompatibleTextRendering = $True
    #
    # textboxFax
    #
    $textboxFax.Location = '241, 145'
    $textboxFax.Name = 'textboxFax'
    $textboxFax.ReadOnly = $True
    $textboxFax.Size = '230, 20'
    $textboxFax.TabIndex = 4
    $textboxFax.TabStop = $False
    #
    # labelFax
    #
    $labelFax.AutoSize = $True
    $labelFax.Location = '205, 148'
    $labelFax.Name = 'labelFax'
    $labelFax.Size = '31, 17'
    $labelFax.TabIndex = 37
    $labelFax.Text = 'Факс'
    $labelFax.UseCompatibleTextRendering = $True
    #
    # buttonOpenPhoto
    #
    $buttonOpenPhoto.Enabled = $False
    $buttonOpenPhoto.Location = '6, 176'
    $buttonOpenPhoto.Name = 'buttonOpenPhoto'
    $buttonOpenPhoto.Size = '150, 23'
    $buttonOpenPhoto.TabIndex = 34
    $buttonOpenPhoto.TabStop = $False
    $buttonOpenPhoto.Text = 'Выбрать фото'
    $buttonOpenPhoto.UseCompatibleTextRendering = $True
    $buttonOpenPhoto.UseVisualStyleBackColor = $True
    $buttonOpenPhoto.add_Click($buttonOpenPhoto_Click)
    #
    # textboxDepartment
    #
    $textboxDepartment.Location = '91, 275'
    $textboxDepartment.Name = 'textboxDepartment'
    $textboxDepartment.ReadOnly = $True
    $textboxDepartment.Size = '380, 20'
    $textboxDepartment.TabIndex = 11
    $textboxDepartment.TabStop = $False
    #
    # textboxTitle
    #
    $textboxTitle.Location = '91, 249'
    $textboxTitle.Name = 'textboxTitle'
    $textboxTitle.ReadOnly = $True
    $textboxTitle.Size = '380, 20'
    $textboxTitle.TabIndex = 10
    $textboxTitle.TabStop = $False
    #
    # labelTitle
    #
    $labelTitle.AutoSize = $True
    $labelTitle.Location = '24, 252'
    $labelTitle.Name = 'labelTitle'
    $labelTitle.Size = '63, 17'
    $labelTitle.TabIndex = 24
    $labelTitle.Text = 'Должность'
    $labelTitle.UseCompatibleTextRendering = $True
    #
    # textboxOffice
    #
    $textboxOffice.Location = '241, 223'
    $textboxOffice.Name = 'textboxOffice'
    $textboxOffice.ReadOnly = $True
    $textboxOffice.Size = '230, 20'
    $textboxOffice.TabIndex = 9
    $textboxOffice.TabStop = $False
    #
    # labelOffice
    #
    $labelOffice.AutoSize = $True
    $labelOffice.Location = '201, 226'
    $labelOffice.Name = 'labelOffice'
    $labelOffice.Size = '34, 17'
    $labelOffice.TabIndex = 22
    $labelOffice.Text = 'Офис'
    $labelOffice.UseCompatibleTextRendering = $True
    #
    # textboxHouse
    #
    $textboxHouse.Location = '416, 197'
    $textboxHouse.Name = 'textboxHouse'
    $textboxHouse.ReadOnly = $True
    $textboxHouse.Size = '55, 20'
    $textboxHouse.TabIndex = 8
    $textboxHouse.TabStop = $False
    #
    # labelHouse
    #
    $labelHouse.AutoSize = $True
    $labelHouse.Location = '388, 200'
    $labelHouse.Name = 'labelHouse'
    $labelHouse.Size = '27, 17'
    $labelHouse.TabIndex = 20
    $labelHouse.Text = 'Дом'
    $labelHouse.UseCompatibleTextRendering = $True
    #
    # textboxStreet
    #
    $textboxStreet.Location = '241, 197'
    $textboxStreet.Name = 'textboxStreet'
    $textboxStreet.ReadOnly = $True
    $textboxStreet.Size = '145, 20'
    $textboxStreet.TabIndex = 7
    $textboxStreet.TabStop = $False
    #
    # labelStreet
    #
    $labelStreet.AutoSize = $True
    $labelStreet.Location = '198, 200'
    $labelStreet.Name = 'labelStreet'
    $labelStreet.Size = '37, 17'
    $labelStreet.TabIndex = 18
    $labelStreet.Text = 'Улица'
    $labelStreet.UseCompatibleTextRendering = $True
    #
    # textboxCity
    #
    $textboxCity.Location = '327, 171'
    $textboxCity.Name = 'textboxCity'
    $textboxCity.ReadOnly = $True
    $textboxCity.Size = '144, 20'
    $textboxCity.TabIndex = 6
    $textboxCity.TabStop = $False
    #
    # labelCity
    #
    $labelCity.AutoSize = $True
    $labelCity.Location = '286, 174'
    $labelCity.Name = 'labelCity'
    $labelCity.Size = '36, 17'
    $labelCity.TabIndex = 16
    $labelCity.Text = 'Город'
    $labelCity.UseCompatibleTextRendering = $True
    #
    # textboxCountry
    #
    $textboxCountry.Location = '241, 171'
    $textboxCountry.Name = 'textboxCountry'
    $textboxCountry.ReadOnly = $True
    $textboxCountry.Size = '38, 20'
    $textboxCountry.TabIndex = 5
    $textboxCountry.TabStop = $False
    #
    # labelCountry
    #
    $labelCountry.AutoSize = $True
    $labelCountry.Location = '192, 174'
    $labelCountry.Name = 'labelCountry'
    $labelCountry.Size = '43, 17'
    $labelCountry.TabIndex = 14
    $labelCountry.Text = 'Страна'
    $labelCountry.UseCompatibleTextRendering = $True
    #
    # textboxMobile
    #
    $textboxMobile.Location = '241, 119'
    $textboxMobile.Name = 'textboxMobile'
    $textboxMobile.ReadOnly = $True
    $textboxMobile.Size = '230, 20'
    $textboxMobile.TabIndex = 3
    $textboxMobile.TabStop = $False
    #
    # labelМобильный
    #
    $labelМобильный.AutoSize = $True
    $labelМобильный.Location = '172, 122'
    $labelМобильный.Name = 'labelМобильный'
    $labelМобильный.Size = '66, 17'
    $labelМобильный.TabIndex = 12
    $labelМобильный.Text = 'Мобильный'
    $labelМобильный.UseCompatibleTextRendering = $True
    #
    # textboxPhone
    #
    $textboxPhone.Location = '241, 93'
    $textboxPhone.Name = 'textboxPhone'
    $textboxPhone.ReadOnly = $True
    $textboxPhone.Size = '230, 20'
    $textboxPhone.TabIndex = 2
    $textboxPhone.TabStop = $False
    #
    # labelPhone
    #
    $labelPhone.AutoSize = $True
    $labelPhone.Location = '183, 95'
    $labelPhone.Name = 'labelPhone'
    $labelPhone.Size = '52, 17'
    $labelPhone.TabIndex = 10
    $labelPhone.Text = 'Телефон'
    $labelPhone.UseCompatibleTextRendering = $True
    #
    # textboxEmail
    #
    $textboxEmail.Location = '241, 67'
    $textboxEmail.Name = 'textboxEmail'
    $textboxEmail.ReadOnly = $True
    $textboxEmail.Size = '230, 20'
    $textboxEmail.TabIndex = 9
    $textboxEmail.TabStop = $False
    #
    # labelEMail
    #
    $labelEMail.AutoSize = $True
    $labelEMail.Location = '199, 70'
    $labelEMail.Name = 'labelEMail'
    $labelEMail.Size = '36, 17'
    $labelEMail.TabIndex = 8
    $labelEMail.Text = 'E-Mail'
    $labelEMail.UseCompatibleTextRendering = $True
    #
    # textboxSurname
    #
    $textboxSurname.Location = '241, 41'
    $textboxSurname.Name = 'textboxSurname'
    $textboxSurname.ReadOnly = $True
    $textboxSurname.Size = '230, 20'
    $textboxSurname.TabIndex = 7
    $textboxSurname.TabStop = $False
    #
    # labelSurname
    #
    $labelSurname.AutoSize = $True
    $labelSurname.Location = '183, 43'
    $labelSurname.Name = 'labelSurname'
    $labelSurname.Size = '53, 17'
    $labelSurname.TabIndex = 6
    $labelSurname.Text = 'Фамилия'
    $labelSurname.UseCompatibleTextRendering = $True
    #
    # textboxName
    #
    $textboxName.Location = '241, 15'
    $textboxName.Name = 'textboxName'
    $textboxName.ReadOnly = $True
    $textboxName.Size = '230, 20'
    $textboxName.TabIndex = 5
    $textboxName.TabStop = $False
    #
    # labelName
    #
    $labelName.AutoSize = $True
    $labelName.Location = '208, 18'
    $labelName.Name = 'labelName'
    $labelName.Size = '27, 17'
    $labelName.TabIndex = 4
    $labelName.Text = 'Имя'
    $labelName.UseCompatibleTextRendering = $True
    #
    # pictureboxPhoto
    #
    $pictureboxPhoto.BorderStyle = 'FixedSingle'
    $pictureboxPhoto.Location = '6, 19'
    $pictureboxPhoto.Name = 'pictureboxPhoto'
    $pictureboxPhoto.Size = '150, 150'
    $pictureboxPhoto.TabIndex = 3
    $pictureboxPhoto.TabStop = $False
    #
    # ADConnection
    #
    $ADConnection.Name = 'ADConnection'
    $ADConnection.Text = 'Нет подключения к AD'
    $ADConnection.Width = 130
    #
    # InfoBar
    #
    $InfoBar.AutoSize = 'Spring'
    $InfoBar.Name = 'InfoBar'
    $InfoBar.Width = 352
    #
    # openPhoto
    #
    $openPhoto.Filter = '"Изображения|*.jpg;*.jpeg|Все файлы (*.*)|*.*"'
    $openPhoto.add_FileOk($openPhoto_FileOk)
    $InfoBar.EndInit()
    $ADConnection.EndInit()
    $groupbox1.ResumeLayout()
    $formHR.ResumeLayout()
    #endregion Generated Form Code

    #----------------------------------------------

    #Save the initial state of the form
    $InitialFormWindowState = $formHR.WindowState
    #Init the OnLoad event to correct the initial state of the form
    $formHR.add_Load($Form_StateCorrection_Load)
    #Clean up the control events
    $formHR.add_FormClosed($Form_Cleanup_FormClosed)
    #Store the control values when form is closing
    $formHR.add_Closing($Form_StoreValues_Closing)
    #Show the Form
    return $formHR.ShowDialog()

}
#endregion Source: MainForm.psf

#Start the application
Main ($CommandLine)
