# Installation

## Introduction
This repo consists of files needed to install ebs csi driver. In order to install ebs csi driver, we need to create iam role for service account before installing the ebs csi driver. 

## Prerequisites
* `aws cli` installed and configured
 
## How it works

Execute the script with cluster name as the argument

```sh 
$ ./deploy-ebssc.sh <cluster-name>

Creating EBS CSI driver IAM role for service account!
Deploying EBS CSI add-on!
Add-on deployed successfully!

```
