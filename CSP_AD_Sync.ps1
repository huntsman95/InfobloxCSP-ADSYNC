<#
.SYNOPSIS
    A script that allows you to automate the syncronization of LDAP groups to Infoblox CSP
.DESCRIPTION
    This script takes inputs "ApiKey", "ProfileID" and "ServiceID" along with a PSCredential
    object containing the username and password of the AD service account and uses them to sync LDAP groups to Infoblox CSP.
.NOTES
    AD Service account must NOT be prefixed with the domain name
.LINK
    https://github.com/huntsman95/InfobloxCSP-ADSYNC
.EXAMPLE
    .\CSP_AD_Sync.ps1 -ApiKey <API_KEY> -ProfileID <PROFILE_ID> -ServiceID <SERVICE_ID> -Credential (Get-Credential)
    
    Returns:

    GroupsSynchronized ExpiresAt
    ------------------ ---------
                   687 2023-09-01T19:47:34Z
#>

[CmdletBinding()]
param (
    # Api Key for Infoblox CSP obtained from https://csp.infoblox.com/#/user/api_keys
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [string]
    $ApiKey
    ,
    # Profile ID of the LDAP profile retrieved from CSP_Get_LDAP_Profiles.ps1
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [string]
    $ProfileID
    ,
    # Service ID of the 'msad' service retrieved from CSP_Get_Detailed_Service_Info.ps1
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [string]
    $ServiceID
    ,
    # PSCredential object containing the username and password of the AD service account used for LDAP sync
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [pscredential]
    $Credential
    ,
    # Set the expiration period in hours for imported groups. Defaults to 48 hours
    [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
    [int]
    $HoursUntilExpiration = 48
)

$expdate = ([datetime]::UtcNow).AddHours($HoursUntilExpiration).ToString("yyyy-MM-ddTHH:mm:ssZ")

$apiBody = [PSCustomObject]@{
    profile_id   = $ProfileID
    profile_type = "ldap"
    expires_at   = $expdate
    username     = $Credential.UserName
    password     = $Credential.GetNetworkCredential().Password
    service_id   = $ServiceID
} | ConvertTo-Json

$apiParams = @{
    Uri         = "https://csp.infoblox.com/api/usergroup_collection/v1/sync/msad_service"
    Method      = "POST"
    Headers     = @{
        authorization = "token $apiKey"
    }
    ContentType = "application/json"
    Body        = $apiBody
}

try {
    $apiResult = Invoke-Restmethod @apiParams

    $OutputObject = [PSCustomObject]@{
        GroupsSynchronized = $apiResult.results.count
        ExpiresAt          = $expdate
    }

    return $OutputObject
}
catch {
    return $_
}
