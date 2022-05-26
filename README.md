# circleci-gcp-oidc-terraform
Terraform plan to deploy GCP infra necessary for authenticating with GCP using CircleCI OIDC tokens.  Creates a workload identity pool, a workload identity pool provider, a service account to impersonate, and binds necessary permissions to the new service account.

## Requirements

- Terraform (>= 1.0.9)

## How to Use

1. Retrieve your organization ID by [logging in to CircleCI](https://app.circleci.com/) and navigating to "Organization Settings".
2. Rename `terraform.tfvars.example` to `terraform.tfvars` and replace required values
3. (Optional) In `terraform.tfvars`, change the resource prefix to desired value
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

## Terraform Variables

### Required 

| Name | Default | Description|
|------|---------|------------|
|circleci_org_id|none|Your CircleCI org ID.  Can be found under "Organization Settings" in the CircleCI application.|
|gcp_project_name|none|Name of GCP project in which to create resources.|
|gcp_region|none|Name of GCP region in which to create resources.|


### Optional

| Name | Default | Description|
|------|---------|------------|
|resource_prefix|`CircleCI`|Resource prefix added to all resources created by this plan.|
|debug|`false`|Grants the created service account the `serviceAccountAdmin` role for testing purposes.|
