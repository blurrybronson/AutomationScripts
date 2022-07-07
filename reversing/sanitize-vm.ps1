# importing and parsing the json config file
# git repo only contains config.example.json, rename to config.json
$config = Get-Content -Path ".\config.json" | ConvertFrom-Json

# building machine_info object 
$machine_info = @{
    MachineName = $config.settings.machine_name
    SnapshotName = $config.settings.snapshot_name
}

# testing to make sure the VM referenced in the config file exists
# if the VM is not found, user will be notified and execution will halt
Get-VM -Name $machine_info.MachineName -ErrorAction SilentlyContinue -ErrorVariable vm_not_found
if($vm_not_found){
    Write-Host "The VM was not found, please check your config file"
    Write-Host "The application will now close"
    Read-Host
    Exit
}

# Disconnecting the network adapter from the VM
Disconnect-VMNetworkAdapter -VMName $machine_info.MachineName

# notifying the user that the VM is ready for use
Write-Host "Please press any key when you have finished working in the virtul environment"
Read-Host

# stopping and restoring the VM to the base configuration
Stop-VM -Name $machine_info.MachineName
Restore-VMSnapshot -VMName $machine_info.MachineName -Name $machine_info.SnapshotName -Confirm:$false

# notifying user that the machine has been restored
Write-Host "Machine state has been restored successfully"
Read-Host