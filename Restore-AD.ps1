# Brittany Clinkscales - Student ID: 001265256

#1.
try {
    #Check if the OU - Finance exists
    $OU = Get-ADOrganizationalUnit -Identity $ADPath
    Write-Host "OU - Finance already exists!" -ForegroundColor Green
}
catch {
    #If the OU - Finance doesn't exist
    $OU = $null
    Write-Host "OU - Finance not found!" -ForegroundColor Red
}

if ($OU) {
    Set-ADOrganizationalUnit -Identity $ADPath -ProtectedFromAccidentalDeletion:$false
    Remove-ADOrganizationalUnit -Identity $ADPath -Recursive -Confirm:$false
    Write-Host "OU - Finance has been deleted" -ForegroundColor Red
} else {
    Write-Host "OU - Finance no longer exits!" -ForegroundColor Green
}

#2.
#code to add new OU - Finance
New-ADOrganizationalUnit -Name $OUCanonicalName -Path $AdRoot -Description "Finance"
#Output message
Write-Host "OU - Finance creation is complete."


#3.
#Code to add new users to OU - Finanace
#Define Variables 
$OUPath = "OU=Finance,DC=consultingfirm,DC=com"
$DnsRoot = "consutlingfirm.com"

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
        Path                = $OUPath
    }
    New-ADUser @Attributes
}


#Code generates output file for submission
Get-ADUser -Filter * -SearchBase "ou=Finance,dc=consultingfirm,dc=com" -Properties DisplayName,PostalCode,OfficePhone,MobilePhone >.AdResults.-AsPlainText
