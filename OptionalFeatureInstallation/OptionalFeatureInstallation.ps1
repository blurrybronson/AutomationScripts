# looping through text file containing feature names to enable optional features
# adding no restart flag to avoid being prompted to reboot after each feature is enabled 
foreach($feature in Get-Content -Path "OptionalFeatureNames.txt"){
    Enable-WindowsOptionalFeature -FeatureName $feature -Online -All -NoRestart
}

# restarting the machine 
Restart-Computer -Force