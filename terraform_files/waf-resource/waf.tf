resource "azurerm_resource_group" "WAF_ccn-development-deployment" {
  name = var.resource_group_name
  location = var.location
}

resource "azurerm_web_application_firewall_policy" "WAF_ccnexchange.com" {
  name = "WAF_ccnexchange.com"
  resource_group_name = azurerm_resource_group.WAF_ccn-development-deployment.name
  location = azurerm_resource_group.WAF_ccn-development-deployment.location
}

custom_rule {
  name = "ccnexchange.com"
  priority = 1
  action = "Block"
  enabled = true
  rule_type = "MatchRule"
  match_conditions {
    match_variables {
      variable_name = "RequestHeaders"
      selector = "User-Agent"
    }
    operator = "Contains"
    negation_condition = false
    match_values = ["ccnexchange.com"]
    transforms = ["Lowercase"]
  }
}

custom_rule {
  name = "siacargo.com"
  priority = 2
  action = "Block"
  enabled = true
  rule_type = "MatchRule"
  match_conditions {
    match_variables {
      variable_name = "RequestHeaders"
      selector = "User-Agent"
    }
    operator = "Contains"
    negation_condition = false
    match_values = ["ccnexchange.com"]
    transforms = ["Lowercase"]
  }
}

custom_rule {
  name = "cubeforall.com"
  priority = 3
  action = "Block"
  enabled = true
  rule_type = "MatchRule"
  match_conditions {
    match_variables {
      variable_name = "RequestHeaders"
      selector = "User-Agent"
    }
    operator = "Contains"
    negation_condition = false
    match_values = ["cubeforall.com"]
    transforms = ["Lowercase"]
  }
}
