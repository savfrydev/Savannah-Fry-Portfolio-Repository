# Terraform + Azure DevOps Static Website

This project shows how to deploy a simple **static website** to **Azure** using **Terraform**, and run it through an **Azure DevOps pipeline** (CI/CD). It’s meant to be a starter “infra-as-code” portfolio project.

## What it does

- Creates an Azure **resource group**
- Creates an Azure **Storage Account** (Standard LRS, StorageV2)
- Enables **Static Website** hosting on the storage account
- (Optional) Stores Terraform **remote state** in Azure Blob Storage
- Can be run automatically from **Azure DevOps Pipelines**

## Why this project exists

I wanted a small, real project that proves I can:

1. Write infrastructure as code (Terraform)
2. Deploy to Azure using a service connection
3. Use Azure DevOps for CI/CD
4. Organize infra and app code in one repo

This is a good foundation to add:
- custom domain / CDN
- Function App / API
- environments (dev/test/prod)
- approvals / plan → apply workflow

## Repo structure

```text
.
├── infra/                 # Terraform code lives here
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   └── outputs.tf
├── website/               # Static site files (HTML/CSS/JS)
│   └── index.html
└── azure-pipelines.yml    # Azure DevOps pipeline to run Terraform
