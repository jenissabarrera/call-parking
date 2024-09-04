terraform {
  required_providers {
    genesyscloud = {
      source  = "registry.terraform.io/mypurecloud/genesyscloud"
      version = "1.36.0"
    }
  }
}

resource "genesyscloud_outbound_wrapupcodemappings" "wrapupcodemappings" {
  default_set = ["Contact_UnCallable", "Number_UnCallable", "Right_Party_Contact"]
  mappings {
    flags          = ["Contact_UnCallable", "Number_UnCallable", "Right_Party_Contact"]
    wrapup_code_id = "${genesyscloud_routing_wrapupcode.tf_test_wrapupcodea5644ec8-ef61-462f-81b1-0699495f4e79.id}"
  }
  mappings {
    flags          = ["Contact_UnCallable", "Right_Party_Contact"]
    wrapup_code_id = "${genesyscloud_routing_wrapupcode.Message_Processed.id}"
  }
  mappings {
    flags          = ["Contact_UnCallable"]
    wrapup_code_id = "${genesyscloud_routing_wrapupcode.tf_test_wrapupcodea5fc6461-d63d-4bcd-b35e-2cf30c4ada01.id}"
  }
  mappings {
    flags          = ["Contact_UnCallable"]
    wrapup_code_id = "${genesyscloud_routing_wrapupcode.tf_test_wrapupcode7f596714-7a45-430d-ad77-ed612d96498b.id}"
  }
  mappings {
    flags          = ["Number_UnCallable", "Right_Party_Contact"]
    wrapup_code_id = "${genesyscloud_routing_wrapupcode.tf_test_wrapupcode4b988845-4bf8-40f0-872f-d7b89ec3a257.id}"
  }
  mappings {
    wrapup_code_id = "${genesyscloud_routing_wrapupcode.Prince2.id}"
    flags          = ["Number_UnCallable"]
  }
  mappings {
    flags          = []
    wrapup_code_id = "${genesyscloud_routing_wrapupcode.Message_Resolved.id}"
  }
}

resource "genesyscloud_outbound_settings" "outbound_settings" {
}

resource "genesyscloud_outbound_campaignrule" "Terraform_test_rule_f5e3aa35-88cd-4bce-88e3-d6e8fb38c1e7" {
  match_any_conditions = false
  name                 = "Terraform test rule f5e3aa35-88cd-4bce-88e3-d6e8fb38c1e7"
  campaign_rule_actions {
    action_type = "turnOnCampaign"
    campaign_rule_action_entities {
      use_triggering_entity = false
    }
    id = "0e834744-1eb7-48e0-9030-6e8bed66e628"
    parameters {
      priority     = "2"
      value        = "0.4"
      dialing_mode = "preview"
      operator     = "lessThan"
    }
  }
  campaign_rule_conditions {
    condition_type = "campaignProgress"
    id             = "e6a6a0b4-c737-40f5-a433-5b9499436219"
    parameters {
      value        = "0.4"
      dialing_mode = "preview"
      operator     = "lessThan"
      priority     = "2"
    }
  }
  campaign_rule_entities {
  }
  enabled = false
}

resource "genesyscloud_outbound_campaignrule" "Terraform_test_rule_817a8798-9b63-456e-8d53-79d9c3bfc191" {
  name = "Terraform test rule 817a8798-9b63-456e-8d53-79d9c3bfc191"
  campaign_rule_actions {
    action_type = "turnOnCampaign"
    campaign_rule_action_entities {
      use_triggering_entity = false
    }
    id = "87874267-c0db-4b57-98ac-5dd91b386292"
  }
  campaign_rule_conditions {
    condition_type = "campaignAgents"
    id             = "680383c2-5cd0-4df3-bb2b-98d788d08b26"
    parameters {
      operator = "greaterThan"
      value    = "50"
    }
  }
  campaign_rule_entities {
  }
  enabled              = false
  match_any_conditions = true
}

resource "genesyscloud_architect_schedulegroups" "Regular_Business_Operating_Hours" {
  name                 = "Regular Business Operating Hours"
  open_schedules_id    = ["${genesyscloud_architect_schedules.Business_Hours.id}"]
  time_zone            = "America/New_York"
  closed_schedules_id  = ["${genesyscloud_architect_schedules.Weekend.id}", "${genesyscloud_architect_schedules.After_Hours.id}"]
  division_id          = "${genesyscloud_auth_division.New_Home.id}"
  holiday_schedules_id = ["${genesyscloud_architect_schedules.Christmas.id}", "${genesyscloud_architect_schedules.Canada_Day.id}", "${genesyscloud_architect_schedules.Civic_Holiday.id}", "${genesyscloud_architect_schedules.Labour_Day.id}", "${genesyscloud_architect_schedules.Boxing_Day.id}", "${genesyscloud_architect_schedules.Victoria_Day.id}"]
}

resource "genesyscloud_recording_media_retention_policy" "Prince_Test" {
  enabled = true
  name    = "Prince Test"
  media_policies {
    call_policy {
      actions {
        always_delete    = false
        delete_recording = false
        retention_duration {
          delete_retention {
            days = 365
          }
        }
        retain_recording = true
      }
      conditions {
      }
    }
  }
  order = 0
}

resource "genesyscloud_recording_media_retention_policy" "Visibile_Prince" {
  enabled = true
  media_policies {
    call_policy {
      actions {
        retention_duration {
          delete_retention {
            days = 400
          }
        }
        delete_recording = false
        always_delete    = false
        retain_recording = true
      }
      conditions {
        for_queue_ids = ["${genesyscloud_routing_queue._24K.id}"]
      }
    }
  }
  name  = "Visibile Prince"
  order = 0
}

resource "genesyscloud_outbound_attempt_limit" "Test_Attempt_Limit_153134ae-c6c9-410d-8825-04fc41e25109" {
  max_attempts_per_number  = 5
  name                     = "Test Attempt Limit 153134ae-c6c9-410d-8825-04fc41e25109"
  reset_period             = "TODAY"
  time_zone_id             = "America/Chicago"
  max_attempts_per_contact = 5
}

resource "genesyscloud_integration_action" "Get_Schedule_Details" {
  secure = false
  config_response {
    translation_map = {
      RRule         = "$.entities[?(@.id != '')].rrule"
      ScheduleEnd   = "$.entities[?(@.id != '')].end"
      ScheduleStart = "$.entities[?(@.id != '')].start"
      State         = "$.entities[?(@.id != '')].state"
    }
    success_template = "{\"ScheduleStart\": $${successTemplateUtils.firstFromArray($${ScheduleStart})}, \"ScheduleEnd\": $${successTemplateUtils.firstFromArray($${ScheduleEnd})}, \"State\": $${successTemplateUtils.firstFromArray($${State})}, \"RRule\": $${successTemplateUtils.firstFromArray($${RRule})}}"
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "properties" = {
	  	  "searchAttribute" = {
	  	  	  "description" = "The name of the Schedule matching exactly or with a wildcard * character",
	  	  	  "title" = "Schedule Name",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "searchAttribute"
	  ],
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "properties" = {
	  	  "RRule" = {
	  	  	  "description" = "",
	  	  	  "title" = "Rrule",
	  	  	  "type" = "string"
	  	  },
	  	  "ScheduleEnd" = {
	  	  	  "description" = "",
	  	  	  "title" = "End",
	  	  	  "type" = "string"
	  	  },
	  	  "ScheduleStart" = {
	  	  	  "description" = "",
	  	  	  "title" = "Start",
	  	  	  "type" = "string"
	  	  },
	  	  "State" = {
	  	  	  "description" = "",
	  	  	  "title" = "State",
	  	  	  "type" = "string"
	  	  }
	  },
	  "title" = "Open and Closed Times",
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name            = "Get Schedule Details"
  category        = "Genesys Cloud Public API Integration"
  config_request {
    request_type         = "GET"
    request_url_template = "/api/v2/architect/schedules?name=$esc.url($${input.searchAttribute})"
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template = "$${input.rawRequest}"
  }
}

resource "genesyscloud_integration_action" "Get_External_Contact_Details" {
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  category       = "Genesys Cloud Public API Integration"
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/externalcontacts/contacts?q=$${input.searchAttribute}"
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "searchAttribute" = {
	  	  	  "description" = "Enter specific string to search for E.g. 'Postcode 2060'",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "searchAttribute"
	  ],
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "contactAddress1" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactCellPhone" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactCity" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactCountryCode" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactFirstName" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactHomePhone" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactLastName" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactOrgName" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactOrgType" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactOtherEmail" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactPersonalEmail" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactPostalCode" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactState" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactTitle" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactWorkEmail" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactWorkPhone" = {
	  	  	  "type" = "string"
	  	  },
	  	  "surveyOptOut" = {
	  	  	  "type" = "boolean"
	  	  }
	  },
	  "type" = "object"
  })
  config_response {
    success_template = "{\"contactId\": $${successTemplateUtils.firstFromArray($${contactId},\"$esc.quote$esc.quote\")}, \"contactFirstName\": $${successTemplateUtils.firstFromArray($${contactFirstName},\"$esc.quote$esc.quote\")}, \"contactLastName\": $${successTemplateUtils.firstFromArray($${contactLastName},\"$esc.quote$esc.quote\")}, \"contactTitle\": $${successTemplateUtils.firstFromArray(\"$${contactTitle}\",\"$esc.quote$esc.quote\")}, \"contactPostCode\": $${successTemplateUtils.firstFromArray(\"$${contactPostCode}\",\"$esc.quote$esc.quote\")}, \"contactOrgName\": $${successTemplateUtils.firstFromArray(\"$${contactOrgName}\",\"$esc.quote$esc.quote\")}, \"contactOrgType\": $${successTemplateUtils.firstFromArray(\"$${contactOrgType}\",\"$esc.quote$esc.quote\")}, \"contactWorkPhone\": $${successTemplateUtils.firstFromArray(\"$${contactWorkPhone}\",\"$esc.quote$esc.quote\")}, \"contactCellPhone\": $${successTemplateUtils.firstFromArray(\"$${contactCellPhone}\",\"$esc.quote$esc.quote\")}, \"contactHomePhone\": $${successTemplateUtils.firstFromArray(\"$${contactHomePhone}\",\"$esc.quote$esc.quote\")}, \"contactAddress1\": $${successTemplateUtils.firstFromArray(\"$${contactAddress1}\",\"$esc.quote$esc.quote\")}, \"contactCity\": $${successTemplateUtils.firstFromArray(\"$${contactCity}\",\"$esc.quote$esc.quote\")}, \"contactState\": $${successTemplateUtils.firstFromArray(\"$${contactState}\",\"$esc.quote$esc.quote\")}, \"contactCountryCode\": $${successTemplateUtils.firstFromArray(\"$${contactCountryCode}\",\"$esc.quote$esc.quote\")}, \"surveyOptOut\": $${successTemplateUtils.firstFromArray(\"$${surveyOptOut}\",\"false\")},\"contactWorkEmail\": $${successTemplateUtils.firstFromArray(\"$${contactWorkEmail}\",\"$esc.quote$esc.quote\")},\"contactPersonalEmail\": $${successTemplateUtils.firstFromArray(\"$${contactPersonalEmail}\",\"$esc.quote$esc.quote\")},\"contactOtherEmail\": $${successTemplateUtils.firstFromArray(\"$${contactOtherEmail}\",\"$esc.quote$esc.quote\")}}"
    translation_map = {
      contactAddress1      = "$.entities[?(@.id != '')].address.address1"
      contactCellPhone     = "$.entities[?(@.id != '')].cellPhone.e164"
      contactCity          = "$.entities[?(@.id != '')].address.city"
      contactCountryCode   = "$.entities[?(@.id != '')].address.countryCode"
      contactFirstName     = "$.entities[?(@.id != '')].firstName"
      contactHomePhone     = "$.entities[?(@.id != '')].homePhone.e164"
      contactId            = "$.entities[?(@.id != '')].id"
      contactLastName      = "$.entities[?(@.id != '')].lastName"
      contactOrgName       = "$.entities[?(@.id != '')].externalOrganization.name"
      contactOrgType       = "$.entities[?(@.id != '')].externalorganization.companyType"
      contactOtherEmail    = "$.entities[?(@.id != '')].otherEmail"
      contactPersonalEmail = "$.entities[?(@.id != '')].personalEmail"
      contactPostCode      = "$.entities[?(@.id != '')].address.postalCode"
      contactState         = "$.entities[?(@.id != '')].address.state"
      contactTitle         = "$.entities[?(@.id != '')].title"
      contactWorkEmail     = "$.entities[?(@.id != '')].workEmail"
      contactWorkPhone     = "$.entities[?(@.id != '')].workPhone.e164"
      surveyOptOut         = "$.entities[?(@.id != '')].surveyOptOut"
    }
  }
  name   = "Get External Contact Details"
  secure = false
}

resource "genesyscloud_integration_action" "Get_Current_Active_Conversation_ID_by_User_ID" {
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name           = "Get Current Active Conversation ID by User ID"
  secure         = false
  category       = "Genesys Cloud Public API Integration"
  config_response {
    success_template = "{\n   \"conversationId\": $${conversationId}\n}"
    translation_map = {
      conversationId = "$.conversations[0].conversationId"
    }
    translation_map_defaults = {
      conversationId = "\"Not Found\""
    }
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "description" = "Fields needed in the body of the POST to create a query.",
	  "properties" = {
	  	  "Interval" = {
	  	  	  "type" = "string"
	  	  },
	  	  "userId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "Interval",
	  	  "userId"
	  ],
	  "title" = "Query for Active voice conversations.",
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "description" = "The full response from the analyitics query.",
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "title" = "Analyitics Query Response",
	  "type" = "object"
  })
  config_request {
    headers = {
      Content-Type = "application/json"
    }
    request_template     = "{\n \"interval\": \"$${input.Interval}\",\n \"order\": \"desc\",\n \"orderBy\": \"conversationStart\",\n \"segmentFilters\": [\n  {\n   \"type\": \"and\",\n   \"predicates\": [\n    {\n     \"type\": \"dimension\",\n     \"dimension\": \"userId\",\n     \"operator\": \"matches\",\n     \"value\": \"$${input.userId}\"\n    },\n    {\n     \"type\": \"dimension\",\n     \"dimension\": \"segmentEnd\",\n     \"operator\": \"notExists\",\n     \"value\": null\n    },\n    {\n     \"type\": \"dimension\",\n     \"dimension\": \"mediaType\",\n     \"operator\": \"matches\",\n     \"value\": \"voice\"\n    }\n   ]\n  }\n ]\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/analytics/conversations/details/query"
  }
}

resource "genesyscloud_integration_action" "Get_Most_Recent_Open_Case_By_Contact_Id_-_Extended_v2" {
  secure   = false
  category = "DaveG - Salesforce Data Actions - DG Sandbox"
  config_request {
    headers = {
      UserAgent = "PureCloudIntegrations/1.0"
    }
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/services/data/v37.0/query/?q=$esc.url(\"SELECT AccountId, AssetId, CaseNumber, ClosedDate, CreatedById, CreatedDate, Description, Id, IsClosed, IsDeleted, IsEscalated, LastModifiedById, LastModifiedDate, Origin, OwnerId, ParentId, Priority, Reason, Status, Subject, Product__c, SuppliedCompany, SuppliedEmail, SuppliedName, SuppliedPhone, SystemModstamp, Type, Contact.Name, Contact.FirstName, Contact.LastName, Contact.Email, Contact.Fax, Contact.Id, Contact.Phone from Case where ContactId= '$salesforce.escReserved($${input.CONTACT_ID})' AND IsClosed = false ORDER BY LastModifiedDate DESC LIMIT 1\")"
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "A contact ID-based request.",
	  "properties" = {
	  	  "CONTACT_ID" = {
	  	  	  "description" = "The contact ID used to query Salesforce.",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "CONTACT_ID"
	  ],
	  "title" = "Case Request",
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "AccountId" = {
	  	  	  "description" = "The Salesforce account ID.",
	  	  	  "type" = "string"
	  	  },
	  	  "AssetId" = {
	  	  	  "description" = "The asset ID associated with case.",
	  	  	  "type" = "string"
	  	  },
	  	  "CaseNumber" = {
	  	  	  "description" = "The case number.",
	  	  	  "type" = "string"
	  	  },
	  	  "ClosedDate" = {
	  	  	  "description" = "The close date of the case (UTC).",
	  	  	  "type" = "string"
	  	  },
	  	  "Contact" = {
	  	  	  "additionalProperties" = true,
	  	  	  "description" = "The contact information.",
	  	  	  "properties" = {
	  	  	  	  "Email" = {
	  	  	  	  	  "description" = "The email address of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  },
	  	  	  	  "Fax" = {
	  	  	  	  	  "description" = "The fax number of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  },
	  	  	  	  "FirstName" = {
	  	  	  	  	  "description" = "The first name of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  },
	  	  	  	  "Id" = {
	  	  	  	  	  "description" = "The ID of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  },
	  	  	  	  "LastName" = {
	  	  	  	  	  "description" = "The last name of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  },
	  	  	  	  "Name" = {
	  	  	  	  	  "description" = "The full name of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  },
	  	  	  	  "Phone" = {
	  	  	  	  	  "description" = "The phone number of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  }
	  	  	  },
	  	  	  "required" = [
	  	  	  	  "Id"
	  	  	  ],
	  	  	  "type" = "object"
	  	  },
	  	  "CreatedById" = {
	  	  	  "description" = "The ID of the creator of the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "CreatedDate" = {
	  	  	  "description" = "The date that the case was created (UTC).",
	  	  	  "type" = "string"
	  	  },
	  	  "Description" = {
	  	  	  "description" = "The description of the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "Id" = {
	  	  	  "type" = "string"
	  	  },
	  	  "IsClosed" = {
	  	  	  "description" = "The closed property of the case.",
	  	  	  "type" = "boolean"
	  	  },
	  	  "IsDeleted" = {
	  	  	  "description" = "The deleted property of the case.",
	  	  	  "type" = "boolean"
	  	  },
	  	  "IsEscalated" = {
	  	  	  "description" = "The escalated property of the case.",
	  	  	  "type" = "boolean"
	  	  },
	  	  "LastModifiedById" = {
	  	  	  "description" = "The ID of the user who last modified the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "LastModifiedDate" = {
	  	  	  "description" = "The date of the last modification (UTC).",
	  	  	  "type" = "string"
	  	  },
	  	  "Origin" = {
	  	  	  "description" = "The origination of the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "OwnerId" = {
	  	  	  "description" = "The ID of the case owner.",
	  	  	  "type" = "string"
	  	  },
	  	  "ParentId" = {
	  	  	  "description" = "The parent case ID, if there is a parent.",
	  	  	  "type" = "string"
	  	  },
	  	  "Priority" = {
	  	  	  "description" = "The priority property of the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "Product__c" = {
	  	  	  "type" = "string"
	  	  },
	  	  "Reason" = {
	  	  	  "description" = "The case reason.",
	  	  	  "type" = "string"
	  	  },
	  	  "Status" = {
	  	  	  "description" = "The status of the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "Subject" = {
	  	  	  "description" = "The subject of the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "SuppliedCompany" = {
	  	  	  "description" = "The company name supplied with the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "SuppliedEmail" = {
	  	  	  "description" = "The email address supplied with the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "SuppliedName" = {
	  	  	  "description" = "The name supplied with the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "SuppliedPhone" = {
	  	  	  "description" = "The phone number supplied with the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "SystemModstamp" = {
	  	  	  "description" = "The system modification time stamp.",
	  	  	  "type" = "string"
	  	  },
	  	  "Type" = {
	  	  	  "description" = "The type of the case.",
	  	  	  "type" = "string"
	  	  }
	  },
	  "title" = "Case",
	  "type" = "object"
  })
  name            = "Get Most Recent Open Case By Contact Id - Extended v2"
  config_response {
    success_template = "$${successTemplateUtils.firstFromArray(\"$${case}\",\"{}\")}"
    translation_map = {
      case = "$.records"
    }
    translation_map_defaults = {
      case = "[]"
    }
  }
  integration_id = "${genesyscloud_integration.DaveG_-_Salesforce_Data_Actions_-_DG_Sandbox.id}"
}

resource "genesyscloud_integration_action" "Get_Interaction_State" {
  integration_id = "${genesyscloud_integration.Accelerator_-_Automated_Callbacks.id}"
  secure         = false
  config_request {
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/conversations/$${input.conversationId}"
  }
  config_response {
    success_template = "{\"state\": $${state}}"
    translation_map = {
      state = "$.participants[0].callbacks[0].state"
    }
    translation_map_defaults = {
      state = "disconnected"
    }
  }
  contract_input  = jsonencode({
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "conversationId"
	  ],
	  "type" = "object"
  })
  category        = "Accelerator - Automated Callbacks"
  contract_output = jsonencode({
	  "properties" = {
	  	  "state" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  name            = "Get Interaction State"
}

resource "genesyscloud_integration_action" "Create_Queued_Callback" {
  category        = "Genesys Cloud Public API Integration"
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {},
	  "type" = "object"
  })
  name            = "Create Queued Callback"
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  secure          = false
  config_request {
    request_template     = "{\n\"scriptId\": \"$!{input.scriptId}\",\n\"callbackNumbers\": [ \"$${input.phone}\" ],\n\"routingData\": {\n\"queueId\": \"$${input.queueId}\"\n}\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/conversations/$${input.conversationId}/participants/$${input.participantId}/callbacks"
  }
  config_response {
    success_template = "$${rawResult}"
  }
  contract_input = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "participantId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "phone" = {
	  	  	  "type" = "string"
	  	  },
	  	  "queueId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "scriptId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
}

resource "genesyscloud_integration_action" "qweqweq" {
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "23123"
  }
  integration_id = "${genesyscloud_integration.Prince_GC.id}"
  name           = "qweqweq"
  secure         = false
  category       = "Prince_GC"
  config_response {
    success_template = "$${rawResult}"
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {},
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "items" = [
	  	  {
	  	  	  "additionalProperties" = true,
	  	  	  "properties" = {
	  	  	  	  "aaaaaa" = {
	  	  	  	  	  "type" = "string"
	  	  	  	  }
	  	  	  },
	  	  	  "title" = "Item 1",
	  	  	  "type" = "object"
	  	  },
	  	  {
	  	  	  "additionalProperties" = true,
	  	  	  "properties" = {
	  	  	  	  "aaaaaa" = {
	  	  	  	  	  "type" = "string"
	  	  	  	  }
	  	  	  },
	  	  	  "title" = "Item 2",
	  	  	  "type" = "object"
	  	  }
	  ],
	  "properties" = {},
	  "type" = "array"
  })
}

resource "genesyscloud_integration_action" "Get_User_Presences_by_Queue_ID" {
  config_request {
    request_type         = "POST"
    request_url_template = "/api/v2/analytics/queues/observations/query"
    request_template     = "{\"filter\": \n {\"type\": \"or\", \n \"predicates\": \n [{\"type\": \"dimension\",\n\"dimension\": \"queueId\",\n\"operator\": \"matches\",\n\"value\": \"$${input.QueueID}\"}]},\n\"metrics\": [\"oUserPresences\"]}"
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "QueueID" = {
	  	  	  "description" = "Specify the QueueID (use Get Queue ID by Name action)",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "QueueID"
	  ],
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "Available" = {
	  	  	  "description" = "Number of available agents",
	  	  	  "type" = "integer"
	  	  },
	  	  "Away" = {
	  	  	  "description" = "Number of away agents",
	  	  	  "type" = "integer"
	  	  },
	  	  "Busy" = {
	  	  	  "description" = "Number of busy agents",
	  	  	  "type" = "integer"
	  	  },
	  	  "Meal" = {
	  	  	  "description" = "Number of hungry agents",
	  	  	  "type" = "integer"
	  	  },
	  	  "Offline" = {
	  	  	  "description" = "Number of agents not logged in",
	  	  	  "type" = "integer"
	  	  },
	  	  "OnQueue" = {
	  	  	  "description" = "Number of on-queue agents",
	  	  	  "type" = "integer"
	  	  }
	  },
	  "type" = "object"
  })
  category        = "Genesys Cloud Public API Integration"
  config_response {
    success_template = "{\"Away\": $${successTemplateUtils.firstFromArray($${Away}, \"0\")}, \"Available\": $${successTemplateUtils.firstFromArray($${Available}, \"0\")}, \"Meal\": $${successTemplateUtils.firstFromArray($${Meal}, \"0\")}, \"OnQueue\": $${successTemplateUtils.firstFromArray($${OnQueue}, \"0\")}, \"Busy\": $${successTemplateUtils.firstFromArray($${Busy}, \"0\")}, \"Offline\": $${successTemplateUtils.firstFromArray($${Offline}, \"0\")}}"
    translation_map = {
      Available = "$..data[?(@.metric == 'oUserPresences' && @.qualifier == '6a3af858-942f-489d-9700-5f9bcdcdae9b')].stats.count"
      Away      = "$..data[?(@.metric == 'oUserPresences' && @.qualifier == '5e5c5c66-ea97-4e7f-ac41-6424784829f2')].stats.count"
      Busy      = "$..data[?(@.metric == 'oUserPresences' && @.qualifier == '31fe3bac-dea6-44b7-bed7-47f91660a1a0')].stats.count"
      Meal      = "$..data[?(@.metric == 'oUserPresences' && @.qualifier == '3fd96123-badb-4f69-bc03-1b1ccc6d8014')].stats.count"
      Offline   = "$..data[?(@.metric == 'oUserPresences' && @.qualifier == 'ccf3c10a-aa2c-4845-8e8d-f59fa48c58e5')].stats.count"
      OnQueue   = "$..data[?(@.metric == 'oUserPresences' && @.qualifier == 'e08eaf1b-ee47-4fa9-a231-1200e284798f')].stats.count"
    }
    translation_map_defaults = {
      Available = "0"
      Away      = "0"
      Busy      = "0"
      Meal      = "0"
      Offline   = "0"
      OnQueue   = "0"
    }
  }
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name           = "Get User Presences by Queue ID"
  secure         = false
}

resource "genesyscloud_integration_action" "Get_Division_IDs_for_Conversation_ID" {
  config_response {
    translation_map = {
      divisionid = "$.divisions[*].division.id"
    }
    success_template = "{\"divisionIds\":$${divisionid}}"
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "divisionIds" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  category        = "Genesys Cloud Public API Integration"
  config_request {
    headers = {
      Content-Type = "application/json"
    }
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/conversations/$${input.conversationId}"
  }
  name   = "Get Division IDs for Conversation ID"
  secure = false
}

resource "genesyscloud_integration_action" "Get_Contact_By_Phone_Number__Extended_" {
  category = "DaveG - Salesforce Data Actions - DG Sandbox"
  config_request {
    headers = {
      UserAgent = "PureCloudIntegrations/1.0"
    }
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/services/data/v37.0/search/?q=$esc.url(\"FIND {$salesforce.escReserved($${input.PHONE_NUMBER}))} IN PHONE FIELDS RETURNING Contact(AccountId,Birthdate,CreatedDate,Description,Email,Fax,FirstName,HomePhone,Id,IsDeleted,LastName,LeadSource,MailingAddress,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,MobilePhone,Name,OwnerId,Phone,Salutation,Title,Follow_up_Preference__c,Language_Preference__c,Policy_Number__c)\")"
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "A phone number-based request.",
	  "properties" = {
	  	  "PHONE_NUMBER" = {
	  	  	  "description" = "The phone number used for the query.",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "PHONE_NUMBER"
	  ],
	  "title" = "Phone Number Request",
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "items" = {
	  	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  	  "additionalProperties" = true,
	  	  "description" = "A  Salesforce contact.",
	  	  "properties" = {
	  	  	  "Email" = {
	  	  	  	  "description" = "The email address of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "FirstName" = {
	  	  	  	  "description" = "The first name of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Follow_up_Preference__c" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "HomePhone" = {
	  	  	  	  "description" = "The home phone number of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Id" = {
	  	  	  	  "description" = "The ID of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Language_Preference__c" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "LastName" = {
	  	  	  	  "description" = "The last name of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "MailingCity" = {
	  	  	  	  "description" = "The city of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "MailingCountry" = {
	  	  	  	  "description" = "The country of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "MailingPostalCode" = {
	  	  	  	  "description" = "The postal code of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "MailingState" = {
	  	  	  	  "description" = "The state of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "MailingStreet" = {
	  	  	  	  "description" = "The street address of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "MobilePhone" = {
	  	  	  	  "description" = "The mobile phone number of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "OtherPhone" = {
	  	  	  	  "description" = "Other phone number of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Phone" = {
	  	  	  	  "description" = "The phone number of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Policy_Number__c" = {
	  	  	  	  "type" = "string"
	  	  	  }
	  	  },
	  	  "required" = [
	  	  	  "Id"
	  	  ],
	  	  "title" = "Contact",
	  	  "type" = "object"
	  },
	  "properties" = {},
	  "type" = "array"
  })
  config_response {
    success_template = "$${contact}"
    translation_map = {
      contact = "$.searchRecords"
    }
  }
  integration_id = "${genesyscloud_integration.DaveG_-_Salesforce_Data_Actions_-_DG_Sandbox.id}"
  name           = "Get Contact By Phone Number (Extended)"
  secure         = false
}

resource "genesyscloud_integration_action" "Manually_Assign_Agent_to_Conversation" {
  contract_input = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "agentId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "conversationId",
	  	  "agentId"
	  ],
	  "type" = "object"
  })
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name           = "Manually Assign Agent to Conversation"
  category       = "Genesys Cloud Public API Integration"
  config_request {
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template     = "{\r\n \"id\": \"$${input.agentId}\" \r\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/conversations/$${input.conversationId}/assign"
  }
  config_response {
    success_template = "$${rawResult}"
  }
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {},
	  "type" = "object"
  })
  secure          = false
}

resource "genesyscloud_integration_action" "Update_Conversation_Priority_In-Queue" {
  name            = "Update Conversation Priority In-Queue"
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "priority" = {
	  	  	  "type" = "integer"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "priority" = {
	  	  	  "description" = "The new priority of the in-queue conversation.",
	  	  	  "type" = "integer"
	  	  }
	  },
	  "type" = "object"
  })
  config_response {
    success_template = "$${rawResult}"
  }
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  secure         = false
  category       = "Genesys Cloud Public API Integration"
  config_request {
    request_template     = "{ \"priority\": $${input.priority} }"
    request_type         = "PATCH"
    request_url_template = "/api/v2/routing/conversations/$${input.conversationId}"
  }
}

resource "genesyscloud_integration_action" "Get_User_ID_by_Email" {
  category        = "Genesys Cloud Public API Integration"
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "GET user ID via email",
	  "properties" = {
	  	  "email" = {
	  	  	  "description" = "The email address from a user.",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "email"
	  ],
	  "title" = "UserIdRequest",
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "Returns a userID.",
	  "properties" = {
	  	  "results.id" = {
	  	  	  "description" = "The User ID of an agent",
	  	  	  "type" = "string"
	  	  }
	  },
	  "title" = "Get a userID based on an email address given",
	  "type" = "object"
  })
  secure          = false
  config_request {
    headers = {
      Content-Type = "application/json"
    }
    request_template     = "{\r\n  \"query\": [\r\n     {\r\n        \"value\": \"$${input.email}\",\r\n        \"fields\": [\"workemail\",\"email\"],\r\n        \"type\": \"EXACT\"\r\n     }\r\n  ]\r\n}\r\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/users/search"
  }
  config_response {
    translation_map = {
      results_id = "$.results[0].id"
    }
    success_template = "{\"results.id\":$${results_id}}"
  }
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name           = "Get User ID by Email"
}

resource "genesyscloud_integration_action" "Get_Conversation_Start_Time" {
  category = "Genesys Cloud Public API Integration"
  config_response {
    success_template = "{\n   \"StartDateTime\": $${startTime}\n}"
    translation_map = {
      startTime = "$.startTime"
    }
  }
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "Returns datetime in UTC.",
	  "properties" = {
	  	  "StartDateTime" = {
	  	  	  "description" = "Call start DateTimeUTC",
	  	  	  "type" = "string"
	  	  }
	  },
	  "title" = "Get Members of queue",
	  "type" = "object"
  })
  name            = "Get Conversation Start Time"
  secure          = false
  config_request {
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/conversations/$${input.ConversationID}"
  }
  contract_input = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "A request for the customer call start datetime",
	  "properties" = {
	  	  "ConversationID" = {
	  	  	  "description" = "Conversation/interaction ID",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "ConversationID"
	  ],
	  "type" = "object"
  })
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
}

