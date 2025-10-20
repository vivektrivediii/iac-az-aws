# MongoDB Atlas Database

This Terraform module has been designed to be able to create a MongoDB database in MongoDB Atlas, and associate it with a user such that only user has access to it.

In addition to that, it also creates secrets in Kubernetes and Azure KeyVault with the password and connection URL to that given database.

