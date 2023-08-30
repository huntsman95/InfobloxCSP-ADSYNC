<#
.SYNOPSIS
    A script that allows you to retrieve all LDAP profiles from Infoblox CSP
.DESCRIPTION
    Use this script to retrieve all LDAP profiles from Infoblox CSP for use with the CSP_AD_Sync.ps1 script.
.NOTES
    You can chain this script to build an input object for CSP_AD_Sync.ps1 or use this script as a one-off to build a config file
.LINK
    https://github.com/huntsman95/InfobloxCSP-ADSYNC
.EXAMPLE
    .\CSP_Get_LDAP_Profiles.ps1 -ApiKey <API_KEY>
    
    Returns:

    ProfileName ProfileID
    ----------- ---------
    TST LDAP    c247b5fc-c01d-f337-8008-badf00dca755
#>

[CmdletBinding()]
param (
    # Api Key for Infoblox CSP obtained from https://csp.infoblox.com/#/user/api_keys
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [string]
    $ApiKey
)

$apiParams = @{
    Uri         = "https://csp.infoblox.com/api/authn/v1/profiles/ldap"
    Method      = "GET"
    Headers     = @{
        authorization = "token $apiKey"
    }
    ContentType = "application/json"
}

return (Invoke-Restmethod @apiParams).results | Select-Object  @{ Name = "ProfileName"; Expression = { $_.name } }, @{ Name = "ProfileID"; Expression = { $_.id } }