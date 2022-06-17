Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


$form = New-Object System.Windows.Forms.Form
$form.Text = 'Adding users to Security Groups'
$form.Size = New-Object System.Drawing.Size(800,600)
$form.StartPosition = 'CenterScreen'

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(150,450)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)


$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(450,450)
$cancelButton.Size = New-Object System.Drawing.Size(150,23)
$cancelButton.Text = 'Back To Home'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(500,20)
$label.Text = 'This form is being used to AD add users into AD Security groups'
$form.Controls.Add($label)


$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,75)
$label.Size = New-Object System.Drawing.Size(350,20)
$label.Text = 'Please enter AD Users details (LineWise)'
$form.Controls.Add($label)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(360,75)
$label.Size = New-Object System.Drawing.Size(400,20)
$label.Text = 'Please enter AD Security Group details(LineWise)'
$form.Controls.Add($label)

$UsersTextBox = New-Object System.Windows.Forms.TextBox
$UsersTextBox.Location = New-Object System.Drawing.Point(10,100)
$UsersTextBox.Size = New-Object System.Drawing.Size(300,300)
$UsersTextBox.AcceptsReturn = $true
$UsersTextBox.AcceptsTab = $false
$UsersTextBox.Multiline = $true
$UsersTextBox.ScrollBars = 'Both'
$UsersTextBox.Text = $DefaultText
$UsersTextBox.Font=New-Object System.Drawing.Font("Calibri",14,[System.Drawing.FontStyle]::Regular)

$form.Controls.Add($UsersTextBox)

$GroupsTextBox = New-Object System.Windows.Forms.TextBox
$GroupsTextBox.Location = New-Object System.Drawing.Point(350,100)
$GroupsTextBox.Size = New-Object System.Drawing.Size(400,300)
$GroupsTextBox.AcceptsReturn = $true
$GroupsTextBox.AcceptsTab = $false
$GroupsTextBox.Multiline = $true
$GroupsTextBox.ScrollBars = 'Both'
$GroupsTextBox.Text = $DefaultText
$GroupsTextBox.Font = New-Object System.Drawing.Font("Calibri",14,[System.Drawing.FontStyle]::Regular)

$form.Controls.Add($GroupsTextBox)


$form.Topmost = $true

$form.Add_Shown({$UsersTextBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
$PSScriptRoot
$OutFile= $PSScriptRoot +"\UserGroupMembership.log"
    $Groups=$GroupsTextBox.Lines
    $Users = $UsersTextBox.Lines
    $UserOut = @()
    $i=1
    foreach($GroupName in $Groups){
    Write-Host $GroupName
    foreach($UserName in $Users)
    {
      $UserExists=[bool] (Get-ADUser -Filter { SamAccountName -eq $UserName})
      [String]$DateT=Get-Date
      if ($UserExists -eq "True"){
      $UserOut+= [String]$i+"->"+$DateT+"->$UserName is added to $GroupName Successfully"
     Add-ADGroupMember -Identity $GroupName -Members $UserName
     [INT]$i=[INT]$i+1
    }

    else
    {
    $UserOut+= "$UserName User Doesn't exists in the Domain"
    }

    }
    }
    $UserOut | Out-File $OutFile -Append
  [System.Windows.MessageBox]::Show('Single or all users are added to single or multiple groups')
  $PSScriptRoot
#write-host $PSScriptRoot
$ScriptToRun= $PSScriptRoot +".\Main.ps1"
&$ScriptToRun
}
elseif($result -eq [System.Windows.Forms.DialogResult]::Cancel)
{
    
$PSScriptRoot
#write-host $PSScriptRoot
$ScriptToRun= $PSScriptRoot +".\Main.ps1"
&$ScriptToRun
 # [System.Windows.MessageBox]::Show('Task Cancelled')
}
