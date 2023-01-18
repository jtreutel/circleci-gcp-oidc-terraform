# circleci-gcp-oidc-terraform
Terraform plan to deploy GCP infra necessary for authenticating with GCP using CircleCI OIDC tokens.  Creates a workload identity pool, a workload identity pool provider, a service account to impersonate, and binds necessary permissions to the new service account.

## Requirements

- Terraform (>= 1.0.9)

## How to Use

1. Retrieve your organization ID by [logging in to CircleCI](https://app.circleci.com/) and navigating to "Organization Settings".
2. Rename `terraform.tfvars.example` to `terraform.tfvars` and replace required values
3. (Optional) In `terraform.tfvars`, change the resource prefix and any other optional variables to desired values (see below for an explanation of the variables)
4. (Optional, but strongly recommended) Add a [remote state backend](https://www.terraform.io/docs/language/settings/backends/index.html) to store your terraform state
5. Run `terraform plan` and inspect proposed changes
6. Run `terraform apply` to apply changes

**Optional:** If you would like to do a sandbox deploy to test the Terraform plan using CircleCI, follow these steps:

1. Enter the necessary values in terraform.tfvars.example and save your changes
2. Run the following bash command: `cat terraform.tfvars | base64`
3. Store the output in a CircleCI context or project-level variable named BASE64_TFVARS.


## Resources Created by Terraform

- google_iam_workload_identity_pool.circleci
- google_iam_workload_identity_pool_provider.circleci
- google_service_account.circleci
- google_service_account_iam_binding.circleci
- google_service_account_iam_binding.circleci_sa_user


## Terraform Variables

### Required 

| Name | Default | Description|
|------|---------|------------|
|circleci_org_id|none|Your CircleCI org ID.  Can be found under "Organization Settings" in the CircleCI application.|


### Optional

| Name | Default | Description|
|------|---------|------------|
|resource_prefix|`CircleCI`|Resource prefix added to all resources created by this plan.|
|existing_service_account_name|||
|custom_attribute_mappings|||
|sa_impersonation_filter_attribute|||
|sa_impersonation_filter_value|||
|debug|`false`|Grants the created service account the `serviceAccountAdmin` role for testing purposes.|


## Granular Access Control

Access to service accounts can be restricted at the workload identity pool provider level and at the service account binding level.

### Restricting at the WIP Provider Level

Restrict access at the workload identity pool provider level by writing a CEL expression to describe which CircleCI OIDC tokens are allowed to impersonate the service accounts.  You can then set the expression as the value of variable `wip_provider_attribute_condition`.  Here are a few examples:

Restrict access to a specific org and user: 
```
attribute.org_id=='01234567-89ab-cdef-0123-4567890abcde' && 
google.subject.matches('org/([\da-f]{4,12}-?){5}/project/([\da-f]{4,12}-?){5}/user/76543210-ba98-fedc-3210-edcba0987654')
```

Restrict access to and org and its users with permission access a specific context:
```
attribute.org_id=='01234567-89ab-cdef-0123-4567890abcde' && 
attribute.context_id=='76543210-ba98-fedc-3210-edcba0987654' 
```

Restrict access and org and its users with access to a specific project :
```
attribute.org_id=='01234567-89ab-cdef-0123-4567890abcde' && 
attribute.project_id=='76543210-ba98-fedc-3210-edcba0987654' 
```


### Restricting at the Service Account Level

If you choose to automatically create a new service account, you can add a single condition to restrict impersonation of this service account.  Configure the variables `sa_impersonation_filter_attribute` and `sa_impersonation_filter_value` with the provider attribute and desired value, respectively.  For example:

sa_impersonation_filter_attribute = "attribute.project_id"
sa_impersonation_filter_value = "01234567-89ab-cdef-0123-4567890abcde"