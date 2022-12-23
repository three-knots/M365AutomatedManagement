# M365AutomatedManagement
Automatically manage multiple M365 tenants leveraging M365 DSC

# Overview

The current setup leverages Enterprise Applications (EAs) to manage and audit access. The intent is to run these workflows locally for now.

## PreReqs.ps1

This installs and updates all the needed modules. The final step prompts you to log in with your account. 

# Initial Setup
1) Run the PreReqs.ps1 file and login with an account that has access to the "golden tenant"
2) Run the CreateEA.ps1 file to create the EA in your golden tenant
3) Repeat for any other tenants you intend to manage

# Post-Setup Usage

1) Run the PreReqs.ps1 file to login with your account. This account must have access to the EA in every tenant.
2) 

# Future Development

1) Enable this to run without creating EAs in every tenant
2) Setup this workflow in Github Actions