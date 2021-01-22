# AWS Network Firewall Example with Suricta rule option

It will create network firewall, firewall rule grup with priorities and rule config, Also it will create firewall policy with attached created rule group.

Data sources are used to discover existing VPC resources (VPC, subnet).

## Usage

To run this example you need to execute:

    terraform init
    terraform plan

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.4 |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| this_aws_network_firewall_id| The ID of AWS Network firewall |
| this_aws_network_firewall_arn | The ARN of the AWS Network firewall |
| this_aws_network_firewall_endpoint | Endpoint for AWS Network firewall |