resource "genesyscloud_integration_action" "Log_Out_User_by_ID" {
  config_response {
    success_template = "$${rawResult}"
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "userId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {},
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  secure          = false
  category        = "Genesys Cloud Public API Integration"
  name            = "Log Out User by ID"
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "DELETE"
    request_url_template = "/api/v2/tokens/$${input.userId}"
  }
}

resource "genesyscloud_integration_action" "Get_Outbound_Call_-_Check_if_Picked_Up" {
  config_response {
    success_template = "{\"segmentType\": $${segmentType}}"
    translation_map = {
      segmentType = "['participants'][?(@.purpose=='user')]['sessions'][?(@.direction=='outbound')]['segments'][?(@.segmentType=='interact')].segmentType"
    }
  }
  integration_id  = "${genesyscloud_integration.Accelerator_-_Update_User_On_Communicate_Call.id}"
  name            = "Get Outbound Call - Check if Picked Up"
  secure          = false
  category        = "Accelerator - Update User On Communicate Call"
  contract_input  = jsonencode({
	  "properties" = {
	  	  "CONVERSATION_ID" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "properties" = {
	  	  "segmentType" = {
	  	  	  "items" = {
	  	  	  	  "title" = "segmentType",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "type" = "object"
  })
  config_request {
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/analytics/conversations/$${input.CONVERSATION_ID}/details"
  }
}

resource "genesyscloud_integration_action" "Get_User_ID_by_Extension" {
  category = "Genesys Cloud Public API Integration"
  config_response {
    success_template = "{\"id\": $${id}}"
    translation_map = {
      id = "$.results[0].id"
    }
  }
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name           = "Get User ID by Extension"
  secure         = false
  config_request {
    headers = {
      Content-Type = "application/json"
    }
    request_template     = "{\r\n  \"pageSize\": 1,\r\n  \"pageNumber\": 1,\r\n  \"types\": [\r\n    \"users\"\r\n  ],\r\n  \"sortOrder\": \"SCORE\",\r\n  \"query\": [\r\n    {\r\n      \"type\": \"EXACT\",\r\n      \"fields\": [\r\n        \"addresses\"\r\n      ],\r\n      \"operator\": \"AND\",\r\n      \"value\": \"$${input.userExtension}\"\r\n    }\r\n  ]\r\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/search?profile=false"
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "userExtension" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "id" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "title" = "results",
	  "type" = "object"
  })
}

resource "genesyscloud_integration_action" "Update_User_Presence" {
  contract_output = jsonencode({
	  "properties" = {},
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Accelerator_-_Update_User_On_Communicate_Call.id}"
  name            = "Update User Presence"
  config_request {
    request_url_template = "/api/v2/users/$${input.USER_ID}/presences/purecloud"
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template = "{\"presenceDefinition\": {\"id\": \"$${input.PRESENCE_DEFINITION_ID}\"},\"primary\": true}"
    request_type     = "PATCH"
  }
  config_response {
    success_template = "$${rawResult}"
  }
  contract_input = jsonencode({
	  "properties" = {
	  	  "PRESENCE_DEFINITION_ID" = {
	  	  	  "type" = "string"
	  	  },
	  	  "USER_ID" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  secure         = false
  category       = "Accelerator - Update User On Communicate Call"
}

resource "genesyscloud_integration_action" "Send_Agentless_Email" {
  contract_output = jsonencode({
	  "properties" = {
	  	  "CONVERSATION_ID" = {
	  	  	  "type" = "string"
	  	  },
	  	  "ID" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "ID",
	  	  "CONVERSATION_ID"
	  ],
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Accelerator_-_Send_Email_Notification_on_Message_Failed.id}"
  name            = "Send Agentless Email"
  category        = "Accelerator - Send Email Notification on Message Failed"
  config_response {
    success_template = "{\n   \"ID\": $${ID}, \"CONVERSATION_ID\": $${CONVERSATION_ID}\n}"
    translation_map = {
      CONVERSATION_ID = "$.conversationId"
      ID              = "$.id"
    }
  }
  contract_input = jsonencode({
	  "properties" = {
	  	  "BODY" = {
	  	  	  "type" = "string"
	  	  },
	  	  "FROM_EMAIL" = {
	  	  	  "type" = "string"
	  	  },
	  	  "SENDER_TYPE" = {
	  	  	  "type" = "string"
	  	  },
	  	  "SUBJECT" = {
	  	  	  "type" = "string"
	  	  },
	  	  "TO_EMAIL" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "FROM_EMAIL",
	  	  "TO_EMAIL",
	  	  "SUBJECT",
	  	  "BODY",
	  	  "SENDER_TYPE"
	  ],
	  "type" = "object"
  })
  secure         = false
  config_request {
    headers = {
      Cache-Control = "no-cache"
      Content-Type  = "application/json"
      UserAgent     = "PureCloudIntegrations/1.0"
    }
    request_template     = "{\"senderType\": \"$${input.SENDER_TYPE}\", \"fromAddress\" : {\"email\": \"$${input.FROM_EMAIL}\"}, \"toAddresses\" : [{\"email\": \"$${input.TO_EMAIL}\"}], \"subject\" : \"$${input.SUBJECT}\", \"textBody\" : \"$esc.jsonString($${input.BODY})\"}"
    request_type         = "POST"
    request_url_template = "/api/v2/conversations/emails/agentless"
  }
}

resource "genesyscloud_integration_action" "Update_External_Tag_on_Conversation_1229772771_3464023059" {
  category = "Orbit Data Actions OAuth Integration"
  config_response {
    success_template = "{rawResult}"
  }
  contract_input = jsonencode({
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "externalTag" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  secure         = false
  config_request {
    request_template     = "{\n  \"externalTag\": \"$${input.externalTag}\"\n}"
    request_type         = "PUT"
    request_url_template = "/api/v2/conversations/$${input.conversationId}/tags"
    headers = {
      Cache-Control = "no-cache"
      Content-Type  = "application/json"
      UserAgent     = "PureCloudIntegrations/1.0"
    }
  }
  contract_output = jsonencode({
	  "properties" = {},
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Orbit_Data_Actions_OAuth_Integration_2604983327_3497928598.id}"
  name            = "Update External Tag on Conversation"
}

resource "genesyscloud_integration_action" "Set_Queue_Membership" {
  config_request {
    request_template     = "[\n  {\n    \"id\": \"$${input.userId}\"\n  }\n]"
    request_type         = "POST"
    request_url_template = "/api/v2/routing/queues/$${input.queueId}/members?delete=$${input.delete}"
  }
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {},
	  "type" = "object"
  })
  name            = "Set Queue Membership"
  category        = "Genesys Cloud Public API Integration"
  config_response {
    success_template = "$${rawResult}"
  }
  contract_input = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "delete" = {
	  	  	  "type" = "boolean"
	  	  },
	  	  "queueId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "userId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  secure         = false
}

resource "genesyscloud_integration_action" "LookupQueueName" {
  contract_output = jsonencode({
	  "properties" = {
	  	  "QueueName" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "QueueName"
	  ],
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.ComprehendDataAction.id}"
  name            = "LookupQueueName"
  secure          = false
  category        = "ComprehendDataAction"
  config_request {
    request_type         = "POST"
    request_url_template = "https://lw5n6y5cfe.execute-api.us-east-1.amazonaws.com/dev/emailresolver"
    headers = {
      X-API-Key                          = "A6ceupfQIL7oemrIfdtKq92MCzvjGUX29uXLK7sm"
      x-amazon-apigateway-api-key-source = "HEADER"
    }
    request_template = "$${input.rawRequest}"
  }
  config_response {
    success_template = "$${rawResult}"
  }
  contract_input = jsonencode({
	  "properties" = {
	  	  "EmailBody" = {
	  	  	  "type" = "string"
	  	  },
	  	  "EmailSubject" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "EmailSubject",
	  	  "EmailBody"
	  ],
	  "type" = "object"
  })
}

resource "genesyscloud_integration_action" "Disconnect_Callback" {
  integration_id = "${genesyscloud_integration.Accelerator_-_Automated_Callbacks.id}"
  name           = "Disconnect Callback"
  config_request {
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template     = "{\"state\": \"disconnected\"}"
    request_type         = "PATCH"
    request_url_template = "/api/v2/conversations/callbacks/$${input.conversationId}"
  }
  contract_input = jsonencode({
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "conversationId"
	  ],
	  "type" = "object"
  })
  secure         = false
  category       = "Accelerator - Automated Callbacks"
  config_response {
    success_template = "$${rawResult}"
  }
  contract_output = jsonencode({
	  "properties" = {},
	  "type" = "object"
  })
}

resource "genesyscloud_integration_action" "Execute_Workflow" {
  category        = "Accelerator - Automated Callbacks"
  contract_output = jsonencode({
	  "properties" = {},
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Accelerator_-_Automated_Callbacks.id}"
  name            = "Execute Workflow"
  secure          = false
  config_request {
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template     = "{\"flowId\": \"$${input.flowId}\", \"inputData\": { $${input.attributes} } }"
    request_type         = "POST"
    request_url_template = "/api/v2/flows/executions"
  }
  config_response {
    success_template = "$${rawResult}"
  }
  contract_input = jsonencode({
	  "properties" = {
	  	  "attributes" = {
	  	  	  "description" = "Add custom attributes using \"key\":\"value\", \"key\":\"value\" format",
	  	  	  "type" = "string"
	  	  },
	  	  "flowId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "flowId"
	  ],
	  "type" = "object"
  })
}

resource "genesyscloud_integration_action" "Get_Conversation_External_Contact" {
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/conversations/$${input.conversationId}"
  }
  config_response {
    success_template = "{ \"externalContactId\": $${successTemplateUtils.firstFromArray(\"$${externalContactId}\", \"$esc.quote$esc.quote\")}, \"communicationId\": $${successTemplateUtils.firstFromArray(\"$${communicationId}\", \"$esc.quote$esc.quote\")} }"
    translation_map = {
      communicationId   = "$.participants[?(@.purpose=='customer' || @.purpose=='external')].calls[0].id"
      externalContactId = "$.participants[?(@.purpose=='customer' || @.purpose=='external')].externalContactId"
    }
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "communicationId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "externalContactId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  category        = "Genesys Cloud Public API Integration"
  name            = "Get Conversation External Contact"
  secure          = false
}

resource "genesyscloud_integration_action" "Get_Oldest_Call_Waiting" {
  name            = "Get Oldest Call Waiting"
  secure          = false
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "description" = "Returns the oldest call waiting",
	  "properties" = {
	  	  "OLDEST_CALL_WAITING" = {
	  	  	  "description" = "oldest call waiting in the queue",
	  	  	  "type" = "string"
	  	  }
	  },
	  "title" = "Oldest Call Waiting",
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  config_response {
    success_template = "{\n   \"OLDEST_CALL_WAITING\": $${OLDEST_CALL_WAITING}\n }"
    translation_map = {
      OLDEST_CALL_WAITING = "$.conversations[0].conversationStart"
    }
    translation_map_defaults = {
      OLDEST_CALL_WAITING = "null"
    }
  }
  contract_input = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "description" = "The oldest call waiting for a queue.",
	  "properties" = {
	  	  "INTERVAL" = {
	  	  	  "description" = "The interval",
	  	  	  "type" = "string"
	  	  },
	  	  "QUEUE_ID" = {
	  	  	  "description" = "The queue ID.",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "QUEUE_ID",
	  	  "INTERVAL"
	  ],
	  "title" = "Oldest Call Waiting",
	  "type" = "object"
  })
  category       = "Genesys Cloud Public API Integration"
  config_request {
    request_template     = "{\n\t \"interval\": \"$${input.INTERVAL}\",\n\t \"order\": \"asc\",\n\t \"orderBy\": \"conversationStart\",\n\t \"paging\": {\n\t  \"pageSize\": 25,\n\t  \"pageNumber\": 1\n\t },\n\t \"segmentFilters\": [\n\t  {\n\t   \"type\": \"and\",\n\t   \"predicates\": [\n\t    {\n\t     \"type\": \"dimension\",\n\t     \"dimension\": \"queueId\",\n\t     \"operator\": \"matches\",\n\t     \"value\": \"$${input.QUEUE_ID}\"\n\t    },\n\t   \t{\n\t     \"type\": \"dimension\",\n\t     \"dimension\": \"userId\",\n\t     \"operator\": \"notExists\",\n\t     \"value\": null\n\t    }\n\t   ]\n\t  }\n\t ],\n\t \"conversationFilters\": [\n\t  {\n\t   \"type\": \"and\",\n\t   \"predicates\": [\n\t    {\n\t     \"type\": \"dimension\",\n\t     \"dimension\": \"conversationEnd\",\n\t     \"operator\": \"notExists\",\n\t     \"value\": null\n\t    }\n\t   ]\n\t  }\n\t ]\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/analytics/conversations/details/query"
    headers = {
      Content-Type = "application/json"
    }
  }
}

resource "genesyscloud_integration_action" "_22d23d2" {
  category       = "Prince_GC"
  integration_id = "${genesyscloud_integration.Prince_GC.id}"
  name           = "22d23d2"
  secure         = false
  config_request {
    request_type         = "GET"
    request_url_template = "qweqwe"
    request_template     = "$${input.rawRequest}"
  }
  config_response {
    success_template = "$${rawResult}"
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {},
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "items" = {
	  	  "additionalProperties" = true,
	  	  "properties" = {
	  	  	  "adasdasd" = {
	  	  	  	  "type" = "string"
	  	  	  }
	  	  },
	  	  "title" = "Item 1",
	  	  "type" = "object"
	  },
	  "properties" = {},
	  "type" = "array"
  })
}

resource "genesyscloud_integration_action" "Disconnect_Callback_Conversation" {
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name            = "Disconnect Callback Conversation"
  category        = "Genesys Cloud Public API Integration"
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "ConversationId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {},
	  "type" = "object"
  })
  secure          = false
  config_request {
    request_template     = "{ \"state\": \"disconnected\" }"
    request_type         = "PATCH"
    request_url_template = "/api/v2/conversations/callbacks/$${input.ConversationId}"
  }
  config_response {
    success_template = "$${rawResult}"
  }
}

resource "genesyscloud_integration_action" "Get_Callbacks_Waiting" {
  config_request {
    request_type         = "POST"
    request_url_template = "/api/v2/analytics/queues/observations/query"
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template = "{ \"filter\": { \"type\": \"and\", \"predicates\": [{ \"type\": \"dimension\", \"dimension\": \"mediaType\", \"operator\": \"matches\", \"value\": \"callback\" }, { \"type\": \"dimension\",  \"dimension\": \"queueId\",  \"operator\": \"matches\", \"value\": \"$${input.queueId}\" }]}, \"metrics\": [ \"oWaiting\"]}"
  }
  category        = "Accelerator - Automated Callbacks"
  contract_input  = jsonencode({
	  "properties" = {
	  	  "queueId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "queueId"
	  ],
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "properties" = {
	  	  "count" = {
	  	  	  "type" = "integer"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Accelerator_-_Automated_Callbacks.id}"
  name            = "Get Callbacks Waiting"
  secure          = false
  config_response {
    success_template = "{\"count\": $${count}}"
    translation_map = {
      count = "$.results[0].data[0].stats.count"
    }
    translation_map_defaults = {
      count = "0"
    }
  }
}

resource "genesyscloud_integration_action" "Get_User_Routing_Status_by_Email" {
  secure          = false
  category        = "Genesys Cloud Public API Integration"
  name            = "Get User Routing Status by Email"
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "properties" = {
	  	  "EmailAddress" = {
	  	  	  "description" = "Email Address",
	  	  	  "title" = "Email Address",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "EmailAddress"
	  ],
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "properties" = {
	  	  "routingStatus" = {
	  	  	  "description" = "Your agent's routing status",
	  	  	  "title" = "routingStatus",
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  config_request {
    headers = {
      Content-Type = "application/json"
    }
    request_template     = "{\n   \"expand\": [\"routingStatus\"],\n   \"query\": [\n      {\n         \"fields\": [\"email\"],\n         \"value\": \"$${input.EmailAddress}\",\n         \"operator\": \"AND\",\n         \"type\": \"EXACT\"\n      }\n   ]\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/users/search"
  }
  config_response {
    success_template = "{\r\n   \"routingStatus\": $${list}\r\n  }"
    translation_map = {
      list = "$.results[0].routingStatus.status"
    }
    translation_map_defaults = {
      list = "null"
    }
  }
}

resource "genesyscloud_integration_action" "Get_Failed_Delivery_Messages" {
  name = "Get Failed Delivery Messages"
  config_request {
    headers = {
      Cache-Control = "no-cache"
      Content-Type  = "application/x-www-form-urlencoded"
    }
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/conversations/$${input.CONVERSATION_ID}"
  }
  contract_input = jsonencode({
	  "properties" = {
	  	  "CONVERSATION_ID" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "CONVERSATION_ID"
	  ],
	  "type" = "object"
  })
  integration_id = "${genesyscloud_integration.Accelerator_-_Send_Email_Notification_on_Message_Failed.id}"
  category       = "Accelerator - Send Email Notification on Message Failed"
  config_response {
    translation_map = {
      FAILED_DELIVERY = "$.participants[?(@.purpose == 'agent')].messages[0].messages[?(@.messageStatus == 'delivery-failed')].messageId"
    }
    success_template = "{\n \"FAILED_DELIVERY\": $${successTemplateUtils.firstFromArray(\"$${FAILED_DELIVERY}\")}\n}"
  }
  contract_output = jsonencode({
	  "properties" = {
	  	  "FAILED_DELIVERY" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "FAILED_DELIVERY"
	  ],
	  "type" = "object"
  })
  secure          = false
}

resource "genesyscloud_integration_action" "Get_User_Out_Of_Office_Status" {
  name     = "Get User Out Of Office Status"
  secure   = false
  category = "Genesys Cloud Public API Integration"
  config_response {
    translation_map = {
      active = "$.active"
    }
    success_template = "{\"active\": $${active}\n}"
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "description" = "A user ID-based request.",
	  "properties" = {
	  	  "USER_ID" = {
	  	  	  "description" = "The user ID.",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "USER_ID"
	  ],
	  "title" = "UserIdRequest",
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "description" = "Returns a user’s out of office status.",
	  "properties" = {
	  	  "active" = {
	  	  	  "description" = "The user’s out of office status as a true/false flag.",
	  	  	  "title" = "active",
	  	  	  "type" = "boolean"
	  	  }
	  },
	  "title" = "Get User Routing Status Response",
	  "type" = "object"
  })
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/users/$${input.USER_ID}/outofoffice"
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
  }
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
}

resource "genesyscloud_integration_action" "Get_On_Queue_Agent_Counts" {
  name     = "Get On Queue Agent Counts"
  category = "Genesys Cloud Public API Integration"
  config_response {
    success_template = "{\"counts\": $${counts}, \"statuses\": $${statuses}}"
    translation_map = {
      counts   = "$.results[0].data..stats.count"
      statuses = "$.results[0].data..qualifier"
    }
    translation_map_defaults = {
      counts   = "[0]"
      statuses = "[\"Error\"]"
    }
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "queueId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "queueId"
	  ],
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "counts" = {
	  	  	  "description" = "Integer array of on queue agent counts for each routing status. Wrap this variable in a sum() expression to get the total number of on queue agents.",
	  	  	  "items" = {
	  	  	  	  "type" = "integer"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "statuses" = {
	  	  	  "description" = "String array of on queue agent routing statuses for matching up to the counts array.",
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  config_request {
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template     = "{\n \"filter\": {\n  \"type\": \"or\",\n  \"predicates\": [\n   {\n    \"type\": \"dimension\",\n    \"dimension\": \"queueId\",\n    \"operator\": \"matches\",\n    \"value\": \"$${input.queueId}\"\n   }\n  ]\n },\n \"metrics\": [\n  \"oOnQueueUsers\"\n ]\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/analytics/queues/observations/query"
  }
  secure = false
}

resource "genesyscloud_integration_action" "External_Contact_Query" {
  name     = "External Contact Query"
  category = "Genesys Cloud Public API Integration"
  config_response {
    success_template = "{\"contactId\": $${successTemplateUtils.firstFromArray($${contactId})}, \"contactFirstName\": $${successTemplateUtils.firstFromArray($${contactFirstName})}, \"contactLastName\": $${successTemplateUtils.firstFromArray($${contactLastName})}, \"contactTitle\": $${successTemplateUtils.firstFromArray(\"$${contactTitle}\",\"$esc.quote$esc.quote\")}, \"contactPostCode\": $${successTemplateUtils.firstFromArray(\"$${contactPostCode}\",\"$esc.quote$esc.quote\")}, \"contactOrgName\": $${successTemplateUtils.firstFromArray(\"$${contactOrgName}\",\"$esc.quote$esc.quote\")}, \"contactOrgType\": $${successTemplateUtils.firstFromArray(\"$${contactOrgType}\",\"$esc.quote$esc.quote\")}, \"contactWorkPhone\": $${successTemplateUtils.firstFromArray(\"$${contactWorkPhone}\",\"$esc.quote$esc.quote\")}, \"contactCellPhone\": $${successTemplateUtils.firstFromArray(\"$${contactCellPhone}\",\"$esc.quote$esc.quote\")}, \"contactHomePhone\": $${successTemplateUtils.firstFromArray(\"$${contactHomePhone}\",\"$esc.quote$esc.quote\")}, \"contactAddress1\": $${successTemplateUtils.firstFromArray(\"$${contactAddress1}\",\"$esc.quote$esc.quote\")}, \"contactCity\": $${successTemplateUtils.firstFromArray(\"$${contactCity}\",\"$esc.quote$esc.quote\")}, \"contactState\": $${successTemplateUtils.firstFromArray(\"$${contactState}\",\"$esc.quote$esc.quote\")}, \"contactCountryCode\": $${successTemplateUtils.firstFromArray(\"$${contactCountryCode}\",\"$esc.quote$esc.quote\")}}"
    translation_map = {
      contactAddress1    = "$.entities[?(@.id != '')].address.address1"
      contactCellPhone   = "$.entities[?(@.id != '')].cellPhone.e164"
      contactCity        = "$.entities[?(@.id != '')].address.city"
      contactCountryCode = "$.entities[?(@.id != '')].address.countryCode"
      contactFirstName   = "$.entities[?(@.id != '')].firstName"
      contactHomePhone   = "$.entities[?(@.id != '')].homePhone.e164"
      contactId          = "$.entities[?(@.id != '')].id"
      contactLastName    = "$.entities[?(@.id != '')].lastName"
      contactOrgName     = "$.entities[?(@.id != '')].externalOrganization.name"
      contactOrgType     = "$.entities[?(@.id != '')].externalorganization.companyType"
      contactPostCode    = "$.entities[?(@.id != '')].address.postalCode"
      contactState       = "$.entities[?(@.id != '')].address.state"
      contactTitle       = "$.entities[?(@.id != '')].title"
      contactWorkPhone   = "$.entities[?(@.id != '')].workPhone.e164"
    }
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "properties" = {
	  	  "searchAttribute" = {
	  	  	  "description" = "Enter specific string to search for E.g. 'Postcode 2060'",
	  	  	  "title" = "Search Attribute",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "searchAttribute"
	  ],
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "properties" = {
	  	  "contactAddress1" = {
	  	  	  "description" = "",
	  	  	  "title" = "Address Line 1",
	  	  	  "type" = "string"
	  	  },
	  	  "contactCellPhone" = {
	  	  	  "description" = "",
	  	  	  "title" = "Cell Phone",
	  	  	  "type" = "string"
	  	  },
	  	  "contactCity" = {
	  	  	  "description" = "",
	  	  	  "title" = "City",
	  	  	  "type" = "string"
	  	  },
	  	  "contactCountryCode" = {
	  	  	  "description" = "",
	  	  	  "title" = "Country Code",
	  	  	  "type" = "string"
	  	  },
	  	  "contactFirstName" = {
	  	  	  "description" = "",
	  	  	  "title" = "First Name",
	  	  	  "type" = "string"
	  	  },
	  	  "contactHomePhone" = {
	  	  	  "description" = "",
	  	  	  "title" = "Home Phone",
	  	  	  "type" = "string"
	  	  },
	  	  "contactId" = {
	  	  	  "description" = "",
	  	  	  "title" = "Id",
	  	  	  "type" = "string"
	  	  },
	  	  "contactLastName" = {
	  	  	  "description" = "",
	  	  	  "title" = "Last Name",
	  	  	  "type" = "string"
	  	  },
	  	  "contactOrgName" = {
	  	  	  "description" = "",
	  	  	  "title" = "Organization",
	  	  	  "type" = "string"
	  	  },
	  	  "contactOrgType" = {
	  	  	  "description" = "",
	  	  	  "title" = "Organization Type",
	  	  	  "type" = "string"
	  	  },
	  	  "contactOtherEmail" = {
	  	  	  "description" = "",
	  	  	  "title" = "Other Email",
	  	  	  "type" = "string"
	  	  },
	  	  "contactPersonalEmail" = {
	  	  	  "description" = "",
	  	  	  "title" = "Personal Email",
	  	  	  "type" = "string"
	  	  },
	  	  "contactPostalCode" = {
	  	  	  "description" = "",
	  	  	  "title" = "Postal Code",
	  	  	  "type" = "string"
	  	  },
	  	  "contactState" = {
	  	  	  "description" = "",
	  	  	  "title" = "State",
	  	  	  "type" = "string"
	  	  },
	  	  "contactTitle" = {
	  	  	  "description" = "",
	  	  	  "title" = "Title",
	  	  	  "type" = "string"
	  	  },
	  	  "contactWorkEmail" = {
	  	  	  "description" = "",
	  	  	  "title" = "Work Email",
	  	  	  "type" = "string"
	  	  },
	  	  "contactWorkPhone" = {
	  	  	  "description" = "",
	  	  	  "title" = "Work Phone",
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  config_request {
    request_type         = "GET"
    request_url_template = "/api/v2/externalcontacts/contacts?q=$esc.url($${input.searchAttribute})&expand=externalOrganization"
    headers = {
      Content-Type = "application/json"
    }
    request_template = "$${input.rawRequest}"
  }
  secure = false
}

resource "genesyscloud_integration_action" "Get_Estimated_Wait_Time_by_Conversation_ID" {
  config_response {
    success_template = "{\n   \"estimated_wait_time\": $${estimated_wait_time}\n}"
    translation_map = {
      estimated_wait_time = "$.results[0].estimatedWaitTimeSeconds"
    }
    translation_map_defaults = {
      estimated_wait_time = "0"
    }
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "The estimated wait time for a specific media type and queue.",
	  "properties" = {
	  	  "Conversation_ID" = {
	  	  	  "description" = "Conversation id of the Interaction in queue.",
	  	  	  "type" = "string"
	  	  },
	  	  "QUEUE_ID" = {
	  	  	  "description" = "The queue ID.",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "QUEUE_ID"
	  ],
	  "title" = "Estimated Wait Time Request",
	  "type" = "object"
  })
  name            = "Get Estimated Wait Time by Conversation ID"
  secure          = false
  category        = "Genesys Cloud Public API Integration"
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "Returns the estimated wait time.",
	  "properties" = {
	  	  "estimated_wait_time" = {
	  	  	  "description" = "The estimated wait time (in seconds) for the specified media type and queue. ",
	  	  	  "type" = "integer"
	  	  }
	  },
	  "title" = "Get Estimated Wait Time Response",
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  config_request {
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/routing/queues/$${input.QUEUE_ID}/estimatedwaittime?conversationId=$${input.Conversation_ID}"
  }
}

resource "genesyscloud_integration_action" "Get_Number_of_Completed_Callbacks" {
  category = "Genesys Cloud Public API Integration"
  config_request {
    request_url_template = "/api/v2/analytics/conversations/details/query"
    headers = {
      Content-Type = "application/json"
    }
    request_template = "{\n \"interval\": \"$${input.INTERVAL_Start}/$${input.INTERVAL_End}\",\n \"order\": \"asc\",\n \"orderBy\": \"conversationStart\",\n \"paging\": {\n  \"pageSize\": 25,\n  \"pageNumber\": 1\n },\n \"segmentFilters\": [\n  {\n   \"type\": \"and\",\n   \"predicates\": [\n    {\n     \"type\": \"dimension\",\n     \"dimension\": \"mediaType\",\n     \"operator\": \"matches\",\n     \"value\": \"callback\"\n    },\n    {\n     \"type\": \"dimension\",\n     \"dimension\": \"queueId\",\n     \"operator\": \"matches\",\n     \"value\": \"$${input.QUEUE_ID}\"\n    }\n   ]\n  }\n ],\n \"conversationFilters\": [\n  {\n   \"type\": \"and\",\n   \"predicates\": [\n    {\n     \"type\": \"dimension\",\n     \"dimension\": \"conversationEnd\",\n     \"operator\": \"exists\",\n     \"value\": null\n    }\n   ]\n  }\n ]\n}"
    request_type     = "POST"
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "INTERVAL_End" = {
	  	  	  "description" = "ToString(GetCurrentDateTimeUtc())",
	  	  	  "type" = "string"
	  	  },
	  	  "INTERVAL_Start" = {
	  	  	  "description" = "ToString(AddHours(GetCurrentDateTimeUtc(),-24))",
	  	  	  "type" = "string"
	  	  },
	  	  "QUEUE_ID" = {
	  	  	  "description" = "Call.CurrentQueue",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "INTERVAL_Start",
	  	  "INTERVAL_End",
	  	  "QUEUE_ID"
	  ],
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "totalHits" = {
	  	  	  "type" = "integer"
	  	  }
	  },
	  "type" = "object"
  })
  secure          = false
  config_response {
    success_template = "$${rawResult}"
  }
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name           = "Get Number of Completed Callbacks"
}

resource "genesyscloud_integration_action" "Get_Caller_Email" {
  name           = "Get Caller Email"
  secure         = false
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  config_response {
    success_template = "{\"emailAddress\": $${successTemplateUtils.firstFromArray($${emailAddress}, \"$esc.quote$esc.quote\")}}"
    translation_map = {
      emailAddress = "$..EmailAddress"
    }
    translation_map_defaults = {
      emailAddress = "[ \"\" ]"
    }
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = false,
	  "properties" = {
	  	  "emailAddress" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  category        = "Genesys Cloud Public API Integration"
  config_request {
    headers = {
      Content-Type = "application/json"
    }
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/conversations/$${input.conversationId}"
  }
}

resource "genesyscloud_integration_action" "Set_User_Skills" {
  config_request {
    request_template     = "[\n#if(\"$!{input.skillId1}\" != \"\")\n  {\n    \"id\": \"$!{input.skillId1}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId2}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId2}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId3}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId3}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId4}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId4}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId5}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId5}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId6}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId6}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId7}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId7}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId8}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId8}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId9}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId9}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId10}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId10}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId11}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId11}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId12}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId12}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId13}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId13}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId14}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId14}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId15}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId15}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId16}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId16}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId17}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId17}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId18}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId18}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId19}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId19}\",\n    \"proficiency\": 0\n  }\n#end\n#if(\"$!{input.skillId20}\" != \"\")\n  ,{\n    \"id\": \"$!{input.skillId20}\",\n    \"proficiency\": 0\n  }\n#end\n]"
    request_type         = "PUT"
    request_url_template = "/api/v2/users/$${input.userId}/routingskills/bulk"
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "skillId1" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId10" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId11" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId12" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId13" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId14" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId15" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId16" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId17" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId18" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId19" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId2" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId20" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId3" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId4" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId5" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId6" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId7" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId8" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId9" = {
	  	  	  "type" = "string"
	  	  },
	  	  "userId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {},
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name            = "Set User Skills"
  category        = "Genesys Cloud Public API Integration"
  config_response {
    success_template = "$${rawResult}"
  }
  secure = false
}

resource "genesyscloud_integration_action" "Get_Active_Users" {
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/users?state=active&pageSize=100&pageNumber=$${input.pageNumber}"
  }
  config_response {
    success_template = "{ \"userIds\": $${ids}, \"userEmails\": $${emails}, \"userNames\": $${names},\"pageCount\": $${pageCount},\"divisionIds\": $${divIds} }"
    translation_map = {
      divIds    = "$.entities[*].division.id"
      emails    = "$.entities[*].email"
      ids       = "$.entities[*].id"
      names     = "$.entities[*].name"
      pageCount = "$.pageCount"
    }
    translation_map_defaults = {
      divIds    = "[]"
      emails    = "[]"
      ids       = "[]"
      names     = "[]"
      pageCount = "0"
    }
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "pageNumber" = {
	  	  	  "default" = "1",
	  	  	  "type" = "integer"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "divisionIds" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "pageCount" = {
	  	  	  "type" = "integer"
	  	  },
	  	  "userEmails" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "userIds" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "userNames" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "type" = "object"
  })
  name            = "Get Active Users"
  secure          = false
  category        = "Genesys Cloud Public API Integration"
}

resource "genesyscloud_integration_action" "Create_Placeholder_Callback" {
  name     = "Create Placeholder Callback"
  category = "Accelerator - Automated Callbacks"
  config_request {
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template     = "{\"queueId\": \"$${input.queueId}\", \"callbackNumbers\": [$${input.callbackNumber}] }"
    request_type         = "POST"
    request_url_template = "/api/v2/conversations/callbacks"
  }
  config_response {
    success_template = "$${rawResult}"
  }
  contract_input  = jsonencode({
	  "properties" = {
	  	  "callbackNumber" = {
	  	  	  "type" = "number"
	  	  },
	  	  "queueId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "queueId",
	  	  "callbackNumber"
	  ],
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Accelerator_-_Automated_Callbacks.id}"
  contract_output = jsonencode({
	  "properties" = {
	  	  "conversation" = {
	  	  	  "properties" = {
	  	  	  	  "id" = {
	  	  	  	  	  "type" = "string"
	  	  	  	  }
	  	  	  },
	  	  	  "type" = "object"
	  	  }
	  },
	  "type" = "object"
  })
  secure          = false
}

resource "genesyscloud_integration_action" "Associate_External_Contact" {
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "communicationId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "externalContactId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "mediaType" = {
	  	  	  "description" = "Valid values: CALL, CALLBACK, CHAT, COBROWSE, EMAIL, MESSAGE, SOCIAL_EXPRESSION, VIDEO, SCREENSHARE",
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {},
	  "type" = "object"
  })
  name            = "Associate External Contact"
  category        = "Genesys Cloud Public API Integration"
  config_response {
    success_template = "$${rawResult}"
  }
  secure = false
  config_request {
    request_type         = "PUT"
    request_url_template = "/api/v2/externalcontacts/conversations/$${input.conversationId}"
    request_template     = "$${input.rawRequest}"
  }
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
}

resource "genesyscloud_integration_action" "Get_Call_Offered_Count" {
  config_response {
    translation_map_defaults = {
      count = "[0].[0]"
    }
    success_template = "{\r\n\"count\": $${successTemplateUtils.firstFromArray(\"$${count}\")}\r\n}"
    translation_map = {
      count = "$.results[?(@.group.mediaType=='voice')].data[0].metrics[?(@.metric=='nOffered')].stats.count"
    }
  }
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "count" = {
	  	  	  "type" = "number"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  config_request {
    request_template     = "{\n  \"interval\": \"$${input.Interval}\",\n  \n  \"groupBy\": [\n    \"queueId\"\n  ],\n  \"metrics\": [\n    \"nOffered\"\n  ],\n  \"filter\": {\n    \"type\": \"and\",\n    \"predicates\": [\n      {\n        \"dimension\": \"queueId\",\n        \"value\": \"$${input.QueueID}\"\n      },\n      {\n        \"dimension\": \"mediaType\",\n        \"value\": \"voice\"\n      }\n    ]\n  }\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/analytics/conversations/aggregates/query"
  }
  contract_input = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "Interval" = {
	  	  	  "type" = "string"
	  	  },
	  	  "QueueID" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  name           = "Get Call Offered Count"
  secure         = false
  category       = "Genesys Cloud Public API Integration"
}

resource "genesyscloud_integration_action" "Replace_Participant_with_ANI_-_Aug-15-24" {
  contract_input  = jsonencode({
	  "properties" = {
	  	  "address" = {
	  	  	  "type" = "string"
	  	  },
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "participantId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "conversationId",
	  	  "participantId",
	  	  "address"
	  ],
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "properties" = {},
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Orbit_Data_Actions_OAuth_Integration_2604983327_3497928598.id}"
  secure          = false
  category        = "Orbit Data Actions OAuth Integration"
  config_request {
    request_template     = "{\n  \"address\": \"$${input.address}\",\n\"transferType\": \"Attended\"\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/conversations/$${input.conversationId}/participants/$${input.participantId}/replace"
    headers = {
      Content-Type = "application/json"
    }
  }
  config_response {
    success_template = "$${rawResult}"
  }
  name = "Replace Participant with ANI - Aug-15-24"
}

resource "genesyscloud_integration_action" "Create_Email_Conversation" {
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "attribute1Name" = {
	  	  	  "type" = "string"
	  	  },
	  	  "attribute1Value" = {
	  	  	  "type" = "string"
	  	  },
	  	  "attribute2Name" = {
	  	  	  "type" = "string"
	  	  },
	  	  "attribute2Value" = {
	  	  	  "type" = "string"
	  	  },
	  	  "attribute3Name" = {
	  	  	  "type" = "string"
	  	  },
	  	  "attribute3Value" = {
	  	  	  "type" = "string"
	  	  },
	  	  "attribute4Name" = {
	  	  	  "type" = "string"
	  	  },
	  	  "attribute4Value" = {
	  	  	  "type" = "string"
	  	  },
	  	  "attribute5Name" = {
	  	  	  "type" = "string"
	  	  },
	  	  "attribute5Value" = {
	  	  	  "type" = "string"
	  	  },
	  	  "flowId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "fromAddress" = {
	  	  	  "type" = "string"
	  	  },
	  	  "fromName" = {
	  	  	  "type" = "string"
	  	  },
	  	  "provider" = {
	  	  	  "type" = "string"
	  	  },
	  	  "subject" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "flowId",
	  	  "provider"
	  ],
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "id" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  config_response {
    success_template = "$${rawResult}"
  }
  name     = "Create Email Conversation"
  secure   = false
  category = "Genesys Cloud Public API Integration"
  config_request {
    request_template     = "{\n\"flowId\": \"$${input.flowId}\",\n\"provider\": \"$${input.provider}\",\n\"subject\": \"$!{input.subject}\",\n\"fromName\": \"$!{input.fromName}\",\n\"fromAddress\": \"$!{input.fromAddress}\",\n\"attributes\": {\n\"$!{input.attribute1Name}\": \"$!{input.attribute1Value}\",\n\"$!{input.attribute2Name}\": \"$!{input.attribute2Value}\",\n\"$!{input.attribute3Name}\": \"$!{input.attribute3Value}\",\n\"$!{input.attribute4Name}\": \"$!{input.attribute4Value}\",\n\"$!{input.attribute5Name}\": \"$!{input.attribute5Value}\"\n}\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/conversations/emails"
  }
}

resource "genesyscloud_integration_action" "Get_Waiting_Calls_on_Specific_Queue_Base_on_External_Tag_Aug-15-24" {
  name            = "Get Waiting Calls on Specific Queue Base on External Tag Aug-15-24"
  category        = "Orbit Data Actions OAuth Integration"
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "conversationID" = {
	  	  	  "items" = {
	  	  	  	  "title" = "ID",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "participantID" = {
	  	  	  "items" = {
	  	  	  	  "title" = "ID",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "type" = "object"
  })
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "endDate" = {
	  	  	  "type" = "string"
	  	  },
	  	  "externalTag" = {
	  	  	  "type" = "string"
	  	  },
	  	  "holdingQueueId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "startDate" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Orbit_Data_Actions_OAuth_Integration_2604983327_3802782832.id}"
  secure          = false
  config_request {
    request_template     = "{\n \"interval\": \"$${input.startDate}/$${input.endDate}\",\n \"order\": \"asc\",\n \"orderBy\": \"conversationStart\",\n \"paging\": {\n  \"pageSize\": 25,\n  \"pageNumber\": 1\n },\n \"segmentFilters\": [\n  {\n   \"type\": \"and\",\n   \"clauses\": [\n    {\n     \"type\": \"and\",\n     \"predicates\": [\n      {\n       \"type\": \"dimension\",\n       \"dimension\": \"disconnectType\",\n       \"operator\": \"notExists\",\n       \"value\": null\n      }\n     ]\n    }\n   ],\n   \"predicates\": [\n    {\n     \"type\": \"dimension\",\n     \"dimension\": \"queueId\",\n     \"operator\": \"matches\",\n     \"value\": \"$${input.holdingQueueId}\"\n    },\n    {\n     \"type\": \"dimension\",\n     \"dimension\": \"segmentType\",\n     \"operator\": \"matches\",\n     \"value\": \"interact\"\n    }\n   ]\n  }\n ],\n \"conversationFilters\": [\n  {\n   \"type\": \"and\",\n   \"predicates\": [\n    {\n     \"type\": \"dimension\",\n     \"dimension\": \"externalTag\",\n     \"operator\": \"matches\",\n     \"value\": \"$${input.externalTag}\"\n    }\n   ]\n  }\n ]\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/analytics/conversations/details/query"
  }
  config_response {
    success_template = "{\"conversationID\":$${conversationID},\"participantID\":$${participantID}}"
    translation_map = {
      conversationID = "$..conversationId"
      participantID  = "$..participants[?(@.purpose == 'acd' && @.sessions[0].flowInType == 'agent')].participantId"
    }
  }
}

resource "genesyscloud_integration_action" "Create_Callback_Extended_with_Data" {
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name           = "Create Callback Extended with Data"
  secure         = false
  config_request {
    request_type         = "POST"
    request_url_template = "/api/v2/conversations/callbacks"
    request_template     = "{\n  \"callbackNumbers\": [ \"$${input.callbackNumber}\" ],\n#if(\"$!{input.scriptId}\" != \"\")\n  \"scriptId\": \"$!{input.scriptId}\",\n#end\n#if(\"$!{input.callbackUserName}\" != \"\")\n  \"callbackUserName\": \"$!{input.callbackUserName}\",\n#end\n#if(\"$!{input.callbackScheduledTime}\" != \"\")\n  \"callbackScheduledTime\": \"$!{input.callbackScheduledTime}\",\n#end\n  \"routingData\": {\n    \"queueId\": \"$${input.queueId}\"\n#if(\"$!{input.languageId}\" != \"\")\n    ,\"languageId\": \"$!{input.languageId}\"\n#end\n#if(\"$!{input.priority}\" != \"\")\n    ,\"priority\": $!{input.priority}\n#end\n#if(\"$!{input.preferredAgentId}\" != \"\")\n    ,\"scoredAgents\": [ { \"agent\": { \"id\": \"$!{input.preferredAgentId}\" }, \"score\": 100 } ]\n#end\n#if(\"$!{input.skillId}\" != \"\")\n    ,\"skillIds\": [ \"$!{input.skillId}\" ]\n#end\n  },\n\"data\": {\n  \"Phone Number\": \"$${input.participantdataphonenumber}\",\n  \"Name\": \"$${input.participantdataname}\",\n  \"Area Of Interest\": \"$${input.participantdataareaofinterest}\",\n  \"CS Agent Name\": \"$${input.participantdatacsagentname}\",\n  \"Date/Time\": \"$${input.participantdatacallbacktime}\"\n}\n}"
  }
  config_response {
    success_template = "{ \"conversationId\": $${id} }"
    translation_map = {
      id = "$.conversation.id"
    }
    translation_map_defaults = {
      id = "\"\""
    }
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "callbackNumber" = {
	  	  	  "type" = "string"
	  	  },
	  	  "callbackScheduledTime" = {
	  	  	  "type" = "string"
	  	  },
	  	  "callbackUserName" = {
	  	  	  "type" = "string"
	  	  },
	  	  "languageId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "participantdataareaofinterest" = {
	  	  	  "type" = "string"
	  	  },
	  	  "participantdatacallbacktime" = {
	  	  	  "type" = "string"
	  	  },
	  	  "participantdatacsagentname" = {
	  	  	  "type" = "string"
	  	  },
	  	  "participantdataname" = {
	  	  	  "type" = "string"
	  	  },
	  	  "participantdataphonenumber" = {
	  	  	  "type" = "string"
	  	  },
	  	  "preferredAgentId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "priority" = {
	  	  	  "type" = "string"
	  	  },
	  	  "queueId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "scriptId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "callbackNumber",
	  	  "queueId"
	  ],
	  "type" = "object"
  })
  category        = "Genesys Cloud Public API Integration"
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
}

resource "genesyscloud_integration_action" "Get_Service_Level" {
  category = "Genesys Cloud Public API Integration"
  config_request {
    headers = {
      Content-Type = "application/json"
    }
    request_template     = "{\"groupBy\":[\"queueId\"], \"interval\":\"$${input.interval}\", \"filter\": {\"type\":\"and\",\"predicates\": [{\"dimension\": \"queueId\",\"value\": \"$${input.queueId}\"}, {\"dimension\": \"mediaType\",\"value\": \"$${input.mediaType}\"}]}, \"metrics\": [\"oServiceLevel\"]}"
    request_type         = "POST"
    request_url_template = "/api/v2/analytics/conversations/aggregates/query"
  }
  config_response {
    success_template = "$${stats}"
    translation_map = {
      stats = "$.results[0].data[0].metrics[0].stats"
    }
    translation_map_defaults = {
      stats = "{}"
    }
  }
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name            = "Get Service Level"
  secure          = false
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "Service level for a specific queue.",
	  "properties" = {
	  	  "interval" = {
	  	  	  "description" = "Interval",
	  	  	  "type" = "string"
	  	  },
	  	  "mediaType" = {
	  	  	  "description" = "Valid values: callback, chat, cobrowse, email, message, screenshare, voice",
	  	  	  "enum" = [
	  	  	  	  "callback",
	  	  	  	  "chat",
	  	  	  	  "cobrowse",
	  	  	  	  "email",
	  	  	  	  "message",
	  	  	  	  "screenshare",
	  	  	  	  "voice"
	  	  	  ],
	  	  	  "type" = "string"
	  	  },
	  	  "queueId" = {
	  	  	  "description" = "The queue ID.",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "interval",
	  	  "queueId",
	  	  "mediaType"
	  ],
	  "title" = "Get Service Level",
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "denominator" = {
	  	  	  "type" = "number"
	  	  },
	  	  "numerator" = {
	  	  	  "type" = "number"
	  	  },
	  	  "ratio" = {
	  	  	  "type" = "number"
	  	  },
	  	  "target" = {
	  	  	  "type" = "number"
	  	  }
	  },
	  "type" = "object"
  })
}

resource "genesyscloud_integration_action" "Get_Campaign_Division_642897808_1149737413" {
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/outbound/campaigns/$${input.campaignId}"
  }
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name           = "Get Campaign Division"
  secure         = false
  category       = "Genesys Cloud Public API Integration"
  config_response {
    success_template = "{ \"queueId\": $${queueId}, \"queueName\": $${queueName} }"
    translation_map = {
      queueId   = "$.queue.id"
      queueName = "$.queue.name"
    }
    translation_map_defaults = {
      queueId   = "\"\""
      queueName = "\"\""
    }
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "campaignId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "queueId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "queueName" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
}

resource "genesyscloud_integration_action" "DR_Create_Callback_" {
  secure   = false
  category = "DR Callbacks"
  config_request {
    request_template     = "{\n\"callbackUserName\":\"$${input.callbackUserName}\",\n\"callerIdName\":\"$${input.callerIdName}\",\n\"callbackNumbers\": [ \"$${input.phone}\" ],\n\"data\":{\"message\":\"$${input.message}\"},\n\"routingData\": {\n\"queueId\": \"$${input.queueId}\"\n}\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/conversations/callbacks"
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "callbackUserName" = {
	  	  	  "type" = "string"
	  	  },
	  	  "callerIdName" = {
	  	  	  "type" = "string"
	  	  },
	  	  "callerName" = {
	  	  	  "type" = "string"
	  	  },
	  	  "message" = {
	  	  	  "type" = "string"
	  	  },
	  	  "phone" = {
	  	  	  "type" = "string"
	  	  },
	  	  "queueId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {},
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.GC_Data_Actions_Public_API.id}"
  config_response {
    success_template = "$${rawResult}"
  }
  name = "DR Create Callback "
}

resource "genesyscloud_integration_action" "Get_Inbound_Call_-_Check_if_Picked_Up" {
  contract_output = jsonencode({
	  "properties" = {
	  	  "segmentType" = {
	  	  	  "items" = {
	  	  	  	  "title" = "segmentType",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Accelerator_-_Update_User_On_Communicate_Call.id}"
  secure          = false
  contract_input  = jsonencode({
	  "properties" = {
	  	  "CONVERSATION_ID" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  name            = "Get Inbound Call - Check if Picked Up"
  category        = "Accelerator - Update User On Communicate Call"
  config_request {
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/analytics/conversations/$${input.CONVERSATION_ID}/details"
  }
  config_response {
    success_template = "{\"segmentType\": $${segmentType}}"
    translation_map = {
      segmentType = "['participants'][?(@.purpose=='user')]['sessions'][?(@.direction=='inbound')]['segments'][?(@.segmentType=='interact')].segmentType"
    }
  }
}

resource "genesyscloud_integration_action" "Get_Campaign_Division_642897808" {
  config_response {
    success_template = "{ \"divisionId\": $${divisionId} }"
    translation_map = {
      divisionId = "$.division.id"
    }
    translation_map_defaults = {
      divisionId = "\"\""
    }
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "campaignId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "divisionId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  secure          = false
  category        = "Genesys Cloud Public API Integration"
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/outbound/campaigns/$${input.campaignId}"
  }
  name = "Get Campaign Division"
}

resource "genesyscloud_integration_action" "Get_Agent_Wrap-Up_and_Time_from_Conversation" {
  category = "web-messaging-triage-bot-data-action"
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/conversations/$${input.CONVERSATION_ID}"
  }
  config_response {
    success_template = "{\n \"WRAP_UP_NAME\": $${successTemplateUtils.firstFromArray(\"$${WRAP_UP_NAME}\")}, \"WRAP_UP_TIME\": $${successTemplateUtils.firstFromArray(\"$${WRAP_UP_TIME}\")}\n}"
    translation_map = {
      WRAP_UP_NAME = "$.participants[?(@.purpose == 'agent')].wrapup.name"
      WRAP_UP_TIME = "$.participants[?(@.purpose == 'agent')].wrapup.endTime"
    }
  }
  name            = "Get Agent Wrap-Up and Time from Conversation"
  secure          = false
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "CONVERSATION_ID" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "WRAP_UP_NAME" = {
	  	  	  "type" = "string"
	  	  },
	  	  "WRAP_UP_TIME" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.web-messaging-triage-bot-data-action.id}"
}

resource "genesyscloud_integration_action" "Get_Queues_Handle_Rate" {
  category = "Genesys Cloud Public API Integration"
  config_request {
    request_template     = "{\n \"interval\": \"$${input.Date}T07:30:00.000Z/$${input.Date}T23:30:00.000Z\",\n \"groupBy\": [\n  \"queueId\"\n ],\n \"filter\": {\n  \"type\": \"and\",\n  \"clauses\": [\n   {\n    \"type\": \"or\",\n    \"predicates\": [\n     {\n        \"type\": \"dimension\",\n        \"dimension\": \"queueId\",\n        \"operator\": \"matches\",\n        \"value\": \"$${input.Queue1}\"\n    }\n#if(\"$!{input.Queue2}\" != \"\")\n    ,{\n        \"type\": \"dimension\",\n        \"dimension\": \"queueId\",\n        \"operator\": \"matches\",\n        \"value\": \"$!{input.Queue2}\"\n    }\n#end\n#if(\"$!{input.Queue3}\" != \"\")\n    ,{\n        \"type\": \"dimension\",\n        \"dimension\": \"queueId\",\n        \"operator\": \"matches\",\n        \"value\": \"$!{input.Queue3}\"\n    }\n#end\n#if(\"$!{input.Queue4}\" != \"\")\n    ,{\n        \"type\": \"dimension\",\n        \"dimension\": \"queueId\",\n        \"operator\": \"matches\",\n        \"value\": \"$!{input.Queue4}\"\n    }\n#end\n    ]\n   }\n  ],\n  \"predicates\": [\n   {\n    \"type\": \"dimension\",\n    \"dimension\": \"mediaType\",\n    \"operator\": \"matches\",\n    \"value\": \"voice\"\n   }\n  ]\n },\n \"views\": [],\n \"metrics\": [\n  \"nOffered\",\n  \"tAbandon\"\n ]\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/analytics/conversations/aggregates/query"
  }
  config_response {
    success_template = "{\"queue1\": $${queue1}, \"queue2\": $${queue2}, \"queue3\": $${queue3}, \"queue4\": $${queue4}, \"nOffered1\": $${nOffered1}, \"nOffered2\": $${nOffered2}, \"nOffered3\": $${nOffered3}, \"nOffered4\": $${nOffered4}, \"tAbandon1\": $${tAbandon1}, \"tAbandon2\": $${tAbandon2}, \"tAbandon3\": $${tAbandon3}, \"tAbandon4\": $${tAbandon4}}"
    translation_map = {
      nOffered1 = "$.results[0].data[0].metrics[0].stats.count"
      nOffered2 = "$.results[1].data[0].metrics[0].stats.count"
      nOffered3 = "$.results[2].data[0].metrics[0].stats.count"
      nOffered4 = "$.results[3].data[0].metrics[0].stats.count"
      queue1    = "$.results[0].group.queueId"
      queue2    = "$.results[1].group.queueId"
      queue3    = "$.results[2].group.queueId"
      queue4    = "$.results[3].group.queueId"
      tAbandon1 = "$.results[0].data[0].metrics[1].stats.count"
      tAbandon2 = "$.results[1].data[0].metrics[1].stats.count"
      tAbandon3 = "$.results[2].data[0].metrics[1].stats.count"
      tAbandon4 = "$.results[3].data[0].metrics[1].stats.count"
    }
    translation_map_defaults = {
      nOffered1 = "0"
      nOffered2 = "0"
      nOffered3 = "0"
      nOffered4 = "0"
      queue1    = "\"Error\""
      queue2    = "\"Error\""
      queue3    = "\"Error\""
      queue4    = "\"Error\""
      tAbandon1 = "0"
      tAbandon2 = "0"
      tAbandon3 = "0"
      tAbandon4 = "0"
    }
  }
  secure          = false
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "Date" = {
	  	  	  "type" = "string"
	  	  },
	  	  "Queue1" = {
	  	  	  "type" = "string"
	  	  },
	  	  "Queue2" = {
	  	  	  "type" = "string"
	  	  },
	  	  "Queue3" = {
	  	  	  "type" = "string"
	  	  },
	  	  "Queue4" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "nOffered1" = {
	  	  	  "type" = "integer"
	  	  },
	  	  "nOffered2" = {
	  	  	  "type" = "integer"
	  	  },
	  	  "nOffered3" = {
	  	  	  "type" = "integer"
	  	  },
	  	  "nOffered4" = {
	  	  	  "type" = "integer"
	  	  },
	  	  "queue1" = {
	  	  	  "type" = "string"
	  	  },
	  	  "queue2" = {
	  	  	  "type" = "string"
	  	  },
	  	  "queue3" = {
	  	  	  "type" = "string"
	  	  },
	  	  "queue4" = {
	  	  	  "type" = "string"
	  	  },
	  	  "tAbandon1" = {
	  	  	  "type" = "integer"
	  	  },
	  	  "tAbandon2" = {
	  	  	  "type" = "integer"
	  	  },
	  	  "tAbandon3" = {
	  	  	  "type" = "integer"
	  	  },
	  	  "tAbandon4" = {
	  	  	  "type" = "integer"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name            = "Get Queues Handle Rate"
}

resource "genesyscloud_integration_action" "Get_All_Divisions" {
  secure   = false
  category = "Genesys Cloud Public API Integration"
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/authorization/divisions?pageSize=100&pageNumber=$${input.pageNumber}"
  }
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "divisionIds" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "divisionNames" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "pageCount" = {
	  	  	  "type" = "integer"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name            = "Get All Divisions"
  config_response {
    success_template = "{ \"divisionIds\": $${ids}, \"divisionNames\": $${names},\"pageCount\": $${pageCount} }"
    translation_map = {
      ids       = "$.entities[*].id"
      names     = "$.entities[*].name"
      pageCount = "$.pageCount"
    }
    translation_map_defaults = {
      ids       = "[]"
      names     = "[]"
      pageCount = "0"
    }
  }
  contract_input = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "pageNumber" = {
	  	  	  "default" = "1",
	  	  	  "type" = "integer"
	  	  }
	  },
	  "type" = "object"
  })
}

resource "genesyscloud_integration_action" "Get_Conversations_by_DNIS" {
  category = "Genesys Cloud Public API Integration"
  config_response {
    success_template = "{\"InteractionIds\": $${InteractionIds}}"
    translation_map = {
      InteractionIds = "$.conversations[*].conversationId"
    }
    translation_map_defaults = {
      InteractionIds = "[\r\n  \"\"\r\n]"
    }
  }
  contract_input = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "Check if we had interactions for a certain DNIS",
	  "properties" = {
	  	  "DNIS" = {
	  	  	  "description" = "DNIS in e.164 format",
	  	  	  "type" = "string"
	  	  },
	  	  "Date" = {
	  	  	  "description" = "Date in the format YYYY-MM-DDThh:mm:ss/YYYY-MM-DDThh:mm:ss (yesterday/today+1 for example, a query that does not exceed 31 days)",
	  	  	  "format" = "YYYY-MM-DDThh:mm:ss/YYYY-MM-DDThh:mm:ss",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "DNIS",
	  	  "Date"
	  ],
	  "title" = "Check for interactions with DNIS",
	  "type" = "object"
  })
  name           = "Get Conversations by DNIS"
  config_request {
    headers = {
      Content-Type = "application/json"
    }
    request_template     = "{\r\n \"interval\": \"$${input.Date}\",\r\n \"order\": \"asc\",\r\n \"orderBy\": \"conversationStart\",\r\n \"paging\": {\r\n  \"pageSize\": 25,\r\n  \"pageNumber\": 1\r\n },\r\n \"segmentFilters\": [\r\n  {\r\n   \"type\": \"and\",\r\n   \"predicates\": [\r\n    {\r\n     \"type\": \"dimension\",\r\n     \"dimension\": \"dnis\",\r\n     \"operator\": \"matches\",\r\n     \"value\": \"$${input.DNIS}\"\r\n    }\r\n   ]\r\n  }\r\n ]\r\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/analytics/conversations/details/query"
  }
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "Returns the Interaction IDs",
	  "properties" = {
	  	  "InteractionIds" = {
	  	  	  "description" = "The Interaction ID(s) that contain the DNIS you looked up",
	  	  	  "items" = {
	  	  	  	  "title" = "Interaction ID",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "title" = "Check for interactions with DNIS",
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  secure          = false
}

resource "genesyscloud_integration_action" "Get_Interactions_In_Queue" {
  config_request {
    headers = {
      Content-Type = "application/json"
    }
    request_template     = "{\"filter\": {\"type\":\"and\",\"predicates\": [{\"dimension\": \"queueId\",\"value\": \"$${input.QUEUE_ID}\"},{\"dimension\": \"mediaType\",\"value\": \"$${input.MEDIA_TYPE}\"}]},\"metrics\": [\"oWaiting\",\"oInteracting\"]}"
    request_type         = "POST"
    request_url_template = "/api/v2/analytics/queues/observations/query"
  }
  config_response {
    success_template = "{\"NUM_INTERACTING\": $${successTemplateUtils.firstFromArray(\"$${NumInteracting}\", \"0\")}, \"NUM_WAITING\": $${successTemplateUtils.firstFromArray(\"$${NumWaiting}\", \"0\")}}"
    translation_map = {
      NumInteracting = "$..data[?(@.metric==\"oInteracting\")].stats.count"
      NumWaiting     = "$..data[?(@.metric==\"oWaiting\")].stats.count"
    }
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "MEDIA_TYPE" = {
	  	  	  "description" = "The media type of the interaction: voice, chat, callback, email, social media, or video communication.",
	  	  	  "enum" = [
	  	  	  	  "voice",
	  	  	  	  "chat",
	  	  	  	  "callback",
	  	  	  	  "email",
	  	  	  	  "socialExpression",
	  	  	  	  "videoComm"
	  	  	  ],
	  	  	  "type" = "string"
	  	  },
	  	  "QUEUE_ID" = {
	  	  	  "description" = "The queue ID.",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "QUEUE_ID",
	  	  "MEDIA_TYPE"
	  ],
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "NUM_INTERACTING" = {
	  	  	  "description" = "Interactions in the queue assigned to agents",
	  	  	  "type" = "number"
	  	  },
	  	  "NUM_WAITING" = {
	  	  	  "description" = "Interactions in the queue waiting",
	  	  	  "type" = "number"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name            = "Get Interactions In Queue"
  category        = "Genesys Cloud Public API Integration"
  secure          = false
}

resource "genesyscloud_integration_action" "Get_Org_Roles" {
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "pageCount" = {
	  	  	  "type" = "integer"
	  	  },
	  	  "roleIds" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "roleNames" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name            = "Get Org Roles"
  category        = "Genesys Cloud Public API Integration"
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/authorization/roles?pageSize=100&pageNumber=$${input.pageNumber}"
  }
  contract_input = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "pageNumber" = {
	  	  	  "default" = "1",
	  	  	  "type" = "integer"
	  	  }
	  },
	  "type" = "object"
  })
  config_response {
    success_template = "{ \"roleIds\": $${ids}, \"roleNames\": $${names}, \"pageCount\": $${pageCount} }"
    translation_map = {
      ids       = "$.entities..id"
      names     = "$.entities..name"
      pageCount = "$.pageCount"
    }
    translation_map_defaults = {
      ids       = "[]"
      names     = "[]"
      pageCount = "0"
    }
  }
  secure = false
}

resource "genesyscloud_integration_action" "Get_Customer_Participant" {
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "participantId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name            = "Get Customer Participant"
  config_response {
    success_template = "{ \"participantId\": $${participantId} }"
    translation_map = {
      participantId = "$.participants[0].id"
    }
    translation_map_defaults = {
      participantId = "\"\""
    }
  }
  contract_input = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  secure         = false
  category       = "Genesys Cloud Public API Integration"
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/conversations/$${input.conversationId}"
  }
}

resource "genesyscloud_integration_action" "Add_Contact_to_Contact_List" {
  config_response {
    success_template = "$${rawResult}"
  }
  contract_output = jsonencode({
	  "properties" = {},
	  "type" = "object"
  })
  name            = "Add Contact to Contact List"
  category        = "Accelerator - Automated Callbacks"
  config_request {
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template     = "[{\"data\": { $${input.data} } }]"
    request_type         = "POST"
    request_url_template = "/api/v2/outbound/contactlists/$${input.contactListId}/contacts"
  }
  contract_input = jsonencode({
	  "properties" = {
	  	  "contactListId" = {
	  	  	  "description" = "The contact list Id",
	  	  	  "type" = "string"
	  	  },
	  	  "data" = {
	  	  	  "description" = "Key value pairs for the contact list columns in the format \"key\" = \"value\", \"key\" = \"value\"",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "contactListId",
	  	  "data"
	  ],
	  "type" = "object"
  })
  integration_id = "${genesyscloud_integration.Accelerator_-_Automated_Callbacks.id}"
  secure         = false
}

resource "genesyscloud_integration_action" "Get_Most_Recent_Open_Case_By_Contact_Id_-_Extended_v3" {
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "A contact ID-based request.",
	  "properties" = {
	  	  "CONTACT_ID" = {
	  	  	  "description" = "The contact ID used to query Salesforce.",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "CONTACT_ID"
	  ],
	  "title" = "Case Request",
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "AccountId" = {
	  	  	  "description" = "The Salesforce account ID.",
	  	  	  "type" = "string"
	  	  },
	  	  "AssetId" = {
	  	  	  "description" = "The asset ID associated with case.",
	  	  	  "type" = "string"
	  	  },
	  	  "CaseNumber" = {
	  	  	  "description" = "The case number.",
	  	  	  "type" = "string"
	  	  },
	  	  "ClosedDate" = {
	  	  	  "description" = "The close date of the case (UTC).",
	  	  	  "type" = "string"
	  	  },
	  	  "Contact" = {
	  	  	  "additionalProperties" = true,
	  	  	  "description" = "The contact information.",
	  	  	  "properties" = {
	  	  	  	  "Email" = {
	  	  	  	  	  "description" = "The email address of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  },
	  	  	  	  "Fax" = {
	  	  	  	  	  "description" = "The fax number of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  },
	  	  	  	  "FirstName" = {
	  	  	  	  	  "description" = "The first name of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  },
	  	  	  	  "Id" = {
	  	  	  	  	  "description" = "The ID of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  },
	  	  	  	  "LastName" = {
	  	  	  	  	  "description" = "The last name of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  },
	  	  	  	  "Name" = {
	  	  	  	  	  "description" = "The full name of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  },
	  	  	  	  "Phone" = {
	  	  	  	  	  "description" = "The phone number of the contact.",
	  	  	  	  	  "type" = "string"
	  	  	  	  }
	  	  	  },
	  	  	  "required" = [
	  	  	  	  "Id"
	  	  	  ],
	  	  	  "type" = "object"
	  	  },
	  	  "CreatedById" = {
	  	  	  "description" = "The ID of the creator of the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "CreatedDate" = {
	  	  	  "description" = "The date that the case was created (UTC).",
	  	  	  "type" = "string"
	  	  },
	  	  "Description" = {
	  	  	  "description" = "The description of the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "Id" = {
	  	  	  "type" = "string"
	  	  },
	  	  "IsClosed" = {
	  	  	  "description" = "The closed property of the case.",
	  	  	  "type" = "boolean"
	  	  },
	  	  "IsDeleted" = {
	  	  	  "description" = "The deleted property of the case.",
	  	  	  "type" = "boolean"
	  	  },
	  	  "IsEscalated" = {
	  	  	  "description" = "The escalated property of the case.",
	  	  	  "type" = "boolean"
	  	  },
	  	  "LastModifiedById" = {
	  	  	  "description" = "The ID of the user who last modified the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "LastModifiedDate" = {
	  	  	  "description" = "The date of the last modification (UTC).",
	  	  	  "type" = "string"
	  	  },
	  	  "Origin" = {
	  	  	  "description" = "The origination of the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "Owner" = {
	  	  	  "additionalProperties" = true,
	  	  	  "properties" = {
	  	  	  	  "Name" = {
	  	  	  	  	  "type" = "string"
	  	  	  	  }
	  	  	  },
	  	  	  "type" = "object"
	  	  },
	  	  "OwnerId" = {
	  	  	  "description" = "The ID of the case owner.",
	  	  	  "type" = "string"
	  	  },
	  	  "ParentId" = {
	  	  	  "description" = "The parent case ID, if there is a parent.",
	  	  	  "type" = "string"
	  	  },
	  	  "Priority" = {
	  	  	  "description" = "The priority property of the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "Product__c" = {
	  	  	  "type" = "string"
	  	  },
	  	  "Reason" = {
	  	  	  "description" = "The case reason.",
	  	  	  "type" = "string"
	  	  },
	  	  "Status" = {
	  	  	  "description" = "The status of the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "Subject" = {
	  	  	  "description" = "The subject of the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "SuppliedCompany" = {
	  	  	  "description" = "The company name supplied with the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "SuppliedEmail" = {
	  	  	  "description" = "The email address supplied with the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "SuppliedName" = {
	  	  	  "description" = "The name supplied with the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "SuppliedPhone" = {
	  	  	  "description" = "The phone number supplied with the case.",
	  	  	  "type" = "string"
	  	  },
	  	  "SystemModstamp" = {
	  	  	  "description" = "The system modification time stamp.",
	  	  	  "type" = "string"
	  	  },
	  	  "Type" = {
	  	  	  "description" = "The type of the case.",
	  	  	  "type" = "string"
	  	  }
	  },
	  "title" = "Case",
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.DaveG_-_Salesforce_Data_Actions_-_DG_Sandbox.id}"
  name            = "Get Most Recent Open Case By Contact Id - Extended v3"
  secure          = false
  category        = "DaveG - Salesforce Data Actions - DG Sandbox"
  config_request {
    headers = {
      UserAgent = "PureCloudIntegrations/1.0"
    }
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/services/data/v37.0/query/?q=$esc.url(\"SELECT AccountId, AssetId, CaseNumber, ClosedDate, CreatedById, CreatedDate, Description, Id, IsClosed, IsDeleted, IsEscalated, LastModifiedById, LastModifiedDate, Origin, OwnerId, Owner.Name, ParentId, Priority, Reason, Status, Subject, Product__c, SuppliedCompany, SuppliedEmail, SuppliedName, SuppliedPhone, SystemModstamp, Type, Contact.Name, Contact.FirstName, Contact.LastName, Contact.Email, Contact.Fax, Contact.Id, Contact.Phone from Case where ContactId= '$salesforce.escReserved($${input.CONTACT_ID})' AND IsClosed = false ORDER BY LastModifiedDate DESC LIMIT 1\")"
  }
  config_response {
    success_template = "$${successTemplateUtils.firstFromArray(\"$${case}\",\"{}\")}"
    translation_map = {
      case = "$.records"
    }
    translation_map_defaults = {
      case = "[]"
    }
  }
}

resource "genesyscloud_integration_action" "Get_Repeat_Caller_Count_-_Use_with_script_button_ONLY" {
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "ANI" = {
	  	  	  "type" = "string"
	  	  },
	  	  "Interval" = {
	  	  	  "description" = "UTC, example: 2020-07-10T05:00:00.000Z/2020-07-11T05:00:00.000Z",
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "Count" = {
	  	  	  "type" = "integer"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name            = "Get Repeat Caller Count - Use with script button ONLY"
  category        = "Genesys Cloud Public API Integration"
  config_request {
    request_template     = "{\n \"interval\": \"$${input.Interval}\",\n \"order\": \"asc\",\n \"orderBy\": \"conversationStart\",\n \"paging\": {\n  \"pageSize\": 25,\n  \"pageNumber\": 1\n },\n \"segmentFilters\": [\n  {\n   \"type\": \"and\",\n   \"predicates\": [\n    {\n     \"type\": \"dimension\",\n     \"dimension\": \"ani\",\n     \"operator\": \"matches\",\n     \"value\": \"$${input.ANI}\"\n    }\n   ]\n  }\n ],\n \"conversationFilters\": [\n  {\n   \"type\": \"and\",\n   \"predicates\": [\n    {\n     \"type\": \"dimension\",\n     \"dimension\": \"conversationEnd\",\n     \"operator\": \"exists\",\n     \"value\": null\n    }\n   ]\n  }\n ]\n}"
    request_type         = "POST"
    request_url_template = "/api/v2/analytics/conversations/details/query"
  }
  config_response {
    success_template = "{ \"Count\": $${count} }"
    translation_map = {
      count = "$.conversations.size()"
    }
    translation_map_defaults = {
      count = "0"
    }
  }
  secure = false
}

resource "genesyscloud_integration_action" "Create_Callback_Extended" {
  config_request {
    request_url_template = "/api/v2/conversations/callbacks"
    request_template     = "{\n  \"callbackNumbers\": [ \"$${input.callbackNumber}\" ],\n#if(\"$!{input.scriptId}\" != \"\")\n  \"scriptId\": \"$!{input.scriptId}\",\n#end\n#if(\"$!{input.callbackUserName}\" != \"\")\n  \"callbackUserName\": \"$!{input.callbackUserName}\",\n#end\n#if(\"$!{input.callbackScheduledTime}\" != \"\")\n  \"callbackScheduledTime\": \"$!{input.callbackScheduledTime}\",\n#end\n  \"routingData\": {\n    \"queueId\": \"$${input.queueId}\"\n#if(\"$!{input.languageId}\" != \"\")\n    ,\"languageId\": \"$!{input.languageId}\"\n#end\n#if(\"$!{input.priority}\" != \"\")\n    ,\"priority\": $!{input.priority}\n#end\n#if(\"$!{input.preferredAgentId}\" != \"\")\n    ,\"scoredAgents\": [ { \"agent\": { \"id\": \"$!{input.preferredAgentId}\" }, \"score\": 100 } ]\n#end\n#if(\"$!{input.skillId}\" != \"\")\n    ,\"skillIds\": [ \"$!{input.skillId}\" ]\n#end\n  }\n}"
    request_type         = "POST"
  }
  config_response {
    success_template = "{ \"conversationId\": $${id} }"
    translation_map = {
      id = "$.conversation.id"
    }
    translation_map_defaults = {
      id = "\"\""
    }
  }
  category        = "Genesys Cloud Public API Integration"
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "callbackNumber" = {
	  	  	  "type" = "string"
	  	  },
	  	  "callbackScheduledTime" = {
	  	  	  "type" = "string"
	  	  },
	  	  "callbackUserName" = {
	  	  	  "type" = "string"
	  	  },
	  	  "languageId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "preferredAgentId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "priority" = {
	  	  	  "type" = "string"
	  	  },
	  	  "queueId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "scriptId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "skillId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "callbackNumber",
	  	  "queueId"
	  ],
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name            = "Create Callback Extended"
  secure          = false
}

resource "genesyscloud_integration_action" "Get_User_Presence__Custom_" {
  contract_input = jsonencode({
	  "properties" = {
	  	  "USER_ID" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  name           = "Get User Presence (Custom)"
  secure         = false
  category       = "Accelerator - Update User On Communicate Call"
  config_request {
    request_type         = "GET"
    request_url_template = "/api/v2/users/$${input.USER_ID}/presences/purecloud"
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template = "$${input.rawRequest}"
  }
  contract_output = jsonencode({
	  "properties" = {
	  	  "systemPresence" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Accelerator_-_Update_User_On_Communicate_Call.id}"
  config_response {
    success_template = "{\"systemPresence\": $${systemPresence}}"
    translation_map = {
      systemPresence = "$.['presenceDefinition'].systemPresence"
    }
    translation_map_defaults = {
      systemPresence = "Not Found"
    }
  }
}

resource "genesyscloud_integration_action" "Update_External_Tag_on_Conversation_1229772771" {
  contract_output = jsonencode({
	  "properties" = {},
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Orbit_Data_Actions_OAuth_Integration_2604983327_3802782832.id}"
  secure          = false
  config_response {
    success_template = "$${rawResult}"
  }
  contract_input = jsonencode({
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "externalTag" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  name           = "Update External Tag on Conversation"
  category       = "Orbit Data Actions OAuth Integration"
  config_request {
    headers = {
      Cache-Control = "no-cache"
      Content-Type  = "application/json"
      UserAgent     = "PureCloudIntegrations/1.0"
    }
    request_template     = "{\n  \"externalTag\": \"$${input.externalTag}\"\n}"
    request_type         = "PUT"
    request_url_template = "/api/v2/conversations/$${input.conversationId}/tags"
  }
}

resource "genesyscloud_integration_action" "Set_Participant_Attribute" {
  name            = "Set Participant Attribute"
  secure          = false
  category        = "Genesys Cloud Public API Integration"
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "key" = {
	  	  	  "type" = "string"
	  	  },
	  	  "participantId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "value" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {},
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  config_request {
    request_template     = "{\n\"attributes\": { \"$${input.key}\": \"$!{input.value}\" }\n}"
    request_type         = "PATCH"
    request_url_template = "/api/v2/conversations/$${input.conversationId}/participants/$${input.participantId}/attributes"
  }
  config_response {
    success_template = "$${rawResult}"
  }
}

resource "genesyscloud_integration_action" "Get_Agent_Utilization_by_Queue_and_Skill" {
  category        = "Genesys Cloud Public API Integration"
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "PageNumber" = {
	  	  	  "default" = "1",
	  	  	  "type" = "string"
	  	  },
	  	  "QueueId" = {
	  	  	  "description" = "Queue ID",
	  	  	  "type" = "string"
	  	  },
	  	  "RoutingStatus" = {
	  	  	  "description" = "Routing status",
	  	  	  "type" = "string"
	  	  },
	  	  "Skills" = {
	  	  	  "description" = "Skill names",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "QueueId",
	  	  "RoutingStatus",
	  	  "Skills",
	  	  "PageNumber"
	  ],
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "Response",
	  "properties" = {
	  	  "NumActive" = {
	  	  	  "items" = {
	  	  	  	  "type" = "integer"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "NumAcw" = {
	  	  	  "items" = {
	  	  	  	  "type" = "integer"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "NumAgents" = {
	  	  	  "description" = "Count of agents up to 100",
	  	  	  "type" = "integer"
	  	  },
	  	  "NumCommunicate" = {
	  	  	  "items" = {
	  	  	  	  "type" = "integer"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "UserIds" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "title" = "Response",
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  secure          = false
  config_request {
    request_url_template = "/api/v2/routing/queues/$${input.QueueId}/members?skills=$esc.url($${input.Skills})&routingStatus=$${input.RoutingStatus}&joined=true&expand=conversationSummary&pageSize=100&pageNumber=$${input.PageNumber}"
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
  }
  config_response {
    success_template = "{ \"NumAgents\": $${numAgents}, \"UserIds\": $${userIds}, \"NumActive\": $${active}, \"NumAcw\": $${acw}, \"NumCommunicate\": $${communicate} }"
    translation_map = {
      active      = "$.entities[*].user.conversationSummary.message.contactCenter.active"
      acw         = "$.entities[*].user.conversationSummary.message.contactCenter.acw"
      communicate = "$.entities[*].user.conversationSummary.message.enterprise.active"
      numAgents   = "$.entities.size()"
      userIds     = "$.entities[*].id"
    }
    translation_map_defaults = {
      active      = "[]"
      acw         = "[]"
      communicate = "[]"
      numAgents   = "0"
      userIds     = "[]"
    }
  }
  name = "Get Agent Utilization by Queue and Skill"
}

resource "genesyscloud_integration_action" "Get_Last_Agent_Who_Handled_a_Voice_Interaction_by_Phone_Number" {
  category = "Genesys Cloud Public API Integration"
  config_response {
    translation_map_defaults = {
      conversationId = "[\"Not Found\"]"
      userId         = "[\"Not Found\"]"
    }
    success_template = "{\n\t\"userId\": $${userId},\n \n\t\"conversationId\": $${conversationId}\n}"
    translation_map = {
      conversationId = "$.conversations[?('agent' in @.participants[*].purpose)].conversationId"
      userId         = "$.conversations[*].participants[?(@.purpose == 'agent')].userId"
    }
  }
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  secure         = false
  config_request {
    request_url_template = "/api/v2/analytics/conversations/details/query"
    headers = {
      Content-Type = "application/json"
    }
    request_template = "{\n\t\"interval\": \"$${input.Interval}\",\n\t\"order\": \"desc\",\n\t\"orderBy\": \"conversationStart\",\n\t\"segmentFilters\":[\n\t\t{\n\t\t\t\"type\": \"or\",\n\t\t\t\"clauses\": [\n\t\t\t\t{\n\t\t\t\t\t\"type\":\"and\",\n\t\t\t\t\t\"predicates\":[\n\t\t\t\t\t\t{\n\t\t\t\t\t\t\t\"dimension\":\"mediaType\",\n\t\t\t\t\t\t\t\"value\":\"VOICE\"\n\t\t\t\t\t\t},\n\t\t\t\t\t\t{\n\t\t\t\t\t\t\t\"dimension\": \"ANI\",\n\t\t\t\t\t\t\t\"value\": \"$${input.CustomerPhoneNumber}\"\n\t\t\t\t\t\t},\n\t\t\t\t\t\t{\n\t\t\t\t\t\t\t\"dimension\": \"purpose\",\n\t\t\t\t\t\t\t\"value\": \"customer\"\n\t\t\t\t\t\t}\n\t\t\t\t\t]\n\t\t\t\t},\n\t\t\t\t{\n\t\t\t\t\t\"type\":\"and\",\n\t\t\t\t\t\"predicates\":[\n\t\t\t\t\t\t{\n\t\t\t\t\t\t\t\"dimension\":\"mediaType\",\n\t\t\t\t\t\t\t\"value\":\"VOICE\"\n\t\t\t\t\t\t},\n\t\t\t\t\t\t{\n\t\t\t\t\t\t\t\"dimension\": \"DNIS\",\n\t\t\t\t\t\t\t\"value\": \"$${input.CustomerPhoneNumber}\"\n\t\t\t\t\t\t},\n\t\t\t\t\t\t{\n\t\t\t\t\t\t\t\"dimension\": \"purpose\",\n\t\t\t\t\t\t\t\"value\": \"customer\"\n\t\t\t\t\t\t}\n\t\t\t\t\t]\n\t\t\t\t}\n\t\t\t]\n\t\t}\n\t]\n}"
    request_type     = "POST"
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "Fields needed in the body of the POST to create a query.",
	  "properties" = {
	  	  "CustomerPhoneNumber" = {
	  	  	  "description" = "Phone number in E.164 format",
	  	  	  "type" = "string"
	  	  },
	  	  "Interval" = {
	  	  	  "description" = "Specifies the date and time range of data being queried. Results will include conversations that both started on a day touched by the interval AND either started, ended, or any activity during the interval. Intervals are represented as an ISO-8601 string. For example: YYYY-MM-DDThh:mm:ss/YYYY-MM-DDThh:mm:ss",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "Interval",
	  	  "CustomerPhoneNumber"
	  ],
	  "title" = "Query for last  inbound/outbound voice conversation related to a phone number.",
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "description" = "String array of conversationIds",
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "userId" = {
	  	  	  "description" = "String array of userIds",
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "title" = "List of last userIds / conversationIds ordered conversationStart desc",
	  "type" = "object"
  })
  name            = "Get Last Agent Who Handled a Voice Interaction by Phone Number"
}

resource "genesyscloud_integration_action" "Get_User_Skills" {
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/users/$${input.userId}/routingskills?pageSize=100&pageNumber=$${input.pageNumber}"
  }
  config_response {
    success_template = "{ \"skillProficiencies\": $${proficiencies}, \"skillNames\": $${names}, \"pageCount\": $${pageCount} }"
    translation_map = {
      names         = "$.entities..name"
      pageCount     = "$.pageCount"
      proficiencies = "$.entities..proficiency"
    }
    translation_map_defaults = {
      names         = "[]"
      pageCount     = "0"
      proficiencies = "[]"
    }
  }
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  secure          = false
  category        = "Genesys Cloud Public API Integration"
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "pageNumber" = {
	  	  	  "default" = "1",
	  	  	  "type" = "integer"
	  	  },
	  	  "userId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "pageCount" = {
	  	  	  "type" = "integer"
	  	  },
	  	  "skillNames" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "skillProficiencies" = {
	  	  	  "items" = {
	  	  	  	  "type" = "number"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "type" = "object"
  })
  name            = "Get User Skills"
}

resource "genesyscloud_integration_action" "Get_Contact_By_Phone_Number__Extended_Plus_" {
  config_request {
    request_type         = "GET"
    request_url_template = "/services/data/v37.0/search/?q=$esc.url(\"FIND {$salesforce.escReserved($${input.PHONE_NUMBER}))} IN PHONE FIELDS RETURNING Contact(AccountId,Birthdate,CreatedDate,Description,Email,Fax,FirstName,HomePhone,Id,IsDeleted,LastName,LeadSource,MailingAddress,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet,MobilePhone,Name,OwnerId,Phone,Salutation,Title,Follow_up_Preference__c,Language_Preference__c,Policy_Number__c,Group_Number__c,Certificate_Number__c,Voice_Print_Collected__c)\")"
    headers = {
      UserAgent = "PureCloudIntegrations/1.0"
    }
    request_template = "$${input.rawRequest}"
  }
  config_response {
    success_template = "$${contact}"
    translation_map = {
      contact = "$.searchRecords"
    }
  }
  integration_id  = "${genesyscloud_integration.DaveG_-_Salesforce_Data_Actions_-_DG_Sandbox.id}"
  category        = "DaveG - Salesforce Data Actions - DG Sandbox"
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "A phone number-based request.",
	  "properties" = {
	  	  "PHONE_NUMBER" = {
	  	  	  "description" = "The phone number used for the query.",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "PHONE_NUMBER"
	  ],
	  "title" = "Phone Number Request",
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "items" = {
	  	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  	  "additionalProperties" = true,
	  	  "description" = "A  Salesforce contact.",
	  	  "properties" = {
	  	  	  "Birthdate" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Certificate_Number__c" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Email" = {
	  	  	  	  "description" = "The email address of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "FirstName" = {
	  	  	  	  "description" = "The first name of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Follow_up_Preference__c" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Group_Number__c" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "HomePhone" = {
	  	  	  	  "description" = "The home phone number of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Id" = {
	  	  	  	  "description" = "The ID of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Language_Preference__c" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "LastName" = {
	  	  	  	  "description" = "The last name of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "MailingCity" = {
	  	  	  	  "description" = "The city of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "MailingCountry" = {
	  	  	  	  "description" = "The country of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "MailingPostalCode" = {
	  	  	  	  "description" = "The postal code of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "MailingState" = {
	  	  	  	  "description" = "The state of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "MailingStreet" = {
	  	  	  	  "description" = "The street address of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "MobilePhone" = {
	  	  	  	  "description" = "The mobile phone number of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "OtherPhone" = {
	  	  	  	  "description" = "Other phone number of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Phone" = {
	  	  	  	  "description" = "The phone number of the contact.",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Policy_Number__c" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "Voice_Print_Collected__c" = {
	  	  	  	  "type" = "string"
	  	  	  }
	  	  },
	  	  "required" = [
	  	  	  "Id"
	  	  ],
	  	  "title" = "Contact",
	  	  "type" = "object"
	  },
	  "properties" = {},
	  "type" = "array"
  })
  name            = "Get Contact By Phone Number (Extended Plus)"
  secure          = false
}

resource "genesyscloud_integration_action" "Get_Emergency_Group_Details" {
  name            = "Get Emergency Group Details"
  category        = "Genesys Cloud Public API Integration"
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "emergencyGroup_Ids" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "emergencyGroup_Name" = {
	  	  	  "type" = "string"
	  	  },
	  	  "enabled" = {
	  	  	  "type" = "boolean"
	  	  },
	  	  "ivrId1" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId10" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId11" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId12" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId13" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId14" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId15" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId16" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId17" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId18" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId19" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId2" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId20" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId3" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId4" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId5" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId6" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId7" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId8" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "ivrId9" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  secure          = false
  config_request {
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/architect/emergencygroups/$${input.emergencyGroup_ID}"
  }
  config_response {
    translation_map_defaults = {
      emFlowIds  = "[]"
      emFlowName = "\"none\""
      ivrId1     = "[]"
      ivrId10    = "[]"
      ivrId11    = "[]"
      ivrId12    = "[]"
      ivrId13    = "[]"
      ivrId14    = "[]"
      ivrId15    = "[]"
      ivrId16    = "[]"
      ivrId17    = "[]"
      ivrId18    = "[]"
      ivrId19    = "[]"
      ivrId2     = "[]"
      ivrId20    = "[]"
      ivrId3     = "[]"
      ivrId4     = "[]"
      ivrId5     = "[]"
      ivrId6     = "[]"
      ivrId7     = "[]"
      ivrId8     = "[]"
      ivrId9     = "[]"
    }
    success_template = "{\r\n\"emergencyGroup_Name\": $${emFlowName},\r\n\"emergencyGroup_Ids\": $${emFlowIds},\r\n\"enabled\" : $${enabled},\r\n\"ivrId1\": $${ivrId1},\r\n\"ivrId2\": $${ivrId2},\r\n\"ivrId3\": $${ivrId3},\r\n\"ivrId4\": $${ivrId4},\r\n\"ivrId5\": $${ivrId5},\r\n\"ivrId6\": $${ivrId6},\r\n\"ivrId7\": $${ivrId7},\r\n\"ivrId8\": $${ivrId8},\r\n\"ivrId9\": $${ivrId9},\r\n\"ivrId10\": $${ivrId10},\r\n\"ivrId11\": $${ivrId11},\r\n\"ivrId12\": $${ivrId12},\r\n\"ivrId13\": $${ivrId13},\r\n\"ivrId14\": $${ivrId14},\r\n\"ivrId15\": $${ivrId15},\r\n\"ivrId16\": $${ivrId16},\r\n\"ivrId17\": $${ivrId17},\r\n\"ivrId18\": $${ivrId18},\r\n\"ivrId19\": $${ivrId19},\r\n\"ivrId20\": $${ivrId20}\r\n}"
    translation_map = {
      emFlowIds  = "$.emergencyCallFlows[*].emergencyFlow.id"
      emFlowName = "$.name"
      enabled    = "$.enabled"
      ivrId1     = "$.emergencyCallFlows[0].ivrs[*].id"
      ivrId10    = "$.emergencyCallFlows[9].ivrs[*].id"
      ivrId11    = "$.emergencyCallFlows[10].ivrs[*].id"
      ivrId12    = "$.emergencyCallFlows[11].ivrs[*].id"
      ivrId13    = "$.emergencyCallFlows[12].ivrs[*].id"
      ivrId14    = "$.emergencyCallFlows[13].ivrs[*].id"
      ivrId15    = "$.emergencyCallFlows[14].ivrs[*].id"
      ivrId16    = "$.emergencyCallFlows[15].ivrs[*].id"
      ivrId17    = "$.emergencyCallFlows[16].ivrs[*].id"
      ivrId18    = "$.emergencyCallFlows[17].ivrs[*].id"
      ivrId19    = "$.emergencyCallFlows[18].ivrs[*].id"
      ivrId2     = "$.emergencyCallFlows[1].ivrs[*].id"
      ivrId20    = "$.emergencyCallFlows[19].ivrs[*].id"
      ivrId3     = "$.emergencyCallFlows[2].ivrs[*].id"
      ivrId4     = "$.emergencyCallFlows[3].ivrs[*].id"
      ivrId5     = "$.emergencyCallFlows[4].ivrs[*].id"
      ivrId6     = "$.emergencyCallFlows[5].ivrs[*].id"
      ivrId7     = "$.emergencyCallFlows[6].ivrs[*].id"
      ivrId8     = "$.emergencyCallFlows[7].ivrs[*].id"
      ivrId9     = "$.emergencyCallFlows[8].ivrs[*].id"
    }
  }
  contract_input = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "Check Emergency Group Status",
	  "properties" = {
	  	  "emergencyGroup_ID" = {
	  	  	  "description" = "Emergency Group ID",
	  	  	  "type" = "string"
	  	  }
	  },
	  "title" = "GET EmergencyGroup info",
	  "type" = "object"
  })
}

resource "genesyscloud_integration_action" "Get_Locations" {
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/locations?pageSize=100&pageNumber=$${input.pageNumber}"
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "pageNumber" = {
	  	  	  "default" = "1",
	  	  	  "type" = "integer"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "locationIds" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  },
	  	  "locationNames" = {
	  	  	  "items" = {
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "type" = "object"
  })
  category        = "Genesys Cloud Public API Integration"
  config_response {
    success_template = "{ \"locationIds\": $${ids}, \"locationNames\": $${names} }"
    translation_map = {
      ids   = "$.entities..id"
      names = "$.entities..name"
    }
    translation_map_defaults = {
      ids   = "[]"
      names = "[]"
    }
  }
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name           = "Get Locations"
  secure         = false
}

resource "genesyscloud_integration_action" "Get_User_Participants_by_Conversation_ID" {
  contract_input = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "A user ID-based request.",
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "description" = "the conversation ID",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "conversationId"
	  ],
	  "title" = "UserIdRequest",
	  "type" = "object"
  })
  name           = "Get User Participants by Conversation ID"
  category       = "Genesys Cloud Public API Integration"
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/analytics/conversations/$${input.conversationId}/details"
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
  }
  config_response {
    success_template = "{\n \"userId\": $${userId}\n}"
    translation_map = {
      userId = "$..userId"
    }
  }
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "userId" = {
	  	  	  "description" = "the user ID",
	  	  	  "type" = "array"
	  	  }
	  },
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  secure          = false
}

resource "genesyscloud_integration_action" "Get_On_Queue_Agents_by_Skill" {
  config_request {
    request_type         = "GET"
    request_url_template = "/api/v2/routing/queues/$${input.QUEUE_ID}/members?skills=$esc.url($${input.SKILL})&routingStatus=$${input.ROUTING_STATUS}&joined=true"
    headers = {
      Content-Type = "application/json"
      UserAgent    = "PureCloudIntegrations/1.0"
    }
    request_template = "$${input.rawRequest}"
  }
  config_response {
    success_template = "{\n   \"iAgents\": $${iAgents}\n}"
    translation_map = {
      iAgents = "$.entities.size()"
    }
  }
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "description" = "Response",
	  "properties" = {
	  	  "iAgents" = {
	  	  	  "description" = "Count of agents up to 25",
	  	  	  "type" = "integer"
	  	  }
	  },
	  "title" = "Response",
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name            = "Get On Queue Agents by Skill"
  secure          = false
  category        = "Genesys Cloud Public API Integration"
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "additionalProperties" = true,
	  "properties" = {
	  	  "QUEUE_ID" = {
	  	  	  "description" = "Queue ID",
	  	  	  "type" = "string"
	  	  },
	  	  "ROUTING_STATUS" = {
	  	  	  "description" = "Routing status",
	  	  	  "type" = "string"
	  	  },
	  	  "SKILL" = {
	  	  	  "description" = "Skill names",
	  	  	  "type" = "string"
	  	  }
	  },
	  "required" = [
	  	  "QUEUE_ID",
	  	  "ROUTING_STATUS",
	  	  "SKILL"
	  ],
	  "type" = "object"
  })
}

resource "genesyscloud_integration_action" "Get_Contact_From_Contact_List" {
  integration_id = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
  name           = "Get Contact From Contact List"
  secure         = false
  category       = "Genesys Cloud Public API Integration"
  config_request {
    request_type         = "GET"
    request_url_template = "/api/v2/outbound/contactlists/$${input.contactlistId}/contacts/$${input.contactId}"
    headers = {
      Content-Type = "application/json"
    }
    request_template = "$${input.rawRequest}"
  }
  contract_input  = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "properties" = {
	  	  "contactId" = {
	  	  	  "type" = "string"
	  	  },
	  	  "contactListId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "$schema" = "http://json-schema.org/draft-04/schema#",
	  "description" = "Returns Contact List Entry",
	  "properties" = {
	  	  "data.CustomerName" = {
	  	  	  "description" = "Example contact column",
	  	  	  "title" = "Customer Name",
	  	  	  "type" = "string"
	  	  }
	  },
	  "title" = "Get Info from Contact List",
	  "type" = "object"
  })
  config_response {
    success_template = "$${rawResult}"
  }
}

resource "genesyscloud_integration_action" "Get_Last_Agents_by_Conversation_ID" {
  category = "Genesys Cloud Public API Integration"
  config_request {
    request_template     = "$${input.rawRequest}"
    request_type         = "GET"
    request_url_template = "/api/v2/conversations/$${input.ConversationID}"
  }
  secure = false
  name   = "Get Last Agents by Conversation ID"
  config_response {
    success_template = "{\"userId\" : $${userId}}}"
    translation_map = {
      userId = "$.participants[?(@.purpose == 'agent')].userId"
    }
    translation_map_defaults = {
      userId = "[\"Not Found\"]"
    }
  }
  contract_input  = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "conversationId" = {
	  	  	  "type" = "string"
	  	  }
	  },
	  "type" = "object"
  })
  contract_output = jsonencode({
	  "additionalProperties" = true,
	  "properties" = {
	  	  "userId" = {
	  	  	  "items" = {
	  	  	  	  "title" = "Item 1",
	  	  	  	  "type" = "string"
	  	  	  },
	  	  	  "type" = "array"
	  	  }
	  },
	  "title" = "List of last userIds",
	  "type" = "object"
  })
  integration_id  = "${genesyscloud_integration.Genesys_Cloud_Public_API_Integration.id}"
}

resource "genesyscloud_widget_deployment" "Agnes_Deployment_v1" {
  client_config {
    webchat_skin = "modern-caret-skin"
  }
  client_type             = "v1"
  disabled                = false
  authentication_required = false
  name                    = "Agnes Deployment v1"
}

resource "genesyscloud_widget_deployment" "Agnes_Deployment_v2" {
  client_type             = "v2"
  disabled                = false
  authentication_required = false
  flow_id                 = "${genesyscloud_flow.INBOUNDCHAT_Agnes_Chat_Flow.id}"
  name                    = "Agnes Deployment v2"
}

resource "genesyscloud_widget_deployment" "Agnes_Deployment__3rd_Party_" {
  client_type             = "third-party"
  disabled                = false
  name                    = "Agnes Deployment (3rd Party)"
  authentication_required = false
  flow_id                 = "${genesyscloud_flow.INBOUNDCHAT_Agnes_Chat_Flow.id}"
}

resource "genesyscloud_widget_deployment" "TutorWebChat_Widget" {
  name                    = "TutorWebChat_Widget"
  disabled                = false
  client_type             = "v2"
  authentication_required = false
}

resource "genesyscloud_widget_deployment" "Agnes_Deployment_v1_1" {
  disabled                = false
  name                    = "Agnes Deployment v1.1"
  authentication_required = false
  flow_id                 = "${genesyscloud_flow.INBOUNDCHAT_Agnes_Chat_Flow.id}"
  client_config {
    webchat_skin = "modern-caret-skin"
  }
  client_type = "v1-http"
}

resource "genesyscloud_responsemanagement_library" "Reference_library1" {
  name = "Reference library1"
}

resource "genesyscloud_knowledge_knowledgebase" "Prince_Pokedex" {
  name          = "Prince Pokedex"
  published     = true
  core_language = "en-PH"
  description   = "Pokemon knowledge transformed from the PokeAPI (https://pokeapi.co/)"
}

resource "genesyscloud_outbound_dnclist" "dnc_list_bdbc875b-cb51-456a-b15d-dac611777259" {
  contact_method  = "Phone"
  dnc_source_type = "rds"
  name            = "dnc list bdbc875b-cb51-456a-b15d-dac611777259"
  division_id     = "${genesyscloud_auth_division.New_Home.id}"
}

resource "genesyscloud_outbound_callabletimeset" "tf_timeset_cbab3c95-fd14-4a2d-b992-df290281564a" {
  callable_times {
    time_zone_id = "Africa/Abidjan"
    time_slots {
      start_time = "07:00:00"
      stop_time  = "18:00:00"
      day        = 3
    }
  }
  name = "tf timeset cbab3c95-fd14-4a2d-b992-df290281564a"
}

resource "genesyscloud_outbound_callabletimeset" "Test_Callable_time_sete44e3fd6-5b48-4015-8c70-9de130490cbf" {
  name = "Test Callable time sete44e3fd6-5b48-4015-8c70-9de130490cbf"
  callable_times {
    time_slots {
      day        = 1
      start_time = "09:00:00"
      stop_time  = "21:30:30"
    }
    time_slots {
      day        = 7
      start_time = "10:30:45"
      stop_time  = "23:00:15"
    }
    time_zone_id = "Africa/Abidjan"
  }
  callable_times {
    time_slots {
      day        = 2
      start_time = "08:15:15"
      stop_time  = "20:30:45"
    }
    time_slots {
      day        = 4
      start_time = "01:00:00"
      stop_time  = "12:00:00"
    }
    time_zone_id = "Europe/Dublin"
  }
}

resource "genesyscloud_integration_custom_auth_action" "example_integration_name__Auth_" {
  config_request {
    headers = {
      Cache-Control = "no-cache"
    }
    request_template     = "$${input.rawRequest2}"
    request_type         = "POST"
    request_url_template = "test2"
  }
  config_response {
    success_template = "{ \"name\": $${2nameValue}, \"build\": $${buildNumber} }"
    translation_map = {
      buildNumber = "$.Build-Version"
      nameValue   = "$.Name"
    }
    translation_map_defaults = {
      buildNumber = "UNKNOWN"
    }
  }
  integration_id = "${genesyscloud_integration.example_integration_name.id}"
  name           = "example_integration name (Auth)"
}

resource "genesyscloud_integration" "Accelerator_-_Update_User_On_Communicate_Call" {
  integration_type = "purecloud-data-actions"
  intended_state   = "ENABLED"
  config {
    name       = "Accelerator - Update User On Communicate Call"
    notes      = "Genesys Cloud Integration for the 'Update User Presence on Communicate Call' Accelerator"
    properties = jsonencode({    })
    advanced   = jsonencode({    })
  }
}

resource "genesyscloud_integration" "Chat_Translator_LOCALHOST" {
  intended_state = "ENABLED"
  config {
    advanced   = jsonencode({
	    "icon" = {
	    	    "128x128" = "https://raw.githubusercontent.com/GenesysCloudBlueprints/chat-translator-blueprint/main/blueprint/images/ear%20128x128.png",
	    	    "256x256" = "https://raw.githubusercontent.com/GenesysCloudBlueprints/chat-translator-blueprint/main/blueprint/images/ear%20256x256.png",
	    	    "48x48" = "https://raw.githubusercontent.com/GenesysCloudBlueprints/chat-translator-blueprint/main/blueprint/images/ear%2048x48.png",
	    	    "96x96" = "https://raw.githubusercontent.com/GenesysCloudBlueprints/chat-translator-blueprint/main/blueprint/images/ear%2096x96.png"
	    },
	    "lifecycle" = {
	    	    "ephemeral" = false,
	    	    "hooks" = {
	    	    	    "blur" = true,
	    	    	    "bootstrap" = true,
	    	    	    "focus" = true,
	    	    	    "stop" = true
	    	    }
	    },
	    "monochromicIcon" = {
	    	    "vector" = "https://raw.githubusercontent.com/GenesysCloudBlueprints/chat-translator-blueprint/main/blueprint/images/ear.svg"
	    }
    })
    name       = "Chat Translator LOCALHOST"
    properties = jsonencode({
	    "communicationTypeFilter" = "chat",
	    "groups" = [
	    	    ""
	    ],
	    "permissions" = null,
	    "queueIdFilterList" = [
	    	    "44d7cafc-37d8-422e-8c45-aef133ac2dd9"
	    ],
	    "sandbox" = "allow-scripts,allow-same-origin,allow-forms,allow-modals",
	    "url" = "https://localhost/?conversationid={{gcConversationId}}\u0026language={{gcLangTag}}"
    })
  }
  integration_type = "embedded-client-app-interaction-widget"
}

resource "genesyscloud_integration" "Orbit_Data_Actions_OAuth_Integration_2604983327" {
  config {
    advanced   = jsonencode({    })
    name       = "Orbit Data Actions OAuth Integration"
    properties = jsonencode({    })
  }
  integration_type = "purecloud-data-actions"
  intended_state   = "DISABLED"
}

resource "genesyscloud_integration" "GC_Data_Actions_Public_API" {
  integration_type = "purecloud-data-actions"
  intended_state   = "ENABLED"
  config {
    properties = jsonencode({    })
    advanced   = jsonencode({    })
    name       = "GC Data Actions Public API"
  }
}

resource "genesyscloud_integration" "Prince_GC" {
  intended_state = "ENABLED"
  config {
    name       = "Prince_GC"
    properties = jsonencode({    })
    advanced   = jsonencode({    })
  }
  integration_type = "purecloud-data-actions"
}

resource "genesyscloud_integration" "Accelerator_-_Send_Email_Notification_on_Message_Failed" {
  integration_type = "purecloud-data-actions"
  intended_state   = "ENABLED"
  config {
    advanced   = jsonencode({    })
    name       = "Accelerator - Send Email Notification on Message Failed"
    notes      = "Created by the 'Send Email Notification when Outbound Message Fails' accelerator."
    properties = jsonencode({    })
  }
}

resource "genesyscloud_integration" "Genesys_Cloud_Public_API_Integration" {
  config {
    properties = jsonencode({    })
    advanced   = jsonencode({    })
    name       = "Genesys Cloud Public API Integration"
  }
  integration_type = "purecloud-data-actions"
  intended_state   = "ENABLED"
}

resource "genesyscloud_integration" "Accelerator_-_Automated_Callbacks" {
  config {
    advanced   = jsonencode({    })
    name       = "Accelerator - Automated Callbacks"
    notes      = "Genesys Cloud Integration for the 'Automate callbacks using always-running campaign' Accelerator"
    properties = jsonencode({    })
  }
  integration_type = "purecloud-data-actions"
  intended_state   = "ENABLED"
}

resource "genesyscloud_integration" "example_integration_name" {
  config {
    properties = jsonencode({    })
    advanced   = jsonencode({    })
    name       = "example_integration name"
    notes      = "Test config notes"
  }
  integration_type = "custom-rest-actions"
  intended_state   = "ENABLED"
}

resource "genesyscloud_integration" "Orbit_Data_Actions_OAuth_Integration_2604983327_3497928598" {
  config {
    name       = "Orbit Data Actions OAuth Integration"
    properties = jsonencode({    })
    advanced   = jsonencode({    })
  }
  integration_type = "purecloud-data-actions"
  intended_state   = "ENABLED"
}

resource "genesyscloud_integration" "_1_web_services_data_action" {
  config {
    properties = jsonencode({
	    "clientCertificateAuthority" = "Genesys Cloud"
    })
    advanced   = jsonencode({    })
    name       = "1_web services data action"
  }
  integration_type = "custom-rest-actions"
  intended_state   = "ENABLED"
}

resource "genesyscloud_integration" "Web_Services_Data_Actions_jcc" {
  integration_type = "custom-rest-actions"
  intended_state   = "DISABLED"
  config {
    name       = "Web Services Data Actions_jcc"
    properties = jsonencode({    })
    advanced   = jsonencode({    })
  }
}

resource "genesyscloud_integration" "ComprehendDataAction" {
  integration_type = "custom-rest-actions"
  intended_state   = "ENABLED"
  config {
    notes      = "Used to invoke an AWS Comprehend job"
    properties = jsonencode({    })
    advanced   = jsonencode({    })
    name       = "ComprehendDataAction"
  }
}

resource "genesyscloud_integration" "web-messaging-triage-bot-data-action" {
  config {
    properties = jsonencode({    })
    advanced   = jsonencode({    })
    name       = "web-messaging-triage-bot-data-action"
  }
  integration_type = "purecloud-data-actions"
  intended_state   = "ENABLED"
}

resource "genesyscloud_integration" "DaveG_-_Salesforce_Data_Actions_-_DG_Sandbox" {
  integration_type = "salesforce-datadip"
  intended_state   = "ENABLED"
  config {
    advanced   = jsonencode({    })
    name       = "DaveG - Salesforce Data Actions - DG Sandbox"
    notes      = "Dave Gussin Salesforce Sandbox"
    properties = jsonencode({    })
  }
}

resource "genesyscloud_integration" "Amazon_EventBridge_Source" {
  config {
    advanced   = jsonencode({    })
    name       = "Amazon EventBridge Source"
    properties = jsonencode({    })
  }
  integration_type = "amazon-eventbridge-source"
  intended_state   = "DISABLED"
}

resource "genesyscloud_organization_authentication_settings" "organization_authentication_settings" {
  domain_allowlist_enabled            = false
  multifactor_authentication_required = false
  password_requirements {
    minimum_digits   = 1
    minimum_length   = 8
    minimum_lower    = 1
    minimum_specials = 1
    minimum_upper    = 1
  }
}

resource "genesyscloud_script" "Orbit_Queue_Transfer_July_2024" {
  file_content_hash = "${filesha256("scripts/script-c4f2192d-1114-43c3-b2b4-1d8cb8e8b7ee.json")}"
  filepath          = "scripts/script-c4f2192d-1114-43c3-b2b4-1d8cb8e8b7ee.json"
  script_name       = "Orbit Queue Transfer July 2024"
}

resource "genesyscloud_script" "Dave_-_SFDC_Service" {
  script_name       = "Dave - SFDC Service"
  file_content_hash = "${filesha256("scripts/script-44473b6f-0262-45a3-89f3-e86cfe213e28.json")}"
  filepath          = "scripts/script-44473b6f-0262-45a3-89f3-e86cfe213e28.json"
}

resource "genesyscloud_script" "Orbit_Queue_Transfer" {
  script_name       = "Orbit Queue Transfer"
  file_content_hash = "${filesha256("scripts/script-cd02d5a5-85a7-40a4-afd6-abede9486a2b.json")}"
  filepath          = "scripts/script-cd02d5a5-85a7-40a4-afd6-abede9486a2b.json"
}

resource "genesyscloud_architect_schedules" "Labour_Day" {
  start       = "2022-09-05T00:00:00.000000"
  division_id = "${genesyscloud_auth_division.New_Home.id}"
  end         = "2022-09-05T23:59:59.000000"
  name        = "Labour Day"
  rrule       = "FREQ=YEARLY;INTERVAL=1;BYMONTH=9;BYDAY=MO;BYSETPOS=1"
}

resource "genesyscloud_architect_schedules" "Canada_Day" {
  end         = "2018-07-03T00:00:00.000000"
  name        = "Canada Day"
  rrule       = ""
  start       = "2018-07-02T00:00:00.000000"
  division_id = "${genesyscloud_auth_division.New_Home.id}"
}

resource "genesyscloud_architect_schedules" "Business_Hours" {
  division_id = "${genesyscloud_auth_division.New_Home.id}"
  end         = "2020-05-01T17:00:00.000000"
  name        = "Business Hours"
  rrule       = "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR"
  start       = "2020-05-01T08:00:00.000000"
}

resource "genesyscloud_architect_schedules" "Christmas" {
  division_id = "${genesyscloud_auth_division.New_Home.id}"
  end         = "2022-12-25T23:59:59.000000"
  name        = "Christmas"
  rrule       = "FREQ=YEARLY;INTERVAL=1;BYMONTH=12;BYMONTHDAY=25"
  start       = "2022-12-25T00:00:00.000000"
}

resource "genesyscloud_architect_schedules" "Victoria_Day" {
  name        = "Victoria Day"
  rrule       = "FREQ=YEARLY;INTERVAL=1;BYMONTH=5;BYDAY=MO;BYSETPOS=4"
  start       = "2023-05-22T00:00:00.000000"
  division_id = "${genesyscloud_auth_division.New_Home.id}"
  end         = "2023-05-22T23:59:59.000000"
}

resource "genesyscloud_architect_schedules" "Weekend" {
  rrule       = "FREQ=WEEKLY;INTERVAL=1;BYDAY=SA,SU"
  start       = "2020-05-02T00:00:00.000000"
  division_id = "${genesyscloud_auth_division.New_Home.id}"
  end         = "2020-05-02T23:59:59.000000"
  name        = "Weekend"
}

resource "genesyscloud_architect_schedules" "Boxing_Day" {
  start       = "2022-12-26T00:00:00.000000"
  division_id = "${genesyscloud_auth_division.New_Home.id}"
  end         = "2022-12-26T23:59:59.000000"
  name        = "Boxing Day"
  rrule       = "FREQ=YEARLY;INTERVAL=1;BYMONTH=12;BYMONTHDAY=26"
}

resource "genesyscloud_architect_schedules" "After_Hours" {
  name        = "After Hours"
  rrule       = "FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR"
  start       = "2020-05-01T18:00:00.000000"
  division_id = "${genesyscloud_auth_division.New_Home.id}"
  end         = "2020-05-02T08:00:00.000000"
}

resource "genesyscloud_architect_schedules" "Civic_Holiday" {
  end         = "2022-08-01T23:59:59.000000"
  name        = "Civic Holiday"
  rrule       = "FREQ=YEARLY;INTERVAL=1;BYMONTH=8;BYDAY=MO;BYSETPOS=1"
  start       = "2022-08-01T00:00:00.000000"
  division_id = "${genesyscloud_auth_division.New_Home.id}"
}

resource "genesyscloud_routing_utilization" "routing_utilization" {
  message {
    include_non_acd  = false
    maximum_capacity = 4
  }
  call {
    include_non_acd  = false
    maximum_capacity = 1
  }
  callback {
    maximum_capacity = 1
    include_non_acd  = false
  }
  chat {
    maximum_capacity = 4
    include_non_acd  = false
  }
  email {
    include_non_acd           = false
    interruptible_media_types = ["call", "callback", "chat"]
    maximum_capacity          = 1
  }
}

resource "genesyscloud_webdeployments_deployment" "fallback-mychatbot-webmessengerdeploy" {
  name              = "fallback-mychatbot-webmessengerdeploy"
  status            = "Active"
  allow_all_domains = true
  configuration {
    id      = "${genesyscloud_webdeployments_configuration.fallback-mychatbot-webmessengerconfig.id}"
    version = "1"
  }
  description = "This is an example of a web deployment"
  flow_id     = "${genesyscloud_flow.INBOUNDSHORTMESSAGE_MyWebMessenger-Fallback.id}"
}

resource "genesyscloud_webdeployments_deployment" "Agnes_Messenger_Deployment" {
  flow_id           = "${genesyscloud_flow.INBOUNDSHORTMESSAGE_Agnes_Message_Flow.id}"
  name              = "Agnes Messenger Deployment"
  status            = "Active"
  allow_all_domains = true
  configuration {
    id      = "${genesyscloud_webdeployments_configuration.Agnes_Messenger_Config.id}"
    version = "1"
  }
}

resource "genesyscloud_webdeployments_deployment" "PrinceDeployment" {
  allow_all_domains = true
  configuration {
    id      = "${genesyscloud_webdeployments_configuration.PrinceMessenger.id}"
    version = "1"
  }
  flow_id = "${genesyscloud_flow.INBOUNDSHORTMESSAGE_PrinceInboundMessage.id}"
  name    = "PrinceDeployment"
  status  = "Active"
}

resource "genesyscloud_webdeployments_deployment" "web-messaging-triage-bot-deployment" {
  description       = "Web messaging deployment"
  flow_id           = "${genesyscloud_flow.INBOUNDSHORTMESSAGE_web-messaging-triage-bot-flow.id}"
  name              = "web-messaging-triage-bot-deployment"
  status            = "Active"
  allow_all_domains = true
  configuration {
    id      = "${genesyscloud_webdeployments_configuration.web-messaging-triage-bot-configuration.id}"
    version = "1"
  }
}

resource "genesyscloud_webdeployments_configuration" "Agnes_Messenger_Config" {
  messenger {
    enabled = true
    file_upload {
      mode {
        file_types       = ["image/jpeg", "image/gif", "image/png"]
        max_file_size_kb = 10240
      }
    }
    home_screen {
      enabled = false
    }
    launcher_button {
      visibility = "On"
    }
    styles {
      primary_color = "#23395d"
    }
    apps {
      conversations {
        conversation_disconnect {
          enabled = false
          type    = "Send"
        }
        enabled = true
        humanize {
          bot {
          }
          enabled = false
        }
        markdown_enabled            = true
        show_agent_typing_indicator = true
        show_user_typing_indicator  = true
        auto_start_enabled          = false
        conversation_clear_enabled  = false
      }
    }
  }
  position {
    alignment    = "Auto"
    bottom_space = 12
    side_space   = 20
  }
  languages        = ["ar", "zh-cn", "zh-tw", "cs", "da", "nl", "en-us", "et", "fi", "fr", "de", "he", "it", "ja", "ko", "lv", "lt", "no", "pl", "pt-br", "pt-pt", "ru", "es", "sv", "th", "tr"]
  name             = "Agnes Messenger Config"
  default_language = "en-us"
  journey_events {
    enabled                  = false
    should_keep_url_fragment = false
  }
  status = "Active"
  cobrowse {
    allow_agent_control = true
    enabled             = false
  }
  headless_mode_enabled = false
}

resource "genesyscloud_webdeployments_configuration" "fallback-mychatbot-webmessengerconfig" {
  name             = "fallback-mychatbot-webmessengerconfig"
  languages        = ["en-us", "ja"]
  default_language = "en-us"
  messenger {
    launcher_button {
      visibility = "On"
    }
    styles {
      primary_color = "#B0B0B0"
    }
    apps {
      conversations {
        show_user_typing_indicator  = true
        auto_start_enabled          = false
        conversation_clear_enabled  = false
        enabled                     = false
        markdown_enabled            = false
        show_agent_typing_indicator = true
      }
    }
    enabled = true
    file_upload {
      mode {
        file_types       = ["image/png"]
        max_file_size_kb = 256
      }
      mode {
        file_types       = ["image/jpeg"]
        max_file_size_kb = 128
      }
    }
  }
  description = "This example configuration shows how to define a full web deployment configuration"
  status      = "Active"
}

resource "genesyscloud_webdeployments_configuration" "web-messaging-triage-bot-configuration" {
  default_language = "en-us"
  languages        = ["ar", "cs", "da", "de", "en-us", "es", "fi", "fr", "it", "ja", "ko", "nl", "no", "pl", "pt-br", "ru", "sv", "th", "tr", "zh-cn", "zh-tw"]
  messenger {
    apps {
      conversations {
        auto_start_enabled          = false
        conversation_clear_enabled  = false
        enabled                     = false
        markdown_enabled            = false
        show_agent_typing_indicator = true
        show_user_typing_indicator  = true
      }
    }
    enabled = true
    file_upload {
      mode {
        file_types       = ["image/png"]
        max_file_size_kb = 256
      }
      mode {
        file_types       = ["image/jpeg"]
        max_file_size_kb = 128
      }
    }
    launcher_button {
      visibility = "On"
    }
    styles {
      primary_color = "#00AE9E"
    }
  }
  journey_events {
    should_keep_url_fragment = false
    enabled                  = false
  }
  name   = "web-messaging-triage-bot-configuration"
  status = "Active"
}

resource "genesyscloud_webdeployments_configuration" "Test_Configuration_6LG3QHBH" {
  languages = ["en-us", "ja"]
  messenger {
    file_upload {
      mode {
        file_types       = ["image/png"]
        max_file_size_kb = 100
      }
      mode {
        file_types       = ["image/jpeg"]
        max_file_size_kb = 123
      }
    }
    home_screen {
      enabled  = true
      logo_url = "https://my-domain/images/my-logo.png"
    }
    launcher_button {
      visibility = "OnDemand"
    }
    styles {
      primary_color = "#B0B0B0"
    }
    apps {
      conversations {
        enabled                     = false
        markdown_enabled            = false
        show_agent_typing_indicator = true
        show_user_typing_indicator  = true
        auto_start_enabled          = false
        conversation_clear_enabled  = false
      }
    }
    enabled = true
  }
  default_language = "en-us"
  status           = "Active"
  description      = "Test Configuration description odNmU2QBisMuUcR4h7iRgkBfwOOporeA"
  name             = "Test Configuration 6LG3QHBH"
  journey_events {
    click_event {
      event_name = "first-click-event-name"
      selector   = "first-selector"
    }
    click_event {
      event_name = "second-click-event-name"
      selector   = "second-selector"
    }
    enabled = true
    in_viewport_event {
      event_name = "in-viewport-event-1"
      selector   = "in-viewport-selector-1"
    }
    in_viewport_event {
      event_name = "in-viewport-event-2"
      selector   = "in-viewport-selector-2"
    }
    pageview_config           = "Auto"
    should_keep_url_fragment  = false
    excluded_query_parameters = ["excluded-one"]
    form_track_event {
      capture_data_on_form_abandon = true
      capture_data_on_form_submit  = false
      form_name                    = "form-1"
      selector                     = "form-selector-1"
    }
    form_track_event {
      selector                     = "form-selector-2"
      capture_data_on_form_abandon = false
      capture_data_on_form_submit  = true
      form_name                    = "form-3"
    }
    idle_event {
      event_name         = "idle-event-1"
      idle_after_seconds = 88
    }
    idle_event {
      event_name         = "idle-event-2"
      idle_after_seconds = 30
    }
    scroll_depth_event {
      event_name = "scroll-depth-event-1"
      percentage = 33
    }
    scroll_depth_event {
      event_name = "scroll-depth-event-2"
      percentage = 66
    }
  }
  support_center {
    feedback_enabled  = true
    knowledge_base_id = "dfffc742-3ba4-4363-b8e6-fbc1bea1f643"
    router_type       = "Hash"
    custom_messages {
      default_value = "Welcome to Knowledge Portal"
      type          = "Welcome"
    }
    enabled = true
    enabled_categories {
      category_id = "dfffc742-3ba4-4363-b8e6-fbc1bea1f643"
      image_uri   = "https://my-domain/images/my-logo.png"
    }
  }
}

resource "genesyscloud_webdeployments_configuration" "PrinceMessenger" {
  headless_mode_enabled = false
  position {
    alignment    = "Auto"
    bottom_space = 12
    side_space   = 20
  }
  cobrowse {
    allow_agent_control = true
    enabled             = false
  }
  journey_events {
    enabled                  = false
    should_keep_url_fragment = false
  }
  languages = ["en-us"]
  messenger {
    apps {
      conversations {
        show_agent_typing_indicator = true
        show_user_typing_indicator  = true
        auto_start_enabled          = false
        conversation_clear_enabled  = false
        conversation_disconnect {
          enabled = true
          type    = "Send"
        }
        enabled = false
        humanize {
          bot {
            name = "Doraemon"
          }
          enabled = true
        }
        markdown_enabled = true
      }
    }
    enabled = true
    file_upload {
      mode {
        file_types       = ["image/jpeg", "image/gif", "image/png"]
        max_file_size_kb = 10240
      }
    }
    home_screen {
      enabled = false
    }
    launcher_button {
      visibility = "On"
    }
    styles {
      primary_color = "#7b3f3f"
    }
  }
  name             = "PrinceMessenger"
  default_language = "en-us"
  status           = "Active"
}

resource "genesyscloud_webdeployments_configuration" "Test_Configuration_NWK2Yj2D" {
  languages        = ["en-us", "ja"]
  default_language = "en-us"
  support_center {
    router_type = "Hash"
    custom_messages {
      default_value = "Welcome to Knowledge Portal"
      type          = "Welcome"
    }
    enabled = true
    enabled_categories {
      category_id = "dfffc742-3ba4-4363-b8e6-fbc1bea1f643"
      image_uri   = "https://my-domain/images/my-logo.png"
    }
    feedback_enabled  = true
    knowledge_base_id = "dfffc742-3ba4-4363-b8e6-fbc1bea1f643"
  }
  description = "Test Configuration description HdOQvQj0QH68qUQdW0jyJwTFxaiKUSVm"
  journey_events {
    should_keep_url_fragment = false
    click_event {
      event_name = "first-click-event-name"
      selector   = "first-selector"
    }
    click_event {
      event_name = "second-click-event-name"
      selector   = "second-selector"
    }
    in_viewport_event {
      event_name = "in-viewport-event-1"
      selector   = "in-viewport-selector-1"
    }
    in_viewport_event {
      event_name = "in-viewport-event-2"
      selector   = "in-viewport-selector-2"
    }
    pageview_config = "Auto"
    scroll_depth_event {
      event_name = "scroll-depth-event-1"
      percentage = 33
    }
    scroll_depth_event {
      event_name = "scroll-depth-event-2"
      percentage = 66
    }
    enabled                   = true
    excluded_query_parameters = ["excluded-one"]
    form_track_event {
      capture_data_on_form_submit  = false
      form_name                    = "form-1"
      selector                     = "form-selector-1"
      capture_data_on_form_abandon = true
    }
    form_track_event {
      selector                     = "form-selector-2"
      capture_data_on_form_abandon = false
      capture_data_on_form_submit  = true
      form_name                    = "form-3"
    }
    idle_event {
      idle_after_seconds = 88
      event_name         = "idle-event-1"
    }
    idle_event {
      event_name         = "idle-event-2"
      idle_after_seconds = 30
    }
  }
  name   = "Test Configuration NWK2Yj2D"
  status = "Active"
  messenger {
    apps {
      conversations {
        conversation_clear_enabled  = false
        enabled                     = false
        markdown_enabled            = false
        show_agent_typing_indicator = true
        show_user_typing_indicator  = true
        auto_start_enabled          = false
      }
    }
    enabled = true
    file_upload {
      mode {
        file_types       = ["image/png"]
        max_file_size_kb = 100
      }
      mode {
        file_types       = ["image/jpeg"]
        max_file_size_kb = 123
      }
    }
    home_screen {
      logo_url = "https://my-domain/images/my-logo.png"
      enabled  = true
    }
    launcher_button {
      visibility = "OnDemand"
    }
    styles {
      primary_color = "#B0B0B0"
    }
  }
}

resource "genesyscloud_flow" "INBOUNDCALL_Dave_-_SFDC_Service_-_Basic" {
  filepath          = "${var.genesyscloud_flow_INBOUNDCALL_Dave_-_SFDC_Service_-_Basic_filepath}"
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDCALL_Dave_-_SFDC_Service_-_Basic_filepath)}"
}

resource "genesyscloud_flow" "BOT_MyEmergencyChatBot" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_BOT_MyEmergencyChatBot_filepath)}"
  filepath          = "${var.genesyscloud_flow_BOT_MyEmergencyChatBot_filepath}"
}

resource "genesyscloud_flow" "INBOUNDSHORTMESSAGE_PrinceInboundMessage" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDSHORTMESSAGE_PrinceInboundMessage_filepath)}"
  filepath          = "${var.genesyscloud_flow_INBOUNDSHORTMESSAGE_PrinceInboundMessage_filepath}"
}

resource "genesyscloud_flow" "WORKFLOW_Accelerator__Set_User_Presence_on_Communicate_Call" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_WORKFLOW_Accelerator__Set_User_Presence_on_Communicate_Call_filepath)}"
  filepath          = "${var.genesyscloud_flow_WORKFLOW_Accelerator__Set_User_Presence_on_Communicate_Call_filepath}"
}

resource "genesyscloud_flow" "INQUEUECALL_InQueue_-_Orbit_Call_Park_Hold" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INQUEUECALL_InQueue_-_Orbit_Call_Park_Hold_filepath)}"
  filepath          = "${var.genesyscloud_flow_INQUEUECALL_InQueue_-_Orbit_Call_Park_Hold_filepath}"
}

resource "genesyscloud_flow" "OUTBOUNDCALL_test_flow_f53e17ea-8c8d-4c42-94e2-1d03cd78ec50" {
  filepath          = "${var.genesyscloud_flow_OUTBOUNDCALL_test_flow_f53e17ea-8c8d-4c42-94e2-1d03cd78ec50_filepath}"
  file_content_hash = "${filesha256(var.genesyscloud_flow_OUTBOUNDCALL_test_flow_f53e17ea-8c8d-4c42-94e2-1d03cd78ec50_filepath)}"
}

resource "genesyscloud_flow" "OUTBOUNDCALL_test_flow_4bbe4f58-b2d4-4d05-b828-28bccfafec44" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_OUTBOUNDCALL_test_flow_4bbe4f58-b2d4-4d05-b828-28bccfafec44_filepath)}"
  filepath          = "${var.genesyscloud_flow_OUTBOUNDCALL_test_flow_4bbe4f58-b2d4-4d05-b828-28bccfafec44_filepath}"
}

resource "genesyscloud_flow" "INBOUNDSHORTMESSAGE_Agnes_Message_Flow" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDSHORTMESSAGE_Agnes_Message_Flow_filepath)}"
  filepath          = "${var.genesyscloud_flow_INBOUNDSHORTMESSAGE_Agnes_Message_Flow_filepath}"
}

resource "genesyscloud_flow" "WORKFLOW_Send_Email_on_Failed_WebMessage_Workflow" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_WORKFLOW_Send_Email_on_Failed_WebMessage_Workflow_filepath)}"
  filepath          = "${var.genesyscloud_flow_WORKFLOW_Send_Email_on_Failed_WebMessage_Workflow_filepath}"
}

resource "genesyscloud_flow" "WORKFLOW_Automated_Callback_-_Proactive_callback_workbin" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_WORKFLOW_Automated_Callback_-_Proactive_callback_workbin_filepath)}"
  filepath          = "${var.genesyscloud_flow_WORKFLOW_Automated_Callback_-_Proactive_callback_workbin_filepath}"
}

