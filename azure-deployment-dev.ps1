# Set variables
$resourceGroupName = ""
$location = ""
$applicationGatewayName = ""
$virtualNetworkResourceId = ""
$publicIPAddressResourceId = ""
$webApplicationFirewallPolicyResourceId = ""

# Create application gateway
$gateway = New-AzApplicationGateway -ResourceGroupName $resourceGroupName `
    -Name $applicationGatewayName -Location $location -SkuName "" -SkuTier "" -SkuCapacity 2 `
    -DefaultBackendAddressPool $null -GatewayIPConfigurations @() -FrontendIPConfigurations @() -FrontendPorts @()
    -BackendAddressPools @() -BackendHttpSettingsCollection @() -HttpListeners @() -RequestRoutingRules @() `
    -WebApplicationFirewallConfiguration -CustomWebApplicationFirewallConfiguration $null `
    -WebApplicationFirewallPolicy $null -WebApplicationFirewallPolicyLink $null

# Configure frontend IP configuration for public IP
$frontendIPConfig = New-AzApplicationGatewayFrontendIPConfig -Name "" `
    -PublicIPAddressId $publicIPAddressResourceId -PrivateIPAllocationMethod "Dynamic"
$gateway.FrontendIPConfigurations.Add($frontendIPConfig)

# Configure frontend IP configuration for private IP
$frontendIPConfigPrivate = New-AzApplicationGatewayFrontendIPConfig -Name "" `
    -PrivateIPAddress "" -PrivateIPAllocationMethod "Static" -SubnetId $virtualNetworkResourceId
$gateway.FrontendIPConfigurations.Add($frontendIPConfigPrivate)

# Configure frontend ports
$frontendPort80 = New-AzApplicationGatewayFrontendPort -Name "" -Port 80
$frontendPort443 = New-AzApplicationGatewayFrontendPort -Name "" -Port 443
$gateway.FrontendPorts.Add($frontendPort80)
$gateway.FrontendPorts.Add($frontendPort443)

# Configure HTTP settings
$httpSettingsDefault = New-AzApplicationGatewayBackendHttpSettings -Name "" `
    -Port 80 -Protocol "Http" -CookieBasedAffinity "Disabled" -PickHostNameFromBackendAddress $false `
    -RequestTimeout 30 -Probe $null
$httpSettingsCube = New-AzApplicationGatewayBackendHttpSettings -Name "" `
    -Port 80 -Protocol "Http" -CookieBasedAffinity "Disabled" -PickHostNameFromBackendAddress $false `
    -RequestTimeout 20 -Probe $null
$gateway.BackendHttpSettingsCollection.Add($httpSettingsDefault)
$gateway.BackendHttpSettingsCollection.Add($httpSettingsCube)

# Configure HTTP listener for port 80
$listenerHttp = New-AzApplicationGatewayHttpListener -Name "" `
    -Protocol "Http" -FrontendIPConfiguration $frontendIPConfig -FrontendPort $frontendPort80
$gateway.HttpListeners.Add($listenerHttp)

# Configure HTTP listener for port 443
$listenerHttps = New-AzApplicationGatewayHttpListener -Name "" `
    -Protocol "Https" -FrontendIPConfiguration $frontendIPConfig -FrontendPort $frontendPort443 -SslCertificateName "CertificateName"
$gateway.HttpListeners.Add($listenerHttps)

# Configure backend pool
$backendPool = New-AzApplicationGatewayBackendAddressPool -Name ""
$gateway.BackendAddressPools.Add($backendPool)

# Configure backend HTTP settings for the backend pool
$backendHttpSettings = New-AzApplicationGatewayBackendHttpSettings -Name "" `
    -Port 80 -Protocol "Http" -CookieBasedAffinity "Disabled" -PickHostNameFromBackendAddress $false `
    -RequestTimeout 30 -Probe $null
$gateway.BackendHttpSettingsCollection.Add($backendHttpSettings)

# Configure request routing rules
$ruleHttp = New-AzApplicationGatewayRequestRoutingRule -Name "" `
    -RuleType "Basic" -BackendHttpSettings $backendHttpSettings -HttpListener $listenerHttp `
    -BackendAddressPool $backendPool
$gateway.RequestRoutingRules.Add($ruleHttp)

$ruleHttps = New-AzApplicationGatewayRequestRoutingRule -Name "" `
    -RuleType "Basic" -BackendHttpSettings $backendHttpSettings -HttpListener $listenerHttps `
    -BackendAddressPool $backendPool
$gateway.RequestRoutingRules.Add($ruleHttps)

# Attach web application firewall policy
$gateway.WebApplicationFirewallPolicyLink = New-AzApplicationGatewayWebApplicationFirewallPolicyLink `
    -Id $webApplicationFirewallPolicyResourceId

# Update the application gateway
Set-AzApplicationGateway -ApplicationGateway $gateway
