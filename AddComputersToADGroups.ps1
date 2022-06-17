Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$Out=@()

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Adding Computers to Security Groups'
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
$label.Size = New-Object System.Drawing.Size(600,20)
$label.Text = 'This form is being used to AD add Computers into AD Security group'
$form.Controls.Add($label)


$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,75)
$label.Size = New-Object System.Drawing.Size(350,20)
$label.Text = 'Please enter AD Computer details (LineWise)'
$form.Controls.Add($label)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(360,75)
$label.Size = New-Object System.Drawing.Size(400,20)
$label.Text = 'Please enter AD Security Group Name'
$form.Controls.Add($label)

$ComputersTextBox = New-Object System.Windows.Forms.TextBox
$ComputersTextBox.Location = New-Object System.Drawing.Point(10,100)
$ComputersTextBox.Size = New-Object System.Drawing.Size(300,300)
$ComputersTextBox.AcceptsReturn = $true
$ComputersTextBox.AcceptsTab = $false
$ComputersTextBox.Multiline = $true
$ComputersTextBox.ScrollBars = 'Both'
$ComputersTextBox.Text = $DefaultText
$ComputersTextBox.Font=New-Object System.Drawing.Font("Calibri",14,[System.Drawing.FontStyle]::Regular)

$form.Controls.Add($ComputersTextBox)

$GroupsTextBox = New-Object System.Windows.Forms.TextBox
$GroupsTextBox.Location = New-Object System.Drawing.Point(350,100)
$GroupsTextBox.Size = New-Object System.Drawing.Size(400,300)
$GroupsTextBox.AcceptsReturn = $true
$GroupsTextBox.AcceptsTab = $false
$GroupsTextBox.Multiline = $false
$GroupsTextBox.ScrollBars = 'Both'
$GroupsTextBox.Text = $DefaultText
$GroupsTextBox.Font = New-Object System.Drawing.Font("Calibri",14,[System.Drawing.FontStyle]::Regular)

$form.Controls.Add($GroupsTextBox)


$form.Topmost = $true

$form.Add_Shown({$ComputersTextBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
$PSScriptRoot
$OutFile= $PSScriptRoot +"\ComputerGroupMembership.log"
    $Group=$GroupsTextBox.Text
    $Computers = $ComputersTextBox.Lines
    
     foreach($Computer in $Computers)
    {
               
    try{
        Get-ADComputer $Computer -ErrorAction Stop
        $Out+="$Computer is added to $Group"
        $ComputerName=Get-ADComputer $Computer
        Add-ADGroupMember -Identity $GroupName -Members $ComputerName
    }
    catch{
         $Out+="$Computer Does not exists in the Domain"
    }
          
    }
    $Out | Out-File $OutFile
  [System.Windows.MessageBox]::Show('Single or all Computers are added to '+$group +' Security Group')
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