resource "genesyscloud_flow" "WORKFLOW_Accelerator__Set_User_Presence_After_Communicate_Call" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_WORKFLOW_Accelerator__Set_User_Presence_After_Communicate_Call_filepath)}"
  filepath          = "${var.genesyscloud_flow_WORKFLOW_Accelerator__Set_User_Presence_After_Communicate_Call_filepath}"
}

resource "genesyscloud_flow" "INBOUNDEMAIL_EmailAWSComprehendFlow" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDEMAIL_EmailAWSComprehendFlow_filepath)}"
  filepath          = "${var.genesyscloud_flow_INBOUNDEMAIL_EmailAWSComprehendFlow_filepath}"
}

resource "genesyscloud_flow" "WORKFLOW_test" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_WORKFLOW_test_filepath)}"
  filepath          = "${var.genesyscloud_flow_WORKFLOW_test_filepath}"
}

resource "genesyscloud_flow" "INQUEUECALL_Automated_Callback_-_In-Queue_Offer_Callback" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INQUEUECALL_Automated_Callback_-_In-Queue_Offer_Callback_filepath)}"
  filepath          = "${var.genesyscloud_flow_INQUEUECALL_Automated_Callback_-_In-Queue_Offer_Callback_filepath}"
}

resource "genesyscloud_flow" "BOT_web-messaging-quick-response-bot" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_BOT_web-messaging-quick-response-bot_filepath)}"
  filepath          = "${var.genesyscloud_flow_BOT_web-messaging-quick-response-bot_filepath}"
}

