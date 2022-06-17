Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Add DNS CNAME Records'
$form.Size = New-Object System.Drawing.Size(800,700)
$form.StartPosition = 'CenterScreen'

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(400,20)
$label.Size = New-Object System.Drawing.Size(350,40)
$label.Text = 'Enter FQDNs in below textbox'
$label.Font=New-Object System.Drawing.Font("Calibri",10,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($label)

$IPAddressTextBox = New-Object System.Windows.Forms.TextBox
$IPAddressTextBox.Location = New-Object System.Drawing.Point(400,60)
$IPAddressTextBox.Size = New-Object System.Drawing.Size(200,225)
$IPAddressTextBox.AcceptsReturn = $true
$IPAddressTextBox.AcceptsTab = $false
$IPAddressTextBox.Multiline = $true
$IPAddressTextBox.ScrollBars = 'Both'
$IPAddressTextBox.Text = $DefaultText
$IPAddressTextBox.Font=New-Object System.Drawing.Font("Calibri",14,[System.Drawing.FontStyle]::Regular)

$form.Controls.Add($IPAddressTextBox)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(400,290)
$label.Size = New-Object System.Drawing.Size(350,40)
$label.Text = 'Enter CNAMES in below textbox'
$label.Font=New-Object System.Drawing.Font("Calibri",10,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($label)



$HostFQDNTextBox = New-Object System.Windows.Forms.TextBox
$HostFQDNTextBox.Location = New-Object System.Drawing.Point(400,330)
$HostFQDNTextBox.Size = New-Object System.Drawing.Size(200,225)
$HostFQDNTextBox.AcceptsReturn = $true
$HostFQDNTextBox.AcceptsTab = $false
$HostFQDNTextBox.Multiline = $true
$HostFQDNTextBox.ScrollBars = 'Both'
$HostFQDNTextBox.Text = $DefaultText
$HostFQDNTextBox.Font=New-Object System.Drawing.Font("Calibri",14,[System.Drawing.FontStyle]::Regular)

$form.Controls.Add($HostFQDNTextBox)



$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(50,580)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(450,580)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(350,40)
$label.Text = 'Select DNS Zone from below list:'
$label.Font=New-Object System.Drawing.Font("Calibri",10,[System.Drawing.FontStyle]::Regular)
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,60)
$listBox.Size = New-Object System.Drawing.Size(350,550)
$listBox.Height = 200
$listBox.Font=New-Object System.Drawing.Font("Calibri",16,[System.Drawing.FontStyle]::Regular)
$Zones=Get-DnsServerZone | Select ZoneName -Expandproperty ZoneName
foreach ($Zone in $Zones){

if ($Zone -notmatch '\d'){

[void] $listBox.Items.Add($Zone)
}
}
$form.Controls.Add($listBox)

$form.Topmost = $true

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $ZoneName = $listBox.SelectedItem
    $PSScriptRoot
$OutFile= $PSScriptRoot +"\AddDNSPTRRecordLog.log"
    $IPAddressTextBox=$IPAddressTextBox.Lines
    $HostFQDNTextBox= $HostNameTextBox.Lines
   $LogfileOut = @()
   $IpAddressCount=$IPAddressTextBox.Count
   $HostNamesCount=$HostFQDNTextBox.Count

   if ($HostNamesCount -eq $IPAddressCount)
   {

   For ($i=0; $i -lt $IPAddressCount; $i++) 
        {

   $validateIP=[ipaddress]::TryParse($IPAddresses[$i],[ref][ipaddress]::Loopback)
   
   if ($ValidateIP -eq "True")
            {

$IPAddressPart=$IPAddressTextBox[$i].Split('.')[-1]
#Add-DnsServerResourceRecordPtr -Name $IPAddressPart -ZoneName $ZoneName -AllowUpdateAny -TimeToLive 01:00:00 -AgeRecord -PtrDomainName $HostFQDNTextBox[$i]
$StringVal =" PTR Record is created for "+$HostFQDNTextBox[$i]+" which has "+$IPAddressTextBox[$i]+" IP Address"
Write-host $StringVal
     $LogfileOut +=$StringVal
            }
    else

            {

    $LogfileOut +="IP Address "+$IPAddressTextBox[$i]+" format is incorrect "

            }
    }
    [System.Windows.MessageBox]::Show('DNS PTR records are created successfully')
 }

   else
   {
       [System.Windows.MessageBox]::Show('Hostnames and IP Addresses count is not matching')
   }

   
   $LogfileOut | Out-File $OutFile -append
  #notepad $OutFile
  $PSScriptRoot
#write-host $PSScriptRoot
$ScriptToRun= $PSScriptRoot +".\Main.ps1"
&$ScriptToRun

}
