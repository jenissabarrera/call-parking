terraform {
  required_providers {
    genesyscloud = {
      source  = "mypurecloud/genesyscloud"
      version = "1.36.0"
    }
  }
}

# This will only generate group resources with the string ending with "dev" or "test"
resource "genesyscloud_tf_export" "include-filter" {
  directory             = "./genesyscloud/include-filter"
  export_as_hcl         = true
  log_permission_errors = true
  include_filter_resources = [
    "genesyscloud_auth_role::Orbit Data Actions OAuth Client 1",
    "genesyscloud_integration_custom_auth_action::Orbit Data Actions OAuth Client New",
    "genesyscloud_integration::Orbit Data Actions Integration",
    "genesyscloud_integration_action::Get Waiting Calls on Specific Queue Base on External Tag Aug-15-24",
    "genesyscloud_integration_action::Replace Participant with ANI - Aug-15-24",
    "genesyscloud_integration_action::Update External Tag on Conversation",
    "genesyscloud_flow::Orbit - Parked Call Retrieval",
    "genesyscloud_flow::Call Park Agent - Inbound Flow",
    "genesyscloud_flow::Default In-Queue Flow",
    "genesyscloud_flow::InQueue - Orbit Call Park Hold",
    "genesyscloud_routing_queue::Orbit",
    "genesyscloud_script::Orbit Queue Transfer",
    "genesyscloud_architect_ivr::Call Parking Inbound Agent Flow"
  ]
}

# This will generate ALL resources in the org except the ones listed
resource "genesyscloud_tf_export" "exclude-filter" {
  directory             = "./genesyscloud/exclude-filter"
  export_as_hcl         = true
  log_permission_errors = true
  exclude_filter_resources = [
    "genesyscloud_group",
    "genesyscloud_user",
    "genesyscloud_knowledge_label",
    "genesyscloud_telephony_providers_edges_phone",
    "genesyscloud_auth_role",
    "genesyscloud_knowledge_document_variation",
    "genesyscloud_knowledge_document",
    "genesyscloud_telephony_providers_edges_phonebasesettings",
    "genesyscloud_oauth_client",
    "genesyscloud_telephony_providers_edges_did_pool",
    "genesyscloud_telephony_providers_edges_trunkbasesettings",
    "genesyscloud_telephony_providers_edges_trunk",
    "genesyscloud_architect_user_prompt",
    "genesyscloud_architect_datatable",
    "genesyscloud_location",
    "genesyscloud_externalcontacts_contact",
    "genesyscloud_quality_forms_evaluation",
    "genesyscloud_user_roles",
    "genesyscloud_knowledge_v1_document",
    "genesyscloud_outbound_contact_list",
    "genesyscloud_telephony_providers_edges_site",
    "genesyscloud_outbound_campaign",
    "genesyscloud_outbound_contactlistfilter",
    "genesyscloud_outbound_messagingcampaign",
    "genesyscloud_journey_action_map",
    "genesyscloud_architect_emergencygroup",
    "genesyscloud_processautomation_trigger",
    "genesyscloud_architect_datatable_row",
    "genesyscloud_telephony_providers_edges_edge_group",
    "genesyscloud_outbound_sequence",
    "genesyscloud_integration_credential",

  ]
}