resource "genesyscloud_flow" "OUTBOUNDCALL_test_flow_de55c0d3-6360-4707-8b3b-c892d48b1ff5" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_OUTBOUNDCALL_test_flow_de55c0d3-6360-4707-8b3b-c892d48b1ff5_filepath)}"
  filepath          = "${var.genesyscloud_flow_OUTBOUNDCALL_test_flow_de55c0d3-6360-4707-8b3b-c892d48b1ff5_filepath}"
}

resource "genesyscloud_flow" "INBOUNDCALL_DR-Emergency-IVR" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDCALL_DR-Emergency-IVR_filepath)}"
  filepath          = "${var.genesyscloud_flow_INBOUNDCALL_DR-Emergency-IVR_filepath}"
}

resource "genesyscloud_flow" "INBOUNDCHAT_Agnes_Chat_Flow" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDCHAT_Agnes_Chat_Flow_filepath)}"
  filepath          = "${var.genesyscloud_flow_INBOUNDCHAT_Agnes_Chat_Flow_filepath}"
}

resource "genesyscloud_flow" "OUTBOUNDCALL_Automated_Callback_-_Dial_Caller" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_OUTBOUNDCALL_Automated_Callback_-_Dial_Caller_filepath)}"
  filepath          = "${var.genesyscloud_flow_OUTBOUNDCALL_Automated_Callback_-_Dial_Caller_filepath}"
}

