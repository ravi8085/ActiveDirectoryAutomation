param([switch]$Elevated)
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$UsersTextBox = New-Object System.Windows.Forms.TextBox

function CompGroupAdd{
$Form.Dispose()
$PSScriptRoot
$ScriptToRun= $PSScriptRoot +".\AddComputersToADGroups.ps1"
&$ScriptToRun
}

function UserGroupAdd{
$Form.Dispose()
$PSScriptRoot
$ScriptToRun= $PSScriptRoot +".\AddUsersToADGroups.ps1"
&$ScriptToRun
}

function AddDNSHostRecord{
$Form.Dispose()
$PSScriptRoot
$ScriptToRun= $PSScriptRoot +".\AddDNSHostRecord.ps1"
&$ScriptToRun
}

function AddDNSCNAMERecord{
$Form.Dispose()
$PSScriptRoot
$ScriptToRun= $PSScriptRoot +".\AddDNSCNAMERecord.ps1"
&$ScriptToRun
}


function AddDNSPTRRecord{
$Form.Dispose()
$PSScriptRoot
$ScriptToRun= $PSScriptRoot +".\AddDNSPTRRecord.ps1"
&$ScriptToRun
}

function ResetADUserPassword{
$Form.Dispose()
$PSScriptRoot
$ScriptToRun= $PSScriptRoot +".\ResetADUserPassword.ps1"
&$ScriptToRun

}

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Home Page - Active Directory Operations Automation'
$form.Size = New-Object System.Drawing.Size(800,600)
$op = [char[]]@(083,099,114,105,112,116,32,087,114,105,116,116,101,110,32,098,121,32,082,097,118,105,32,075,105,114,097,110,32,078,117,116,104,105,45,067,111,103,110,105,122,097,110,116)
$Auth=$op -join ''
$form.StartPosition = 'CenterScreen'


$UserAddGroupButton = New-Object System.Windows.Forms.Button
$UserAddGroupButton.Location = New-Object System.Drawing.Point(20,20)
$UserAddGroupButton.Size = New-Object System.Drawing.Size(400,30)
$UserAddGroupButton.Text = 'Add Users to AD SecurityGroups'
$UserAddGroupButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $UserAddGroupButton
$form.Controls.Add($UserAddGroupButton)

$UserAddGroupButton.add_Click({UserGroupAdd})

$CompAddGroupButton = New-Object System.Windows.Forms.Button
$CompAddGroupButton.Location = New-Object System.Drawing.Point(20,60)
$CompAddGroupButton.Size = New-Object System.Drawing.Size(400,30)
$CompAddGroupButton.Text = 'Add Computers to AD SecurityGroups'
$CompAddGroupButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $CompAddGroupButton
$form.Controls.Add($CompAddGroupButton)

$CompAddGroupButton.add_Click({CompGroupAdd})

$PasswordGenerateButton = New-Object System.Windows.Forms.Button
$PasswordGenerateButton.Location = New-Object System.Drawing.Point(20,100)
$PasswordGenerateButton.Size = New-Object System.Drawing.Size(400,30)
$PasswordGenerateButton.Text = 'AD User/Service Account Password Reset'
#$PasswordGenerateButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $PasswordGenerateButton
$form.Controls.Add($PasswordGenerateButton)

$PasswordGenerateButton.add_Click({ResetADUserPassword})


$DNSAButton = New-Object System.Windows.Forms.Button
$DNSAButton.Location = New-Object System.Drawing.Point(20,400)
$DNSAButton.Size = New-Object System.Drawing.Size(200,23)
$DNSAButton.Text = 'Add DNS Host Records'
$DNSAButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.CancelButton = $DNSAButton
$form.Controls.Add($DNSAButton)

$DNSAButton.add_Click({AddDNSHostRecord})


$DNSCNAMEButton = New-Object System.Windows.Forms.Button
$DNSCNAMEButton.Location = New-Object System.Drawing.Point(225,400)
$DNSCNAMEButton.Size = New-Object System.Drawing.Size(200,23)
$DNSCNAMEButton.Text = 'Add CNAME Records'
$DNSCNAMEButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.CancelButton = $DNSCNAMEButton
$form.Controls.Add($DNSCNAMEButton)

$DNSCNAMEButton.add_Click({AddDNSCNAMERecord})


$DNSPTRButton = New-Object System.Windows.Forms.Button
$DNSPTRButton.Location = New-Object System.Drawing.Point(425,400)
$DNSPTRButton.Size = New-Object System.Drawing.Size(200,23)
$DNSPTRButton.Text = 'Add PTR Records'
$DNSPTRButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.CancelButton = $DNSPTRButton
$form.Controls.Add($DNSPTRButton)

$DNSPTRButton.add_Click({AddDNSPTRRecord})





$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(20,450)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Exit'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(420,500)
$label.Size = New-Object System.Drawing.Size(350,20)
$label.Text = $Auth
$form.Controls.Add($label)


$form.Topmost = $true

#$form.Add_Shown({$UsersTextBox.Select()})
$result = $form.ShowDialog()

#if ($result -eq [System.Windows.Forms.DialogResult]::OK)
if($result -eq [System.Windows.Forms.DialogResult]::Cancel)
{
    
 [System.Windows.MessageBox]::Show('You have exited the Page')
}
