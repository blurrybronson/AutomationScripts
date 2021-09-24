# looping through text file containing feature names to enable optional features
# adding no restart flag to avoid being prompted to reboot after each feature is enabled 
foreach($feature in Get-Content -Path "OptionalFeatureNames.txt"){
    Enable-WindowsOptionalFeature -FeatureName $feature -Online -All -NoRestart
}

# installing openssh
$capability = Get-WindowsCapability -Online | Where-Object Name -Like "OpenSSH*"
foreach($name in $capability.Name){
    Add-WindowsCapability -Online -Name $name
}

# setting ssh to run at startup
Set-Service sshd -StartupType Automatic

# restarting the machine 
Restart-Computer -Force