resource "genesyscloud_flow" "OUTBOUNDCALL_test_flow_b4e20e3b-8508-4c11-8ba8-83bb48081437" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_OUTBOUNDCALL_test_flow_b4e20e3b-8508-4c11-8ba8-83bb48081437_filepath)}"
  filepath          = "${var.genesyscloud_flow_OUTBOUNDCALL_test_flow_b4e20e3b-8508-4c11-8ba8-83bb48081437_filepath}"
}

resource "genesyscloud_flow" "INBOUNDCALL_Terraform_Flow_Test_ForceUnlock-e1af1b1e-c80c-4c81-884c-7b1648813b42" {
  filepath          = "${var.genesyscloud_flow_INBOUNDCALL_Terraform_Flow_Test_ForceUnlock-e1af1b1e-c80c-4c81-884c-7b1648813b42_filepath}"
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDCALL_Terraform_Flow_Test_ForceUnlock-e1af1b1e-c80c-4c81-884c-7b1648813b42_filepath)}"
}

resource "genesyscloud_flow" "BOT_PrinceTest" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_BOT_PrinceTest_filepath)}"
  filepath          = "${var.genesyscloud_flow_BOT_PrinceTest_filepath}"
}

resource "genesyscloud_flow" "VOICEMAIL_Default_Voicemail_Flow" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_VOICEMAIL_Default_Voicemail_Flow_filepath)}"
  filepath          = "${var.genesyscloud_flow_VOICEMAIL_Default_Voicemail_Flow_filepath}"
}

