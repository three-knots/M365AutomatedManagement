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

# Usage

1) Run the PreReqs.ps1 file to get modules installed/updated.
2) Select an auth method

