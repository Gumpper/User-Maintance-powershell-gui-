# Load the necessary assembly for forms
Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'AD User Functions'
$form.Size = New-Object System.Drawing.Size(300,230)
$form.StartPosition = 'CenterScreen'

# Create the label
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Size(10,10)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Enter User Name:'
$form.Controls.Add($label)

# Create the text box
$ADUser = New-Object System.Windows.Forms.TextBox
$ADUser.Location = New-Object System.Drawing.Size(10,30)
$ADUser.Size = New-Object System.Drawing.Size(260,20)
$form.Controls.Add($ADUser)

# Create the checkbox Unlock
$checkBox = New-Object System.Windows.Forms.CheckBox
$checkBox.Location = New-Object System.Drawing.Size(10,50)
$checkBox.Size = New-Object System.Drawing.Size(280,20)
$checkBox.Text = 'Unlock User'
$form.Controls.Add($checkBox)

# Create the checkbox Disable
$checkBox2 = New-Object System.Windows.Forms.CheckBox
$checkBox2.Location = New-Object System.Drawing.Size(10,70)
$checkBox2.Size = New-Object System.Drawing.Size(280,20)
$checkBox2.Text = 'Disable User'
$form.Controls.Add($checkBox2)

# Create the checkbox Change Password
$checkBox3 = New-Object System.Windows.Forms.CheckBox
$checkBox3.Location = New-Object System.Drawing.Size(10,90)
$checkBox3.Size = New-Object System.Drawing.Size(280,20)
$checkBox3.Text = 'Change Password'
$form.Controls.Add($checkBox3)

# Create the checkbox Change at Log on
$checkBox4 = New-Object System.Windows.Forms.CheckBox
$checkBox4.Location = New-Object System.Drawing.Size(10,110)
$checkBox4.Size = New-Object System.Drawing.Size(280,20)
$checkBox4.Text = 'Change At Logon'
$form.Controls.Add($checkBox4)

# Create the checkbox User list
$checkBox5 = New-Object System.Windows.Forms.CheckBox
$checkBox5.Location = New-Object System.Drawing.Size(10,130)
$checkBox5.Size = New-Object System.Drawing.Size(280,20)
$checkBox5.Text = 'Get User List'
$form.Controls.Add($checkBox5)

# Create the OK button
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Size(10,155)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

# Show the form as a dialog and capture the result
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $inputString = $textBox.Text
    $isChecked = $checkBox.Checked
    # Output the input string and the checkbox status
    Write-Host "You entered: $inputString"
    Write-Host "Checkbox checked: $isChecked"
}

$TheUser = $ADUser.Lines

if ($checkBox.Checked -eq "True"){
Enable-ADAccount -Identity "$TheUser"
Unlock-ADAccount -Identity "$TheUser" 
}
if ($checkBox2.Checked -eq "True"){
Disable-ADAccount -Identity "$TheUser" 
}

if ($checkBox3.Checked -eq "True"){
[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
$title = 'Change Password'
$msg   = 'Enter New Password:'

$Password = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)

Set-ADAccountPassword -Identity "$TheUser" -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force) -Reset 
}
if ($checkBox4.Checked -eq "True"){
Set-ADUser -Identity "$TheUser" -ChangePasswordAtLogon $true
}

if ($checkBox5.Checked -eq "True"){
Get-ADGroupMember -Identity "Domain Users" | %{Get-ADUser -Identity $_.distinguishedName -Properties *} | 
Select-Object DisplayName,SamAccountName,Enabled,LockedOut,PasswordExpired| sort DisplayName| Export-csv C:\windows\temp\User-Allusers.csv -NoTypeInformation 

C:\windows\temp\User-Allusers.csv
}

if ($checkBox.Checked -eq $false -and $checkBox2.Checked -eq $false -and $checkBox3.Checked -eq $false -and $checkBox4.Checked -eq $false -and $checkBox5.Checked -eq $True) {
# This line will start a new PowerShell process to run 'OtherScript.ps1'
Start-Process PowerShell.exe -ArgumentList  "-File `"$PSScriptRoot\UserScript.ps1`""

}

if ($checkBox.Checked -eq $true -or $checkBox2.Checked -eq $true -or $checkBox3.Checked -eq $true -or $checkBox4.Checked -eq $true) {
##################################################
### Summary

$Form2Info = Get-ADUser -Identity "$TheUser" -Properties * 

# Create the form
$form2 = New-Object System.Windows.Forms.Form
$form2.Text = 'AD User Functions'
$form2.Size = New-Object System.Drawing.Size(300,230)
$form2.StartPosition = 'CenterScreen'

# Create the label
$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Size(10,10)
$label1.Size = New-Object System.Drawing.Size(280,20)
$label1.Text = 'Display Name: '+ $Form2Info.DisplayName
$form2.Controls.Add($label1)

# Create the label
$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Size(10,30)
$label2.Size = New-Object System.Drawing.Size(280,20)
$label2.Text = 'User Code: '+ $Form2Info.SamAccountName
$form2.Controls.Add($label2)

# Create the label
$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Size(10,50)
$label2.Size = New-Object System.Drawing.Size(280,20)
$label2.Text = 'PW Last Set: '+ $Form2Info.PasswordLastSet
$form2.Controls.Add($label2)

# Create the label
$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Size(10,70)
$label2.Size = New-Object System.Drawing.Size(280,20)
$label2.Text = 'Accout Enabled: '+ $Form2Info.Enabled
$form2.Controls.Add($label2)

# Create the label
$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Size(10,90)
$label2.Size = New-Object System.Drawing.Size(280,20)
$label2.Text = 'Accout Locked out: '+ $Form2Info.LockedOut
$form2.Controls.Add($label2)

# Create the OK button
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Size(10,155)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form2.AcceptButton = $okButton
$form2.Controls.Add($okButton)

# Show the form as a dialog and capture the result
$result2 = $form2.ShowDialog()
}