resource "genesyscloud_flow" "INBOUNDCALL_Call_Park_Agent_-_Inbound_Flow" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDCALL_Call_Park_Agent_-_Inbound_Flow_filepath)}"
  filepath          = "${var.genesyscloud_flow_INBOUNDCALL_Call_Park_Agent_-_Inbound_Flow_filepath}"
}

resource "genesyscloud_flow" "OUTBOUNDCALL_test_flow_0b3d214e-561f-4454-b928-9341ced0bbc5" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_OUTBOUNDCALL_test_flow_0b3d214e-561f-4454-b928-9341ced0bbc5_filepath)}"
  filepath          = "${var.genesyscloud_flow_OUTBOUNDCALL_test_flow_0b3d214e-561f-4454-b928-9341ced0bbc5_filepath}"
}

resource "genesyscloud_flow" "OUTBOUNDCALL_test_flow_a4538e6f-e1d9-4678-aebe-34158959b26d" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_OUTBOUNDCALL_test_flow_a4538e6f-e1d9-4678-aebe-34158959b26d_filepath)}"
  filepath          = "${var.genesyscloud_flow_OUTBOUNDCALL_test_flow_a4538e6f-e1d9-4678-aebe-34158959b26d_filepath}"
}

resource "genesyscloud_flow" "INBOUNDCALL_DR-Fallback-IVR" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDCALL_DR-Fallback-IVR_filepath)}"
  filepath          = "${var.genesyscloud_flow_INBOUNDCALL_DR-Fallback-IVR_filepath}"
}

