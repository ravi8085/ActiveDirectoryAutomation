Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


$form = New-Object System.Windows.Forms.Form
$form.Text = 'Adding DNS Host Entries'
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
$label.Text = 'This form is being used to Add DNS Host Entries'
$form.Controls.Add($label)


$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,75)
$label.Size = New-Object System.Drawing.Size(350,20)
$label.Text = 'Please enter Hostnames (LineWise)'
$form.Controls.Add($label)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(360,75)
$label.Size = New-Object System.Drawing.Size(400,20)
$label.Text = 'Please enter IPAddresses (LineWise)'
$form.Controls.Add($label)

$HostNameTextBox = New-Object System.Windows.Forms.TextBox
$HostNameTextBox.Location = New-Object System.Drawing.Point(10,100)
$HostNameTextBox.Size = New-Object System.Drawing.Size(300,300)
$HostNameTextBox.AcceptsReturn = $true
$HostNameTextBox.AcceptsTab = $false
$HostNameTextBox.Multiline = $true
$HostNameTextBox.ScrollBars = 'Both'
$HostNameTextBox.Text = $DefaultText
$HostNameTextBox.Font=New-Object System.Drawing.Font("Calibri",14,[System.Drawing.FontStyle]::Regular)

$form.Controls.Add($HostNameTextBox)

$IPAddressTextBox = New-Object System.Windows.Forms.TextBox
$IPAddressTextBox.Location = New-Object System.Drawing.Point(350,100)
$IPAddressTextBox.Size = New-Object System.Drawing.Size(400,300)
$IPAddressTextBox.AcceptsReturn = $true
$IPAddressTextBox.AcceptsTab = $false
$IPAddressTextBox.Multiline = $true
$IPAddressTextBox.ScrollBars = 'Both'
$IPAddressTextBox.Text = $DefaultText
$IPAddressTextBox.Font = New-Object System.Drawing.Font("Calibri",14,[System.Drawing.FontStyle]::Regular)

$form.Controls.Add($IPAddressTextBox)


$form.Topmost = $true

$form.Add_Shown({$HostNameTextBox.Select()})
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
$PSScriptRoot
$OutFile= $PSScriptRoot +"\AddDNSHostRecordLog.log"
    $IPAddresses=$IPAddressTextBox.Lines
    $Hostnames = $HostNameTextBox.Lines
   $LogfileOut = @()
   $IpAddressCount=$IPAddresses.Count
   $HostNamesCount=$HostNames.Count

   if ($HostNamesCount -eq $IPAddressCount)
   {

   For ($i=0; $i -lt $IPAddressCount; $i++) {

   $validateIP=[ipaddress]::TryParse($IPAddresses[$i],[ref][ipaddress]::Loopback)
   $ValidateHostRecord=[boolean](Resolve-DnsName  -Name $HostNames[$i])

   if ($ValidateIP -eq "True"){

      if ($ValidateHostRecord -ne "True"){
   Add-DnsServerResourceRecordA -Name $Hostnames[$i] -ZoneName "exampledmain.com" -AllowUpdateAny -IPv4Address $IPAddresses[$i]
   $StringVal =" Host Record is created for "+$HostNames[$i]+" which has "+$IPAddresses[$i]+" IP Address"
   #Write-host "Printing $HostNames[$i] Hostname"
     $LogfileOut +=$StringVal
 }
 else{
 $LogfileOut +="DNS entry already exists for  "+$HostNames[$i]+" host or application"
 }
    }
    else

    {

    $LogfileOut +="IP Address "+$IPAddresses[$i]+" is incorrect or DNS entry already exists"

    }
    }
    [System.Windows.MessageBox]::Show('DNS Host records are created successfully')
    }

   else
   {
       [System.Windows.MessageBox]::Show('Hostnames and IP Addresses count is not matching')
   }
   
   $LogfileOut | Out-File $OutFile -append
  notepad $OutFile
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
