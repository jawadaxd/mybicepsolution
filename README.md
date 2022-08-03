# Bicep Solution
End-to-end deployment scenario for Bicep and github actions solution

Example scenario
Suppose you're responsible for deploying and configuring the Azure infrastructure at a toy company. You've built a Bicep template to deploy your company's website, which deploys an App Service app, an Azure SQL database for your product list, and a storage account for hosting product images. You've already created a workflow that deploys your Azure resources by using your Bicep template. Now, you want to extend the workflow to deploy your app, to configure your database, and to seed some test data you need for your website.

Architecture diagram illustrating the solution's Azure components, with the workflow deploying the Bicep file and performing the additional steps on the resources.

![image](https://user-images.githubusercontent.com/40992722/182643044-0f58dc06-028e-4a12-81c4-a4d6ef947be3.png)

What is the main goal?
After completing this module, you'll be able to create a unified deployment workflow that:

1- Provisions Azure resources by using a Bicep file
2- Deploys an application to Azure App Service
3- Publishes a database schema to an Azure SQL database
4- Adds sample data to an Azure SQL database and an Azure Storage blob container
5- You'll also know how to effectively use workflow artifacts, Bicep outputs, and workflow variables to coordinate the different parts of your workflow.
