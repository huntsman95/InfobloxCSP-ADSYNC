# Infoblox CSP AD Sync Script

## Summary
Infoblox CSP (used for BloxOne Threat Defense, etc.) does not have a native way to schedule the synchronization of AD groups. This is a problem as user group memberships change and/or users are added/removed from the AD domain as group-based policies in CSP will no longer be accurate. To remedy this, these scripts were created.

## How to use

### Obtaining the Service ID of the Infoblox 'msad' Service
To obtain the Service ID of the Infoblox 'msad' service, run the following script:
```powershell
$ServiceID = .\CSP_Get_Detailed_Service_Info.ps1 -ApiKey <API Key> `
    | Select-Object -ExpandProperty ServiceID
```

### Obtaining the LDAP Profile ID from Infoblox
To obtain the LDAP Profile ID from Infoblox, run the following script:
```powershell
$ProfileID = .\CSP_Get_LDAP_Profiles.ps1 -ApiKey <API_KEY> `
    | Select-Object -ExpandProperty ProfileID
```

### Synchronizing AD Groups
To synchronize AD groups, run the following script:
```powershell
$ADGroups = .\CSP_AD_Sync.ps1 -ApiKey <API_KEY> `
    -ProfileID $ProfileID `
    -ServiceID $ServiceID `
    -Credential (Get-Credential)`
```

## Automating the process
To automate the execution of this script, consider one of the following solutions:

- Windows Task Scheduler
- Jenkins Automation Server
- PowerShell Universal (Ironman Software)
- Long-running PowerShell script with a service manager such as NSSM

> **Note**
> You should store the credential (and API key) securely either with the `Microsoft.PowerShell.SecretManagement` module or in a secure CLIXML file only readable by the service account that created it.