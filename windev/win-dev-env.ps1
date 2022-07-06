# importing json config file
$config = Get-Content -Path "config.json" | ConvertFrom-Json

# building Azure key vault object
$keyvault = @{
    VaultName = $config.keyvault[0].VaultName
    SecretName = $config.keyvault[0].SecretName
}

# building new user object
$user = @{
    Username = $config.user[0].Username
    Group = $config.user[0].Group
    Password = (Get-AzKeyVaultSecret -VaultName $keyvault.Vaultname -Name $keyvault.SecretName)
}

# building new credential using the user object 
$credential = New-Object System.Management.Automation.PSCredential($user.Username, $user.Password.SecretValue)

# creating the new local user and adding it to the "Users" group
# user is created from the credential object above
New-LocalUser -Name $credential.UserName -Password $credential.Password -AccountNeverExpires -PasswordNeverExpires
Add-LocalGroupMember -Group $user.Group -Member $credential.UserName

# iterating over each item in the $directories sections of the config.json file
# if the directory does not already exist, it will be created
# once directories are created, they are shared
foreach($directory in $config.directories){
    $name = $directory.Name
    $path = $directory.Path
    if(-not(Test-Path -Path $directory.Path)){
        New-Item -ItemType Directory -Path $path
    }
    New-SmbShare -Name $name -Path $path -ReadAccess $credential.UserName
}