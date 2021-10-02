# create user to access the share from the VM
$password = Read-Host("Please enter a password ") -AsSecureString
New-LocalUser -Name "dev" -Password $password -PasswordNeverExpires -AccountNeverExpires -Description "Dev account"

# read config file and convert it form json
$config = Get-Content -Path "config.json" | ConvertFrom-Json

# loop through each entry under settings in the config file to:
# 1. create a new directory
# 2. share the new directory
# 3. grant the dev user read access to the new shared directory
foreach($option in $config.settings){
    mkdir -path $option.directory
    New-SmbShare -Path $option.directory -Name $option.name
    Grant-FileShareAccess -Name $option.name -AccountName $option.user -AccessRight $option.access
}