resource "genesyscloud_flow" "INQUEUECALL_Default_In-Queue_Flow" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INQUEUECALL_Default_In-Queue_Flow_filepath)}"
  filepath          = "${var.genesyscloud_flow_INQUEUECALL_Default_In-Queue_Flow_filepath}"
}

resource "genesyscloud_flow" "INBOUNDCALL_Prince_Sample" {
  filepath          = "${var.genesyscloud_flow_INBOUNDCALL_Prince_Sample_filepath}"
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDCALL_Prince_Sample_filepath)}"
}

resource "genesyscloud_flow" "INBOUNDCALL_SimpleFinancialIvr" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDCALL_SimpleFinancialIvr_filepath)}"
  filepath          = "${var.genesyscloud_flow_INBOUNDCALL_SimpleFinancialIvr_filepath}"
}

resource "genesyscloud_flow" "INBOUNDSHORTMESSAGE_web-messaging-triage-bot-flow" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDSHORTMESSAGE_web-messaging-triage-bot-flow_filepath)}"
  filepath          = "${var.genesyscloud_flow_INBOUNDSHORTMESSAGE_web-messaging-triage-bot-flow_filepath}"
}

resource "genesyscloud_flow" "OUTBOUNDCALL_test_flow_f2475d5d-8e47-4cf9-b00b-5b384f42ce8b" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_OUTBOUNDCALL_test_flow_f2475d5d-8e47-4cf9-b00b-5b384f42ce8b_filepath)}"
  filepath          = "${var.genesyscloud_flow_OUTBOUNDCALL_test_flow_f2475d5d-8e47-4cf9-b00b-5b384f42ce8b_filepath}"
}

resource "genesyscloud_flow" "OUTBOUNDCALL_test_flow_424ee5a4-a389-4721-ae60-38ca6f576c33" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_OUTBOUNDCALL_test_flow_424ee5a4-a389-4721-ae60-38ca6f576c33_filepath)}"
  filepath          = "${var.genesyscloud_flow_OUTBOUNDCALL_test_flow_424ee5a4-a389-4721-ae60-38ca6f576c33_filepath}"
}

resource "genesyscloud_flow" "INBOUNDCALL_Orbit_-_Parked_Call_Retrieval" {
  filepath          = "${var.genesyscloud_flow_INBOUNDCALL_Orbit_-_Parked_Call_Retrieval_filepath}"
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDCALL_Orbit_-_Parked_Call_Retrieval_filepath)}"
}

resource "genesyscloud_flow" "INBOUNDCALL_Automated_Callback_-_Trigger_proactive_callback_workflow" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDCALL_Automated_Callback_-_Trigger_proactive_callback_workflow_filepath)}"
  filepath          = "${var.genesyscloud_flow_INBOUNDCALL_Automated_Callback_-_Trigger_proactive_callback_workflow_filepath}"
}

resource "genesyscloud_flow" "INBOUNDSHORTMESSAGE_MyWebMessenger-Fallback" {
  file_content_hash = "${filesha256(var.genesyscloud_flow_INBOUNDSHORTMESSAGE_MyWebMessenger-Fallback_filepath)}"
  filepath          = "${var.genesyscloud_flow_INBOUNDSHORTMESSAGE_MyWebMessenger-Fallback_filepath}"
}

resource "genesyscloud_outbound_callanalysisresponseset" "test_carb149eb0d-be73-4d05-9ddf-5d90773a60bd" {
  beep_detection_enabled = false
  name                   = "test carb149eb0d-be73-4d05-9ddf-5d90773a60bd"
  responses {
    uncallable_sit {
      reaction_type = "hangup"
    }
    callable_busy {
      reaction_type = "hangup"
    }
    callable_noanswer {
      reaction_type = "hangup"
    }
    callable_person {
      reaction_type = "transfer_flow"
      data          = "${genesyscloud_flow.OUTBOUNDCALL_test_flow_b4e20e3b-8508-4c11-8ba8-83bb48081437.id}"
      name          = "test flow b4e20e3b-8508-4c11-8ba8-83bb48081437"
    }
    callable_sit {
      reaction_type = "hangup"
    }
    uncallable_notfound {
      reaction_type = "hangup"
    }
    callable_disconnect {
      reaction_type = "hangup"
    }
    callable_fax {
      reaction_type = "hangup"
    }
    callable_machine {
      reaction_type = "hangup"
    }
  }
}

resource "genesyscloud_outbound_callanalysisresponseset" "tf_test_car_bd0934c2-bc6a-43ba-9ab2-fc716f5d0076" {
  name = "tf test car bd0934c2-bc6a-43ba-9ab2-fc716f5d0076"
  responses {
    callable_disconnect {
      reaction_type = "hangup"
    }
    callable_fax {
      reaction_type = "hangup"
    }
    callable_noanswer {
      reaction_type = "hangup"
    }
    callable_person {
      data          = "${genesyscloud_flow.OUTBOUNDCALL_test_flow_f2475d5d-8e47-4cf9-b00b-5b384f42ce8b.id}"
      name          = "test flow f2475d5d-8e47-4cf9-b00b-5b384f42ce8b"
      reaction_type = "transfer_flow"
    }
    uncallable_sit {
      reaction_type = "hangup"
    }
    callable_busy {
      reaction_type = "hangup"
    }
    callable_machine {
      reaction_type = "hangup"
    }
    callable_sit {
      reaction_type = "hangup"
    }
    uncallable_notfound {
      reaction_type = "hangup"
    }
  }
  beep_detection_enabled = false
}

resource "genesyscloud_outbound_callanalysisresponseset" "tf_test_car_5048a3ad-826a-475c-b557-f9680b8bfd75" {
  beep_detection_enabled = false
  name                   = "tf test car 5048a3ad-826a-475c-b557-f9680b8bfd75"
  responses {
    uncallable_notfound {
      reaction_type = "hangup"
    }
    callable_fax {
      reaction_type = "hangup"
    }
    callable_person {
      name          = "test flow a4538e6f-e1d9-4678-aebe-34158959b26d"
      reaction_type = "transfer_flow"
      data          = "${genesyscloud_flow.OUTBOUNDCALL_test_flow_a4538e6f-e1d9-4678-aebe-34158959b26d.id}"
    }
    callable_sit {
      reaction_type = "hangup"
    }
    callable_machine {
      reaction_type = "hangup"
    }
    callable_noanswer {
      reaction_type = "hangup"
    }
    uncallable_sit {
      reaction_type = "hangup"
    }
    callable_busy {
      reaction_type = "hangup"
    }
    callable_disconnect {
      reaction_type = "hangup"
    }
  }
}

resource "genesyscloud_outbound_callanalysisresponseset" "tf_car_66865afc-b9f7-4977-9209-156343916636" {
  beep_detection_enabled = false
  name                   = "tf car 66865afc-b9f7-4977-9209-156343916636"
  responses {
    callable_person {
      name          = "test flow 4bbe4f58-b2d4-4d05-b828-28bccfafec44"
      reaction_type = "transfer_flow"
      data          = "${genesyscloud_flow.OUTBOUNDCALL_test_flow_4bbe4f58-b2d4-4d05-b828-28bccfafec44.id}"
    }
    callable_sit {
      reaction_type = "hangup"
    }
    uncallable_notfound {
      reaction_type = "hangup"
    }
    uncallable_sit {
      reaction_type = "hangup"
    }
    callable_fax {
      reaction_type = "hangup"
    }
    callable_machine {
      reaction_type = "hangup"
    }
    callable_noanswer {
      reaction_type = "hangup"
    }
    callable_busy {
      reaction_type = "hangup"
    }
    callable_disconnect {
      reaction_type = "hangup"
    }
  }
}

resource "genesyscloud_outbound_callanalysisresponseset" "test_car59fedb5e-ad92-40bb-92ab-784e46c2c0f3" {
  name = "test car59fedb5e-ad92-40bb-92ab-784e46c2c0f3"
  responses {
    callable_fax {
      reaction_type = "hangup"
    }
    callable_machine {
      reaction_type = "hangup"
    }
    callable_sit {
      reaction_type = "hangup"
    }
    uncallable_notfound {
      reaction_type = "hangup"
    }
    uncallable_sit {
      reaction_type = "hangup"
    }
    callable_busy {
      reaction_type = "hangup"
    }
    callable_disconnect {
      reaction_type = "hangup"
    }
    callable_noanswer {
      reaction_type = "hangup"
    }
    callable_person {
      data          = "${genesyscloud_flow.OUTBOUNDCALL_test_flow_de55c0d3-6360-4707-8b3b-c892d48b1ff5.id}"
      name          = "test flow de55c0d3-6360-4707-8b3b-c892d48b1ff5"
      reaction_type = "transfer_flow"
    }
  }
  beep_detection_enabled = false
}

resource "genesyscloud_outbound_callanalysisresponseset" "Automated_Callbacks_CAR" {
  beep_detection_enabled = false
  name                   = "Automated Callbacks CAR"
  responses {
    callable_busy {
      reaction_type = "hangup"
    }
    callable_noanswer {
      reaction_type = "hangup"
    }
    uncallable_sit {
      reaction_type = "hangup"
    }
    callable_sit {
      reaction_type = "hangup"
    }
    uncallable_notfound {
      reaction_type = "hangup"
    }
    callable_disconnect {
      reaction_type = "hangup"
    }
    callable_fax {
      reaction_type = "hangup"
    }
    callable_machine {
      reaction_type = "hangup"
    }
    callable_person {
      data          = "${genesyscloud_flow.OUTBOUNDCALL_Automated_Callback_-_Dial_Caller.id}"
      name          = "Automated Callback - Dial Caller"
      reaction_type = "transfer_flow"
    }
  }
}

resource "genesyscloud_outbound_callanalysisresponseset" "test_car308c46c9-fdf4-4bb6-a32e-00870b539dfb" {
  beep_detection_enabled = false
  name                   = "test car308c46c9-fdf4-4bb6-a32e-00870b539dfb"
  responses {
    callable_busy {
      reaction_type = "hangup"
    }
    callable_disconnect {
      reaction_type = "hangup"
    }
    callable_fax {
      reaction_type = "hangup"
    }
    callable_machine {
      reaction_type = "hangup"
    }
    callable_noanswer {
      reaction_type = "hangup"
    }
    uncallable_notfound {
      reaction_type = "hangup"
    }
    callable_person {
      data          = "${genesyscloud_flow.OUTBOUNDCALL_test_flow_f53e17ea-8c8d-4c42-94e2-1d03cd78ec50.id}"
      name          = "test flow f53e17ea-8c8d-4c42-94e2-1d03cd78ec50"
      reaction_type = "transfer_flow"
    }
    callable_sit {
      reaction_type = "hangup"
    }
    uncallable_sit {
      reaction_type = "hangup"
    }
  }
}

resource "genesyscloud_outbound_callanalysisresponseset" "Default_Response_Set" {
  beep_detection_enabled = false
  name                   = "Default Response Set"
  responses {
    callable_machine {
      reaction_type = "hangup"
    }
    callable_noanswer {
      reaction_type = "hangup"
    }
    callable_person {
      reaction_type = "transfer"
    }
    uncallable_notfound {
      reaction_type = "hangup"
    }
    callable_busy {
      reaction_type = "hangup"
    }
    callable_fax {
      reaction_type = "hangup"
    }
    callable_sit {
      reaction_type = "hangup"
    }
    uncallable_sit {
      reaction_type = "hangup"
    }
    callable_disconnect {
      reaction_type = "hangup"
    }
  }
}

resource "genesyscloud_outbound_callanalysisresponseset" "test_car3c66b1fc-ded8-48f9-8988-aa58dc79e4b6" {
  name = "test car3c66b1fc-ded8-48f9-8988-aa58dc79e4b6"
  responses {
    callable_sit {
      reaction_type = "hangup"
    }
    uncallable_sit {
      reaction_type = "hangup"
    }
    callable_person {
      data          = "${genesyscloud_flow.OUTBOUNDCALL_test_flow_424ee5a4-a389-4721-ae60-38ca6f576c33.id}"
      name          = "test flow 424ee5a4-a389-4721-ae60-38ca6f576c33"
      reaction_type = "transfer_flow"
    }
    uncallable_notfound {
      reaction_type = "hangup"
    }
    callable_busy {
      reaction_type = "hangup"
    }
    callable_disconnect {
      reaction_type = "hangup"
    }
    callable_fax {
      reaction_type = "hangup"
    }
    callable_machine {
      reaction_type = "hangup"
    }
    callable_noanswer {
      reaction_type = "hangup"
    }
  }
  beep_detection_enabled = false
}

resource "genesyscloud_outbound_callanalysisresponseset" "tf_car_4022ee5e-c9be-4391-9082-da80a09dc8f1" {
  beep_detection_enabled = false
  name                   = "tf car 4022ee5e-c9be-4391-9082-da80a09dc8f1"
  responses {
    callable_person {
      name          = "test flow 0b3d214e-561f-4454-b928-9341ced0bbc5"
      reaction_type = "transfer_flow"
      data          = "${genesyscloud_flow.OUTBOUNDCALL_test_flow_0b3d214e-561f-4454-b928-9341ced0bbc5.id}"
    }
    callable_sit {
      reaction_type = "hangup"
    }
    uncallable_notfound {
      reaction_type = "hangup"
    }
    uncallable_sit {
      reaction_type = "hangup"
    }
    callable_machine {
      reaction_type = "hangup"
    }
    callable_noanswer {
      reaction_type = "hangup"
    }
    callable_busy {
      reaction_type = "hangup"
    }
    callable_disconnect {
      reaction_type = "hangup"
    }
    callable_fax {
      reaction_type = "hangup"
    }
  }
}

resource "genesyscloud_group_roles" "Prince_Group" {
}

resource "genesyscloud_group_roles" "Prince_Test" {
}

resource "genesyscloud_group_roles" "Agnes_Group" {
}

resource "genesyscloud_group_roles" "DR_WebMessaging_Emergency_Group" {
}

resource "genesyscloud_group_roles" "MySpecialGroup" {
}

resource "genesyscloud_group_roles" "DevCast" {
}

resource "genesyscloud_group_roles" "Emergency_Group" {
}

resource "genesyscloud_routing_email_domain" "devengagetest_pure_cloud" {
  custom_smtp_server_id = "${var.genesyscloud_routing_email_domain_devengagetest_pure_cloud_custom_smtp_server_id}"
  domain_id             = "devengagetest"
  subdomain             = true
}

resource "genesyscloud_routing_email_domain" "mysillydomain123_pure_cloud" {
  custom_smtp_server_id = "${var.genesyscloud_routing_email_domain_mysillydomain123_pure_cloud_custom_smtp_server_id}"
  domain_id             = "mysillydomain123"
  subdomain             = true
}

resource "genesyscloud_routing_skill" "Bundles" {
  name = "Bundles"
}

resource "genesyscloud_routing_skill" "Farming" {
  name = "Farming"
}

resource "genesyscloud_routing_skill" "Fishing" {
  name = "Fishing"
}

resource "genesyscloud_outbound_ruleset" "tf_ruleset_8eedd372-bfc6-4678-b133-093736c03dff" {
  name = "tf ruleset 8eedd372-bfc6-4678-b133-093736c03dff"
}

resource "genesyscloud_routing_settings" "routing_settings" {
  contactcenter {
    remove_skills_from_blind_transfer = false
  }
  reset_agent_on_presence_change = false
  transcription {
    transcription_confidence_threshold = 1
    content_search_enabled             = false
    low_latency_transcription_enabled  = true
    transcription                      = "EnabledQueueFlow"
  }
}

resource "genesyscloud_knowledge_category" "Pokemon_Creatures" {
  knowledge_base_id = "${genesyscloud_knowledge_knowledgebase.Prince_Pokedex.id}"
  knowledge_category {
    name = "Pokemon Creatures"
  }
}

resource "genesyscloud_routing_language" "en-us" {
  name = "en-us"
}

resource "genesyscloud_routing_language" "Filipino" {
  name = "Filipino"
}

resource "genesyscloud_architect_ivr" "Configuration_IVR" {
  name               = "Configuration IVR"
  division_id        = "${genesyscloud_auth_division.New_Home.id}"
  dnis               = ["+19204458274"]
  description        = "An example fallback IVR"
  open_hours_flow_id = "${genesyscloud_flow.INBOUNDCALL_DR-Fallback-IVR.id}"
}

resource "genesyscloud_architect_ivr" "An_IVR_for_Dave_s_Flows" {
  description        = "An IVR for Dave's Flows"
  dnis               = ["+14143017328"]
  division_id        = "${genesyscloud_auth_division.New_Home.id}"
  name               = "An IVR for Dave's Flows"
  open_hours_flow_id = "${genesyscloud_flow.INBOUNDCALL_Dave_-_SFDC_Service_-_Basic.id}"
}

resource "genesyscloud_architect_ivr" "A_simple_IVR" {
  description        = "A sample IVR configuration"
  division_id        = "${genesyscloud_auth_division.New_Home.id}"
  name               = "A simple IVR"
  dnis               = ["+13455550000"]
  open_hours_flow_id = "${genesyscloud_flow.INBOUNDCALL_SimpleFinancialIvr.id}"
}

resource "genesyscloud_architect_ivr" "Call_Parking_Inbound_Agent_Flow" {
  division_id        = "${genesyscloud_auth_division.New_Home.id}"
  dnis               = ["+14632581174"]
  name               = "Call Parking Inbound Agent Flow"
  open_hours_flow_id = "${genesyscloud_flow.INBOUNDCALL_Call_Park_Agent_-_Inbound_Flow.id}"
}

resource "genesyscloud_architect_ivr" "Orbit_-_Parked_Call_Retrieval" {
  dnis               = ["+19203193561"]
  name               = "Orbit - Parked Call Retrieval"
  open_hours_flow_id = "${genesyscloud_flow.INBOUNDCALL_Orbit_-_Parked_Call_Retrieval.id}"
  division_id        = "${genesyscloud_auth_division.New_Home.id}"
}

resource "genesyscloud_routing_email_route" "supportdevengagetest_pure_cloud" {
  from_name  = "Financial Services Support"
  flow_id    = "${genesyscloud_flow.INBOUNDEMAIL_EmailAWSComprehendFlow.id}"
  from_email = "support@devengagetest.pure.cloud"
  pattern    = "support"
  domain_id  = "${genesyscloud_routing_email_domain.devengagetest_pure_cloud.id}"
}

resource "genesyscloud_auth_division" "New_Home" {
  description = "Home Division"
  home        = true
  name        = "New Home"
}

resource "genesyscloud_auth_division" "StarDewvision" {
  description = "For testing purposes by Prince Merluza"
  home        = false
  name        = "StarDewvision"
}

resource "genesyscloud_auth_division" "Dave-DIV" {
  home = false
  name = "Dave-DIV"
}

resource "genesyscloud_routing_wrapupcode" "Message_Processed" {
  name = "Message Processed"
}

resource "genesyscloud_routing_wrapupcode" "TestWrapup" {
  name = "TestWrapup"
}

resource "genesyscloud_routing_wrapupcode" "test_wrapup_code_bb4b5ba9-1bd2-4ba6-af63-960ebef6e732" {
  name = "test wrapup code bb4b5ba9-1bd2-4ba6-af63-960ebef6e732"
}

resource "genesyscloud_routing_wrapupcode" "tf_test_wrapupcode49fe8542-5c5e-418f-bae8-413df61eb5e3" {
  name = "tf test wrapupcode49fe8542-5c5e-418f-bae8-413df61eb5e3"
}

resource "genesyscloud_routing_wrapupcode" "test_wrapup_code_1a36f3b8-9236-466c-80af-4f906a739269" {
  name = "test wrapup code 1a36f3b8-9236-466c-80af-4f906a739269"
}

resource "genesyscloud_routing_wrapupcode" "Prince1" {
  name = "Prince1"
}

resource "genesyscloud_routing_wrapupcode" "tf_test_wrapupcode7f596714-7a45-430d-ad77-ed612d96498b" {
  name = "tf test wrapupcode7f596714-7a45-430d-ad77-ed612d96498b"
}

resource "genesyscloud_routing_wrapupcode" "tf_test_wrapupcode4b988845-4bf8-40f0-872f-d7b89ec3a257" {
  name = "tf test wrapupcode4b988845-4bf8-40f0-872f-d7b89ec3a257"
}

resource "genesyscloud_routing_wrapupcode" "wrapupcode_da441439-615c-43f2-91a7-f691f814136e" {
  name = "wrapupcode da441439-615c-43f2-91a7-f691f814136e"
}

resource "genesyscloud_routing_wrapupcode" "tf_test_wrapupcodea5644ec8-ef61-462f-81b1-0699495f4e79" {
  name = "tf test wrapupcodea5644ec8-ef61-462f-81b1-0699495f4e79"
}

resource "genesyscloud_routing_wrapupcode" "Message_Resolved" {
  name = "Message Resolved"
}

resource "genesyscloud_routing_wrapupcode" "test_wrapup_code_30503d78-104b-48f6-8aaa-8df2ad04fb41" {
  name = "test wrapup code 30503d78-104b-48f6-8aaa-8df2ad04fb41"
}

resource "genesyscloud_routing_wrapupcode" "Prince2" {
  name = "Prince2"
}

resource "genesyscloud_routing_wrapupcode" "test_wrapup_code_37994015-ab2d-4733-9c69-2aaa59d4c7a4" {
  name = "test wrapup code 37994015-ab2d-4733-9c69-2aaa59d4c7a4"
}

resource "genesyscloud_routing_wrapupcode" "wrapupcode_e498f406-baed-436b-b118-79c2d02248f3" {
  name = "wrapupcode e498f406-baed-436b-b118-79c2d02248f3"
}

resource "genesyscloud_routing_wrapupcode" "tf_test_wrapupcodea5fc6461-d63d-4bcd-b35e-2cf30c4ada01" {
  name = "tf test wrapupcodea5fc6461-d63d-4bcd-b35e-2cf30c4ada01"
}

resource "genesyscloud_routing_wrapupcode" "tf_wrapup_code7ba2516e-c3dd-4488-b46e-43bd64bdeb36" {
  name = "tf wrapup code7ba2516e-c3dd-4488-b46e-43bd64bdeb36"
}

resource "genesyscloud_routing_wrapupcode" "tf_wrapup_coded103d6d6-ae1c-480d-bda6-549285cde67c" {
  name = "tf wrapup coded103d6d6-ae1c-480d-bda6-549285cde67c"
}

