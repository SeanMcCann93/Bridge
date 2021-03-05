# Bridge

* [Introduction](#Introduction)
* [Prerequisites](#Prerequisites)
    - [Install Ubuntu](#Install_Ubuntu)
        - [Windows](#Windows)
    - [IAM Roles](#IAM_Roles)
* [Instructions](#Instructions)

## Introduction

This Repository is built to create a 'Bridge' node. This is to increase productivity and security of larger "MISSION CRITICAL" application. Using this will close access to the main project by only allowing access to master/main node via this server.

Note: It is important that this server is not terminated when created with your main application server. If done so you may lose access to your build and need to restart the entire process again.

## Prerequisites

### Install Ubuntu

#### Windows

Install Ubuntu from windows store...

https://www.microsoft.com/store/productId/9NBLGGH4MSV6

Create a user and password for this (NOTE: When used it is used as if a seperate entity to your main account)

If you are using Visual Studio Code you can install a plug in that will enable this to become an active terminal.

https://marketplace.visualstudio.com/items?itemName=Docter60.vscode-terminal-for-ubuntu

Use `Ctrl + atl + U` to active terminal.

### IAM Roles

https://console.aws.amazon.com/iam/home

Must have an IAM account to launch terraform.

## Instructions

`git clone https://github.com/{Git Username}/Bridge`
`cd Bridge`
`sh bridge.sh`
Input your AWS credentials + Region + git credentials