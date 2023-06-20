$resourceGroupName = "ccn-development-mrfzy"
$applicationGatewayName = "ccn-development-mrfzy_gw_testing"
$location = "southeastasia"

# Create application gateway
New-AzApplicationGateway -ResourceGroupName $resourceGroupName `
    -Name $applicationGatewayName `
    -Location $location `
    -Sku @{
        "Name" = "WAF_v2"
        "Tier" = "WAF_v2"
        "Capacity" = 2
    } `
    -GatewayIPConfigurations @(
        @{
            "Name" = "appGatewayIpConfig"
            "Subnet" = @{
                "Id" = "<application_gateway_subnet_id>"
            }
        }
    ) `
    -FrontendIPConfigurations @(
        @{
            "Name" = "appGwPublicFrontendIp"
            "PrivateIPAllocationMethod" = "Dynamic"
            "PublicIPAddress" = @{
                "Id" = "<public_ip_address_id>"
            }
        },
        @{
            "Name" = "WAF_ccnexchange_Private"
            "PrivateIPAddress" = "10.100.2.36"
            "PrivateIPAllocationMethod" = "Static"
            "Subnet" = @{
                "Id" = "<application_gateway_subnet_id>"
            }
        }
    ) `
    -FrontendPorts @(
        @{
            "Name" = "port_80"
            "Port" = 80
        },
        @{
            "Name" = "port_443"
            "Port" = 443
        }
    ) `
    -BackendAddressPools @(
        @{
            "Name" = "defaultaddresspool"
        },
        @{
            "Name" = "Box_Webpool"
        }
    ) `
    -BackendHttpSettingsCollection @(
        @{
            "Name" = "defaulthttpsetting"
            "Port" = 80
            "Protocol" = "Http"
            "CookieBasedAffinity" = "Disabled"
            "PickHostNameFromBackendAddress" = $false
            "RequestTimeout" = 30
            "Probe" = @{
                "Id" = "<application_gateway_probe_id>"
            }
        },
        @{
            "Name" = "http_cube"
            "Port" = 80
            "Protocol" = "Http"
            "CookieBasedAffinity" = "Disabled"
            "PickHostNameFromBackendAddress" = $false
            "RequestTimeout" = 20
            "Probe" = @{
                "Id" = "<cube.ccnexchange.com_probe_id>"
            }
        }
    ) `
    -HttpListeners @(
        @{
            "Name" = "fl-e1903c8aa3446b7b3207aec6d6ecba8a"
            "FrontendIPConfiguration" = @{
                "Id" = "<frontend_ip_configuration_id>"
            }
            "FrontendPort" = @{
                "Id" = "<port_80_id>"
            }
            "Protocol" = "Http"
            "RequireServerNameIndication" = $false
        },
        @{
            "Name" = "https_"
            "FrontendIPConfiguration" = @{
                "Id" = "<frontend_ip_configuration_id>"
            }
            "FrontendPort" = @{
                "Id" = "<port_443_id>"
            }
            "Protocol" = "Https"
            "RequireServerNameIndication" = $false
            "SslCertificate" = @{
                "Id" = "<ccnexchange.com_ssl_certificate_id>"
            }
            "HostName" = "ccnexchange.com"
        },
        @{
            "Name" = "http_cube"
            "FrontendIPConfiguration" = @{
                "Id" = "<WAF_ccnexchange_Private_frontend_ip_configuration_id>"
            }
            "FrontendPort" = @{
                "Id" = "<port_80_id>"
            }
            "Protocol" = "Http"
            "RequireServerNameIndication" = $false
        }
    ) `
    -RequestRoutingRules @(
        @{
            "Name" = "rule1"
            "RuleType" = "Basic"
            "HttpListener" = @{
                "Id" = "<fl-e1903c8aa3446b7b3207aec6d6ecba8a_id>"
            }
            "BackendAddressPool" = @{
                "Id" = "<defaultaddresspool_id>"
            }
            "BackendHttpSettings" = @{
                "Id" = "<defaulthttpsetting_id>"
            }
        },
        @{
            "Name" = "rule2"
            "RuleType" = "Basic"
            "HttpListener" = @{
                "Id" = "<https__id>"
            }
            "BackendAddressPool" = @{
                "Id" = "<Box_Webpool_id>"
            }
            "BackendHttpSettings" = @{
                "Id" = "<http_cube_id>"
            }
        }
    ) `
    -Probes @(
        @{
            "Name" = "probe"
            "Protocol" = "Http"
            "Host" = "ccnexchange.com"
            "Path" = "/"
            "Interval" = 30
            "Timeout" = 30
            "UnhealthyThreshold" = 3
        },
        @{
            "Name" = "cube.ccnexchange.com"
            "Protocol" = "Http"
            "Host" = "cube.ccnexchange.com"
            "Path" = "/"
            "Interval" = 30
            "Timeout" = 30
            "UnhealthyThreshold" = 3
        }
    )
