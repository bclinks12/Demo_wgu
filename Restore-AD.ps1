# Brittany Clinkscales - Student ID: 001265256
#New-ADOrganizationalUnit -Name $OUCanonicalName -Path $AdRoot -Description "Finance"

#Define Variables 
$OUPath = "OU=Finance,DC=consultingfirm,DC=com"
$DnsRoot = "consultingfirm.com"

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
        Path                = $ADPath
    }
    New-ADUser @Attributes
}
#Get-ADUser -Filter * -SearchBase "ou=Finance,dc=consultingfirm,dc=com" -Properties DisplayName,PostalCode,OfficePhone,MobilePhone >.AdResults.-AsPlainText