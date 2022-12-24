###
# These prerequisites are required to run anything in this repo
###

Install-Module Microsoft365DSC -Force
Update-M365DSCDependencies
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
Install-Module AzureAD -force
Update-Module Microsoft365DSC
Update-M365DSCDependencies
Uninstall-M365DSCOutdatedDependencies

# There is a vscode bug that causes the login prompt to appear BEHIND your vscode window. Start minimizing things, one by one, until you find it. 
#Connect-AzureAD 

#Connect-AzureAD -TenantId $context.Tenant.TenantId -AccountId $context.Account.Id