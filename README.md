# Overview

This repo simplifies the usage of https://microsoft365dsc.com/ when running interactively, in particular simplifying how authentication is handled.

# Usage
- run the prereqs found in ./Setup/prereqs.ps1
- run the function found in ./Setup/SetupConnections.ps1 
  - If you see some red dialogue about `RetryCommand` that's ok, just make sure you see some output with GUIDs in not-red
- run the functions found in ./Commands directory
  - Make sure you select the EA credential set, not the user account
