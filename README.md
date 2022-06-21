# Terraform Apply for kubernetes cluster in AWS using Vault secrets - works on changes in a PR

## About

This action applies terraform plan for the kubernetes cluster in AWS. Hashicorp Vault secrets can be used during tf apply. 

## Limitation
This action works only on a Pull Request.

## Inputs

Below are the input variables for the action.

* `tf-working-dir`

  Path to the terraform root module to apply

  - Type: string
  - Required


* `terraform-version`

  Terraform version to download

  - Type: string
  - Required

* `cluster-name`

  Kubernetes cluster name to set the kubernetes context

  - Type: string
  - Required

* `aws-role-to-assume`

  Role ARN in AWS with which the connection to AWS will be established

  - Type: string
  - Required

* `aws-region`

  AWS Region

  - Type: string
  - Required

* `pr-dir`

  Specific directory in the PR contents if the PR contains changes in multiple directories 

  - Type: string
  - Required

## Outputs

* 'tf-fmt-outcome'
    Outcome of the 'terraform fmt' command

*  tf-validate-outcome:
    Outcome of the 'terraform validate' command

*  tf-validate-output:
    Output of the 'terraform validate' command

*  tf-init-outcome:
    Outcome of the 'terraform init' command

*  tf-plan-output:
    Output of the 'terraform plan' command

## Example usage

### WIP

This example workflow runs when PR is created or made ready for review to main.

```yaml
name: Apply

# Controls when the workflow will run
on:
  # Triggers the workflow on pull request events but only for targetted for the main branch and that too in specific folders
  pull_request_target:  
    types:
      - opened
      - edited
      - ready_for_review
    branches:    
      - main
    paths: 
      - 'relative-path-in-repository/**'
permissions:
      id-token: write
      contents: write
      pull-requests: write
      checks: write
      statuses: write
jobs:
  apply:
    runs-on: ubuntu-latest
    name: Apply approved plan
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
    steps:
      - name: Checkout
        uses: actions/checkout@v2


```


## License
The project is available as open source under the terms of the [MIT License](LICENSE).
