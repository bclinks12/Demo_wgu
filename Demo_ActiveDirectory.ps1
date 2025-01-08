$domain = Get-ADDomain

#Creating a New User Account
$newUser = @{
    SamAccountName = "bclinkscles"
    Name = "Brittany Clinkscales"
    GivenName = "Brittany"
    Surname = "Clinkscales"
    DisplayName = "Brittany Clinkscales"
    UserPrincipalName = "bclinkscales@consultingfirm.com"
    Path = $domain.UsersContainer
    AccountPassword = (ConvertTo-SecureString "P@ssword12345!" -AsPlainText -Force)
    Enabled = $true
}
New-ADUser @newUser

#Reseting a User Password
$user = "bclinkscales"
$newPassword = (ConvertFrom-SecureString "N3WP@ssword12345!" -AsPlainText -Force)
Set-ADAccountPassword -Identity $user -NewPassword $newPassword -Reset

#Unlock a User Account
Unlock-ADAccount -Identity $user
$group = "CN=DemoGroup,$($domain.DistinguishedName)"
Add-ADGroupMember -Identity $group -Members $user

# Finding an OU
# Removing an OU
# Creating an OU

$AdRoot = $domain.DistinguishedName
$DnsRoot = $domain.$DnsRoot
$OUCanonicalName = "Finance"
$OUDisplayName = "Finance"
$ADPath = "OU=$($OUCanonicalName),$($AdRoot)"

try {
    $OU = Get-ADOrganizationalUnit -Identity $ADPath
}
catch {
    $OU = $null
}

IF ($OU) {
    Set-ADOrganizationalUnit -Identity $ADPath -ProtectedFromAccidentalDeletion:$false
    Remove-ADOrganizationalUnit -Identity $ADPath -Recursive -Confirm:$false
}

New-ADOrganizationalUnit -Identity $AdRoot -Name $OUCanonicalName - DisplayName $OUDisplayName

#Searching for Inactive User Accounts
$dateFilter = (Get-Date).AddDays(-90)
$inactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $dateFilter} -Properties LastLogonDate

$inactiveUsers | Select-Object Name, LastLogonDate

$NewADUsers = Import-Csv $PSScriptRoot\financePersonnel.csv

ForEach ($ADUser in $NewADUsers) {
    $Attributes = @{
        GivenName           = $($ADUser.First_Name)
        Surname             = $($ADUser.Last_Name)
        Name                = "$($ADUser.First_Name) $($ADUser.Last_Name)"
        DisplayName         = "$($ADUser.First_Name) $($ADUser.Last_Name)"
        SamAccountName      = $($ADUser.samAccount)
        UserPrincipalName   = "$($ADUser.samAccount)@$($DnsRoot)"
        PostalCode          = $($ADUser.PostalCode)
        MobilePhone         = $($ADUser.MobilePhone)
        OfficePhone         = $($ADUser.OfficePhone )
    }
}
