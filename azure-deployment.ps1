$applicationGateways_WAF_exchange_com_name = ""
$virtualNetworks_Prod_vNet_externalid = ""
$publicIPAddresses_WAF_exchange_com_externalid = ""
$ApplicationGatewayWebApplicationFirewallPolicies_CustomWAFRules_externalid = ""

$resourceGroupName = ""
$location = "southeastasia"

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile "path/to/template.json" `
  -applicationGateways_WAF_ccnexchange_com_name $applicationGateways_WAF_exchange_com_name `
  -virtualNetworks_Prod_vNet_externalid $virtualNetworks_Prod_vNet_externalid `
  -publicIPAddresses_WAF_ccnexchange_com_externalid $publicIPAddresses_WAF_exchange_com_externalid `
  -ApplicationGatewayWebApplicationFirewallPolicies_CustomWAFRules_externalid $ApplicationGatewayWebApplicationFirewallPolicies_CustomWAFRules_externalid `
  -location $location