resource "genesyscloud_routing_wrapupcode" "wrapupcode_69d6bf44-9aa9-46ef-917c-61b5bc610959" {
  name = "wrapupcode 69d6bf44-9aa9-46ef-917c-61b5bc610959"
}

resource "genesyscloud_routing_queue" "Create_2023_Queue_a3c4f43a-ff45-4b1d-8fa4-97ffcb9c7410" {
  division_id          = "${genesyscloud_auth_division.New_Home.id}"
  enable_transcription = true
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  auto_answer_only  = false
  acw_wrapup_prompt = "OPTIONAL"
  media_settings_message {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_email {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
  }
  calling_party_name       = "Example Inc."
  enable_manual_assignment = false
  skill_evaluation_method  = "ALL"
  media_settings_callback {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  scoring_method                   = "TimestampAndPriority"
  suppress_in_queue_call_recording = true
  name                             = "Create 2023 Queue a3c4f43a-ff45-4b1d-8fa4-97ffcb9c7410"
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
  }
}

resource "genesyscloud_routing_queue" "tutor-web-messaging-queue" {
  media_settings_call {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  media_settings_chat {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  name                 = "tutor-web-messaging-queue"
  enable_transcription = false
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_email {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
  }
  acw_wrapup_prompt        = "OPTIONAL"
  auto_answer_only         = false
  scoring_method           = "TimestampAndPriority"
  enable_manual_assignment = false
  media_settings_message {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  skill_evaluation_method          = "ALL"
  suppress_in_queue_call_recording = true
  division_id                      = "${genesyscloud_auth_division.New_Home.id}"
}

resource "genesyscloud_routing_queue" "tf_queue_f845976a-7272-4fc8-8047-fa81d4bf1a71" {
  media_settings_chat {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  media_settings_callback {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  media_settings_email {
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
  }
  acw_wrapup_prompt = "MANDATORY_TIMEOUT"
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
  }
  media_settings_message {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  suppress_in_queue_call_recording = true
  scoring_method                   = "TimestampAndPriority"
  skill_evaluation_method          = "ALL"
  auto_answer_only                 = true
  division_id                      = "${genesyscloud_auth_division.New_Home.id}"
  enable_manual_assignment         = false
  enable_transcription             = false
  name                             = "tf_queue_f845976a-7272-4fc8-8047-fa81d4bf1a71"
}

resource "genesyscloud_routing_queue" "Simple_Financial_401K_queue" {
  description = "Simple Financial 401K questions and answers. Used by the Simple IVR Deploy accelerator"
  media_settings_call {
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  suppress_in_queue_call_recording = true
  enable_manual_assignment         = true
  enable_transcription             = true
  media_settings_message {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  skill_evaluation_method = "BEST"
  division_id             = "${genesyscloud_auth_division.New_Home.id}"
  media_settings_email {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
  }
  scoring_method   = "TimestampAndPriority"
  auto_answer_only = true
  media_settings_callback {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  name              = "Simple Financial 401K queue"
  acw_wrapup_prompt = "MANDATORY_TIMEOUT"
  acw_timeout_ms    = 300000
  media_settings_chat {
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
  }
}

resource "genesyscloud_routing_queue" "_529" {
  suppress_in_queue_call_recording = true
  media_settings_email {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
  }
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
  }
  enable_manual_assignment = true
  enable_transcription     = true
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_message {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  acw_timeout_ms          = 300000
  acw_wrapup_prompt       = "MANDATORY_TIMEOUT"
  auto_answer_only        = true
  scoring_method          = "TimestampAndPriority"
  skill_evaluation_method = "BEST"
  media_settings_callback {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  name        = "529"
  description = "529 questions and answers"
  division_id = "${genesyscloud_auth_division.New_Home.id}"
}

resource "genesyscloud_routing_queue" "General_Help" {
  suppress_in_queue_call_recording = false
  auto_answer_only                 = true
  media_settings_email {
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
  }
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 10000
    service_level_percentage  = 0.7
    alerting_timeout_sec      = 30
  }
  description              = "General Help Queue"
  enable_transcription     = true
  enable_manual_assignment = true
  acw_timeout_ms           = 300000
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_message {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  skill_evaluation_method = "BEST"
  media_settings_chat {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  name = "General Help"
  routing_rules {
    operator     = "MEETS_THRESHOLD"
    threshold    = 9
    wait_seconds = 300
  }
  acw_wrapup_prompt = "MANDATORY_TIMEOUT"
  division_id       = "${genesyscloud_auth_division.New_Home.id}"
  scoring_method    = "TimestampAndPriority"
}

resource "genesyscloud_routing_queue" "tf_queue_5ef5cb76-ad81-4050-bf47-862499cd8d92" {
  enable_manual_assignment = false
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_message {
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
  }
  scoring_method = "TimestampAndPriority"
  division_id    = "${genesyscloud_auth_division.New_Home.id}"
  media_settings_email {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
  }
  name = "tf_queue_5ef5cb76-ad81-4050-bf47-862499cd8d92"
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
  }
  media_settings_callback {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  auto_answer_only                 = true
  skill_evaluation_method          = "ALL"
  acw_wrapup_prompt                = "MANDATORY_TIMEOUT"
  enable_transcription             = false
  suppress_in_queue_call_recording = true
}

resource "genesyscloud_routing_queue" "PremiumSupport2" {
  division_id = "${genesyscloud_auth_division.New_Home.id}"
  media_settings_email {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
  }
  enable_transcription     = true
  auto_answer_only         = true
  enable_manual_assignment = true
  media_settings_message {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  name = "PremiumSupport2"
  media_settings_chat {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  scoring_method = "TimestampAndPriority"
  acw_timeout_ms = 300000
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
  }
  suppress_in_queue_call_recording = true
  acw_wrapup_prompt                = "MANDATORY_TIMEOUT"
  description                      = "PremiumSupport2 questions and answers"
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  skill_evaluation_method = "BEST"
}

resource "genesyscloud_routing_queue" "General_Sales" {
  media_settings_callback {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  scoring_method = "TimestampAndPriority"
  media_settings_email {
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
  }
  media_settings_message {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  acw_wrapup_prompt        = "OPTIONAL"
  name                     = "General Sales"
  auto_answer_only         = false
  enable_manual_assignment = false
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
  }
  suppress_in_queue_call_recording = true
  enable_transcription             = false
  division_id                      = "${genesyscloud_auth_division.New_Home.id}"
  skill_evaluation_method          = "ALL"
}

resource "genesyscloud_routing_queue" "mychat-general-help" {
  acw_wrapup_prompt        = "MANDATORY_TIMEOUT"
  enable_manual_assignment = true
  enable_transcription     = true
  media_settings_chat {
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
  }
  division_id    = "${genesyscloud_auth_division.New_Home.id}"
  name           = "mychat-general-help"
  acw_timeout_ms = 300000
  routing_rules {
    operator     = "MEETS_THRESHOLD"
    threshold    = 9
    wait_seconds = 300
  }
  description             = "General Help Queue"
  skill_evaluation_method = "BEST"
  media_settings_call {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 10000
    service_level_percentage  = 0.7
  }
  media_settings_message {
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
  }
  scoring_method                   = "TimestampAndPriority"
  suppress_in_queue_call_recording = false
  media_settings_email {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
  }
  auto_answer_only = true
  media_settings_callback {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
}

resource "genesyscloud_routing_queue" "Simple_Financial_IRA_queue" {
  enable_transcription    = true
  skill_evaluation_method = "BEST"
  acw_timeout_ms          = 300000
  media_settings_callback {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  division_id                      = "${genesyscloud_auth_division.New_Home.id}"
  suppress_in_queue_call_recording = true
  enable_manual_assignment         = true
  scoring_method                   = "TimestampAndPriority"
  auto_answer_only                 = true
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
  }
  media_settings_email {
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  name              = "Simple Financial IRA queue"
  acw_wrapup_prompt = "MANDATORY_TIMEOUT"
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_message {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  description = "Simple Financial IRA questions and answers. Used by the Simple IVR Deploy accelerator"
}

resource "genesyscloud_routing_queue" "Terraform_Test_Queue-c08ab5c2-a612-48f3-8e11-2b5dce80eec4" {
  enable_transcription = false
  media_settings_call {
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  media_settings_email {
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
  }
  description = "This is a test"
  media_settings_callback {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  acw_timeout_ms           = 200000
  auto_answer_only         = true
  name                     = "Terraform Test Queue-c08ab5c2-a612-48f3-8e11-2b5dce80eec4"
  scoring_method           = "TimestampAndPriority"
  skill_evaluation_method  = "ALL"
  enable_manual_assignment = false
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  acw_wrapup_prompt = "MANDATORY_TIMEOUT"
  division_id       = "${genesyscloud_auth_division.New_Home.id}"
  media_settings_message {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  suppress_in_queue_call_recording = true
}

resource "genesyscloud_routing_queue" "Call_Park_Agent_Inbound_Queue" {
  enable_transcription     = false
  acw_wrapup_prompt        = "OPTIONAL"
  enable_manual_assignment = false
  media_settings_message {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  media_settings_chat {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  auto_answer_only = false
  default_script_ids = {
    CALL = "${genesyscloud_script.Orbit_Queue_Transfer_July_2024.id}"
  }
  division_id                      = "${genesyscloud_auth_division.New_Home.id}"
  name                             = "Call Park Agent Inbound Queue"
  skill_evaluation_method          = "ALL"
  suppress_in_queue_call_recording = true
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
  }
  scoring_method = "TimestampAndPriority"
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_email {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
  }
}

resource "genesyscloud_routing_queue" "PrinceWorkbin" {
  media_settings_chat {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
  }
  media_settings_email {
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
  }
  acw_wrapup_prompt                = "MANDATORY_TIMEOUT"
  enable_transcription             = false
  skill_evaluation_method          = "ALL"
  name                             = "PrinceWorkbin"
  suppress_in_queue_call_recording = true
  auto_answer_only                 = true
  media_settings_message {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  description              = "Created for Accelerator (Automate Callbacks). This queue will hold the callbacks."
  division_id              = "${genesyscloud_auth_division.New_Home.id}"
  enable_manual_assignment = false
  scoring_method           = "TimestampAndPriority"
}

resource "genesyscloud_routing_queue" "tf_queue_ecc9c9fd-62c2-4abf-b13b-2f488624ad11" {
  enable_manual_assignment = false
  enable_transcription     = false
  scoring_method           = "TimestampAndPriority"
  auto_answer_only         = true
  division_id              = "${genesyscloud_auth_division.New_Home.id}"
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  name                             = "tf_queue_ecc9c9fd-62c2-4abf-b13b-2f488624ad11"
  suppress_in_queue_call_recording = true
  media_settings_email {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
  }
  media_settings_message {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  skill_evaluation_method = "ALL"
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
  }
  acw_wrapup_prompt = "MANDATORY_TIMEOUT"
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
}

resource "genesyscloud_routing_queue" "web-messaging-triage-bot-queue" {
  media_settings_message {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  division_id                      = "${genesyscloud_auth_division.New_Home.id}"
  enable_transcription             = false
  suppress_in_queue_call_recording = true
  enable_manual_assignment         = false
  media_settings_callback {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  skill_evaluation_method = "ALL"
  acw_wrapup_prompt       = "MANDATORY_TIMEOUT"
  media_settings_call {
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  media_settings_chat {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  name             = "web-messaging-triage-bot-queue"
  scoring_method   = "TimestampAndPriority"
  wrapup_codes     = ["${genesyscloud_routing_wrapupcode.Message_Resolved.id}", "${genesyscloud_routing_wrapupcode.Message_Processed.id}"]
  auto_answer_only = true
  media_settings_email {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
  }
}

resource "genesyscloud_routing_queue" "General_Service" {
  division_id      = "${genesyscloud_auth_division.New_Home.id}"
  auto_answer_only = false
  media_settings_message {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_call {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  media_settings_callback {
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
  }
  scoring_method                   = "TimestampAndPriority"
  skill_evaluation_method          = "ALL"
  suppress_in_queue_call_recording = true
  media_settings_chat {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  name                     = "General Service"
  enable_manual_assignment = false
  enable_transcription     = false
  media_settings_email {
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
  }
  acw_wrapup_prompt = "OPTIONAL"
}

resource "genesyscloud_routing_queue" "_24K" {
  division_id          = "${genesyscloud_auth_division.New_Home.id}"
  name                 = "24K"
  enable_transcription = false
  media_settings_email {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
  }
  media_settings_message {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  suppress_in_queue_call_recording = true
  acw_wrapup_prompt                = "OPTIONAL"
  media_settings_call {
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  media_settings_callback {
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
  }
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  enable_manual_assignment = false
  scoring_method           = "TimestampAndPriority"
  auto_answer_only         = false
  skill_evaluation_method  = "ALL"
}

resource "genesyscloud_routing_queue" "IRA" {
  scoring_method                   = "TimestampAndPriority"
  skill_evaluation_method          = "BEST"
  suppress_in_queue_call_recording = true
  enable_transcription             = true
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_call {
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  media_settings_message {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  name                     = "IRA"
  description              = "IRA questions and answers"
  acw_wrapup_prompt        = "MANDATORY_TIMEOUT"
  division_id              = "${genesyscloud_auth_division.New_Home.id}"
  enable_manual_assignment = true
  acw_timeout_ms           = 300000
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  auto_answer_only = true
  media_settings_email {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
  }
}

resource "genesyscloud_routing_queue" "Orbit" {
  enable_manual_assignment = false
  scoring_method           = "TimestampAndPriority"
  media_settings_chat {
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
  }
  name                             = "Orbit"
  queue_flow_id                    = "${genesyscloud_flow.INQUEUECALL_InQueue_-_Orbit_Call_Park_Hold.id}"
  division_id                      = "${genesyscloud_auth_division.New_Home.id}"
  enable_transcription             = false
  suppress_in_queue_call_recording = false
  default_script_ids = {
    CALL = "${genesyscloud_script.Orbit_Queue_Transfer_July_2024.id}"
  }
  media_settings_call {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  media_settings_email {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
  }
  media_settings_message {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  acw_wrapup_prompt    = "OPTIONAL"
  calling_party_number = "+19203193561"
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  skill_evaluation_method = "ALL"
  auto_answer_only        = true
}

resource "genesyscloud_routing_queue" "tyler_Bath_s_queue" {
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
  }
  media_settings_message {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  auto_answer_only        = false
  skill_evaluation_method = "ALL"
  enable_transcription    = true
  media_settings_email {
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  name                     = "tyler Bath's queue"
  calling_party_name       = "Hi John"
  enable_manual_assignment = false
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_chat {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  suppress_in_queue_call_recording = true
  acw_wrapup_prompt                = "OPTIONAL"
  division_id                      = "${genesyscloud_auth_division.New_Home.id}"
  scoring_method                   = "TimestampAndPriority"
}

resource "genesyscloud_routing_queue" "tf_queue_a8a873b0-6ea5-49a3-853b-3f80f921db97" {
  scoring_method    = "TimestampAndPriority"
  acw_wrapup_prompt = "MANDATORY_TIMEOUT"
  media_settings_message {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  name                     = "tf_queue_a8a873b0-6ea5-49a3-853b-3f80f921db97"
  auto_answer_only         = true
  division_id              = "${genesyscloud_auth_division.New_Home.id}"
  enable_manual_assignment = false
  media_settings_chat {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  suppress_in_queue_call_recording = true
  enable_transcription             = false
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  skill_evaluation_method = "ALL"
  media_settings_call {
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
  }
  media_settings_email {
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
  }
}

resource "genesyscloud_routing_queue" "Create_2023_Queue_ec7165fe-7b57-4c43-aae2-df18ea72e066" {
  enable_transcription = true
  media_settings_call {
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  scoring_method     = "TimestampAndPriority"
  calling_party_name = "Example Inc."
  media_settings_chat {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  media_settings_message {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  enable_manual_assignment = false
  media_settings_callback {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  name              = "Create 2023 Queue ec7165fe-7b57-4c43-aae2-df18ea72e066"
  acw_wrapup_prompt = "OPTIONAL"
  media_settings_email {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
  }
  suppress_in_queue_call_recording = true
  auto_answer_only                 = false
  division_id                      = "${genesyscloud_auth_division.New_Home.id}"
  skill_evaluation_method          = "ALL"
}

resource "genesyscloud_routing_queue" "Terraform_Test_Queue-7697c106-61a9-4587-912f-fb847f73f7d7" {
  division_id                      = "${genesyscloud_auth_division.New_Home.id}"
  name                             = "Terraform Test Queue-7697c106-61a9-4587-912f-fb847f73f7d7"
  skill_evaluation_method          = "ALL"
  acw_wrapup_prompt                = "MANDATORY_TIMEOUT"
  suppress_in_queue_call_recording = true
  enable_manual_assignment         = false
  enable_transcription             = false
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_chat {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  description = "This is a test"
  media_settings_email {
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
  }
  media_settings_message {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  scoring_method   = "TimestampAndPriority"
  auto_answer_only = true
  acw_timeout_ms   = 200000
  media_settings_call {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
}

resource "genesyscloud_routing_queue" "tf_queue_35fcd586-91b7-4fe6-bdc5-756e5538d1c1" {
  enable_manual_assignment = false
  media_settings_callback {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  auto_answer_only = true
  media_settings_email {
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
  }
  media_settings_message {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  acw_wrapup_prompt    = "MANDATORY_TIMEOUT"
  enable_transcription = false
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
  }
  name                             = "tf_queue_35fcd586-91b7-4fe6-bdc5-756e5538d1c1"
  suppress_in_queue_call_recording = true
  division_id                      = "${genesyscloud_auth_division.New_Home.id}"
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  scoring_method          = "TimestampAndPriority"
  skill_evaluation_method = "ALL"
}

resource "genesyscloud_routing_queue" "tf_queue_fa09dc3e-98ed-4683-9cce-233721bfcd1a" {
  division_id = "${genesyscloud_auth_division.New_Home.id}"
  media_settings_chat {
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
  }
  media_settings_email {
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
  }
  name                    = "tf_queue_fa09dc3e-98ed-4683-9cce-233721bfcd1a"
  skill_evaluation_method = "ALL"
  auto_answer_only        = true
  enable_transcription    = false
  acw_wrapup_prompt       = "MANDATORY_TIMEOUT"
  media_settings_message {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  scoring_method                   = "TimestampAndPriority"
  enable_manual_assignment         = false
  suppress_in_queue_call_recording = true
  media_settings_callback {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  media_settings_call {
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
}

resource "genesyscloud_routing_queue" "Agnes_Test_Queue" {
  suppress_in_queue_call_recording = true
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_message {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  auto_answer_only     = false
  enable_transcription = false
  media_settings_call {
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  acw_wrapup_prompt        = "OPTIONAL"
  scoring_method           = "TimestampAndPriority"
  division_id              = "${genesyscloud_auth_division.New_Home.id}"
  enable_manual_assignment = false
  media_settings_email {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
  }
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  name                    = "Agnes Test Queue"
  skill_evaluation_method = "ALL"
}

resource "genesyscloud_routing_queue" "_401K" {
  media_settings_chat {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  media_settings_call {
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  name                 = "401K"
  description          = "401K questions and answers"
  division_id          = "${genesyscloud_auth_division.New_Home.id}"
  enable_transcription = true
  scoring_method       = "TimestampAndPriority"
  acw_timeout_ms       = 300000
  media_settings_email {
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
  }
  media_settings_message {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  skill_evaluation_method  = "BEST"
  enable_manual_assignment = true
  media_settings_callback {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  auto_answer_only                 = true
  suppress_in_queue_call_recording = true
  acw_wrapup_prompt                = "MANDATORY_TIMEOUT"
}

resource "genesyscloud_routing_queue" "GeneralSupport" {
  acw_timeout_ms                   = 300000
  auto_answer_only                 = true
  enable_manual_assignment         = true
  suppress_in_queue_call_recording = true
  description                      = "GeneralSupport questions and answers"
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_call {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  media_settings_message {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  name                 = "GeneralSupport"
  acw_wrapup_prompt    = "MANDATORY_TIMEOUT"
  enable_transcription = true
  media_settings_chat {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  scoring_method          = "TimestampAndPriority"
  division_id             = "${genesyscloud_auth_division.New_Home.id}"
  skill_evaluation_method = "BEST"
  media_settings_email {
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
  }
}

resource "genesyscloud_routing_queue" "PrinceTestQueue" {
  enable_manual_assignment = false
  media_settings_chat {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  name                             = "PrinceTestQueue"
  acw_wrapup_prompt                = "OPTIONAL"
  suppress_in_queue_call_recording = true
  media_settings_message {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  media_settings_call {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  division_id = "${genesyscloud_auth_division.New_Home.id}"
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_email {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
  }
  scoring_method          = "TimestampAndPriority"
  skill_evaluation_method = "ALL"
  auto_answer_only        = false
  enable_transcription    = false
}

resource "genesyscloud_routing_queue" "tf_queue_11e2e696-5a03-44ed-a41e-508ac7b6ba91" {
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  suppress_in_queue_call_recording = true
  media_settings_call {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
  }
  scoring_method           = "TimestampAndPriority"
  enable_manual_assignment = false
  enable_transcription     = false
  auto_answer_only         = true
  division_id              = "${genesyscloud_auth_division.New_Home.id}"
  media_settings_email {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
  }
  acw_wrapup_prompt = "MANDATORY_TIMEOUT"
  name              = "tf_queue_11e2e696-5a03-44ed-a41e-508ac7b6ba91"
  media_settings_message {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  skill_evaluation_method = "ALL"
}

resource "genesyscloud_routing_queue" "ROTH" {
  media_settings_call {
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  description = "ROTH questions and answers"
  media_settings_email {
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
  }
  scoring_method           = "TimestampAndPriority"
  acw_wrapup_prompt        = "MANDATORY_TIMEOUT"
  enable_manual_assignment = true
  enable_transcription     = true
  name                     = "ROTH"
  acw_timeout_ms           = 300000
  media_settings_callback {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  auto_answer_only                 = true
  division_id                      = "${genesyscloud_auth_division.New_Home.id}"
  skill_evaluation_method          = "BEST"
  suppress_in_queue_call_recording = true
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_message {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
}

resource "genesyscloud_routing_queue" "tf_queue_5ff2a7a8-b7b2-4574-9221-ff5d9b3c62d2" {
  media_settings_call {
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
  }
  media_settings_chat {
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
  }
  media_settings_message {
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
  }
  media_settings_email {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 86400000
  }
  division_id              = "${genesyscloud_auth_division.New_Home.id}"
  enable_manual_assignment = false
  enable_transcription     = false
  media_settings_callback {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  name                             = "tf_queue_5ff2a7a8-b7b2-4574-9221-ff5d9b3c62d2"
  acw_wrapup_prompt                = "MANDATORY_TIMEOUT"
  auto_answer_only                 = true
  scoring_method                   = "TimestampAndPriority"
  suppress_in_queue_call_recording = true
  skill_evaluation_method          = "ALL"
}

resource "genesyscloud_routing_queue" "PremiumSupport" {
  name                 = "PremiumSupport"
  scoring_method       = "TimestampAndPriority"
  enable_transcription = true
  media_settings_email {
    service_level_duration_ms = 86400000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 300
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  media_settings_message {
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
  }
  skill_evaluation_method  = "BEST"
  acw_timeout_ms           = 300000
  enable_manual_assignment = true
  media_settings_call {
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
    alerting_timeout_sec      = 8
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
  }
  auto_answer_only = true
  description      = "PremiumSupport questions and answers"
  division_id      = "${genesyscloud_auth_division.New_Home.id}"
  media_settings_callback {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
  suppress_in_queue_call_recording = true
  acw_wrapup_prompt                = "MANDATORY_TIMEOUT"
  media_settings_chat {
    alerting_timeout_sec      = 30
    enable_auto_answer        = false
    enable_auto_dial_and_end  = false
    service_level_duration_ms = 20000
    service_level_percentage  = 0.8
  }
}

variable "genesyscloud_routing_email_domain_devengagetest_pure_cloud_custom_smtp_server_id" {
  description = "The ID of the custom SMTP server integration to use when sending outbound emails from this domain."
}
variable "genesyscloud_routing_email_domain_mysillydomain123_pure_cloud_custom_smtp_server_id" {
  description = "The ID of the custom SMTP server integration to use when sending outbound emails from this domain."
}
variable "genesyscloud_flow_INBOUNDCALL_Dave_-_SFDC_Service_-_Basic_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_BOT_MyEmergencyChatBot_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDSHORTMESSAGE_PrinceInboundMessage_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_WORKFLOW_Accelerator__Set_User_Presence_on_Communicate_Call_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INQUEUECALL_InQueue_-_Orbit_Call_Park_Hold_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_OUTBOUNDCALL_test_flow_f53e17ea-8c8d-4c42-94e2-1d03cd78ec50_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_OUTBOUNDCALL_test_flow_4bbe4f58-b2d4-4d05-b828-28bccfafec44_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDSHORTMESSAGE_Agnes_Message_Flow_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_WORKFLOW_Send_Email_on_Failed_WebMessage_Workflow_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_WORKFLOW_Automated_Callback_-_Proactive_callback_workbin_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_WORKFLOW_Accelerator__Set_User_Presence_After_Communicate_Call_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDEMAIL_EmailAWSComprehendFlow_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_WORKFLOW_test_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INQUEUECALL_Automated_Callback_-_In-Queue_Offer_Callback_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_BOT_web-messaging-quick-response-bot_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_OUTBOUNDCALL_test_flow_de55c0d3-6360-4707-8b3b-c892d48b1ff5_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDCALL_DR-Emergency-IVR_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDCHAT_Agnes_Chat_Flow_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_OUTBOUNDCALL_Automated_Callback_-_Dial_Caller_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_OUTBOUNDCALL_test_flow_b4e20e3b-8508-4c11-8ba8-83bb48081437_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDCALL_Terraform_Flow_Test_ForceUnlock-e1af1b1e-c80c-4c81-884c-7b1648813b42_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_BOT_PrinceTest_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_VOICEMAIL_Default_Voicemail_Flow_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDCALL_Call_Park_Agent_-_Inbound_Flow_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_OUTBOUNDCALL_test_flow_0b3d214e-561f-4454-b928-9341ced0bbc5_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_OUTBOUNDCALL_test_flow_a4538e6f-e1d9-4678-aebe-34158959b26d_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDCALL_DR-Fallback-IVR_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INQUEUECALL_Default_In-Queue_Flow_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDCALL_Prince_Sample_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDCALL_SimpleFinancialIvr_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDSHORTMESSAGE_web-messaging-triage-bot-flow_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_OUTBOUNDCALL_test_flow_f2475d5d-8e47-4cf9-b00b-5b384f42ce8b_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_OUTBOUNDCALL_test_flow_424ee5a4-a389-4721-ae60-38ca6f576c33_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDCALL_Orbit_-_Parked_Call_Retrieval_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDCALL_Automated_Callback_-_Trigger_proactive_callback_workflow_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}
variable "genesyscloud_flow_INBOUNDSHORTMESSAGE_MyWebMessenger-Fallback_filepath" {
  description = "YAML file path for flow configuration. Note: Changing the flow name will result in the creation of a new flow with a new GUID, while the original flow will persist in your org."
}

