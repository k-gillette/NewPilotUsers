#Import the Active Directory module
Import-Module ActiveDirectory

#Set variable for temporary password
$Password = "Password1"

#Set location for CSV file
$Users = Import-Csv -Path "C:\PowerShell\NewPilots.csv"

#Loop that creates each user in the CSV
ForEach($User in $Users){
    $FullName = $User.First + " " + $User.Last #User's full name
    $SAM = $User.First.Substring(0,1) + $User.Last #samAccount name
    $UPN = $SAM + "@domain.local" #User profile name
    $Template = Get-ADUser -Identity $User.Template -Properties MemberOf, Manager, Department, Description, Title, Company #Template account to use for new user
    
    #Create a new user with the specified parameters
    New-ADUser -Name $FullName -Instance $Template `
        -Path "OU=Pilots,OU=Domain Users,DC=domain,DC=local" `
        -GivenName $User.First -Surname $User.Last -Initials $User.Initials `
        -StreetAddress $User.Address -City $User.City -State $User.State -PostalCode $User.Zip `
        -Country US -HomePhone $User.HomePhone -MobilePhone $User.CellPhone `
        -SamAccountName $SAM -UserPrincipalName $UPN -DisplayName $FullName `
        -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
        -ChangePasswordAtLogon $true -Enabled $true
}
