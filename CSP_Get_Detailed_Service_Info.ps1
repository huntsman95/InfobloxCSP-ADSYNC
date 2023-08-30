<#
.SYNOPSIS
    A script that allows you to retrieve all 'msad' services from Infoblox CSP
.DESCRIPTION
    Use this script to retrieve all 'msad' services from Infoblox CSP for use with the CSP_AD_Sync.ps1 script.
.NOTES
    You can chain this script to build an input object for CSP_AD_Sync.ps1 or use this script as a one-off to build a config file
.LINK
    https://github.com/huntsman95/InfobloxCSP-ADSYNC
.EXAMPLE
    .\CSP_Get_Detailed_Service_Info.ps1 -ApiKey <API_KEY>
    
    Returns:

    ServiceName ServiceType ServiceID
    ----------- ----------- ---------
    TST AD Sync msad        csld24d42hg5lunuv0gfiq5qv9cp433z
#>

[CmdletBinding()]
param (
    # Api Key for Infoblox CSP obtained from https://csp.infoblox.com/#/user/api_keys
    [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
    [string]
    $ApiKey
)

$apiParams = @{
    Uri         = "https://csp.infoblox.com/api/infra/v1/detail_services"
    Method      = "GET"
    Headers     = @{
        authorization = "token $apiKey"
    }
    ContentType = "application/json"
}

return (Invoke-Restmethod @apiParams).results `
    | Where-Object { $_.service_type -eq "msad" } `
    | Select-Object `
        @{ Name = "ServiceName"; Expression = { $_.name } }, `
        @{ Name = "ServiceType"; Expression = { $_.service_type } }, `
        @{ Name = "ServiceID"; Expression = { $_.id } }