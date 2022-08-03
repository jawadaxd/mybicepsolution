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

The control plane and the data plane
Many Azure resources provide two different planes for access. The control plane deploys and configures the resource. The data plane enables you to access the resource's functionality.

When you create and deploy Bicep files, you interact with the control plane. In Azure, the control plane is Azure Resource Manager. You use Resource Manager to define the configuration of each of your resources.

But your workflow often needs to do more than just interact with the control plane. For example, you might need to:

Upload a blob to a storage account.
Modify a database schema.
Make an API call to a third-party service.
Trigger the update of a machine learning model.
Deploy a website to an Azure App Service app.
Deploy software to a virtual machine.
Register a DNS entry with a third-party provider.
When you consider an end-to-end workflow, you ordinarily need to deploy your Azure resources and then perform a series of operations against the data planes of those resources. Sometimes, these operations are called the last mile of the deployment, because you're performing most of the deployment by using the control plane, and only a small amount of configuration remains.


How to perform data plane operations
When you create a deployment workflow that interacts with the data plane of your resources, you can use any of three common approaches:

Resource Manager deployment scripts
Workflow scripts
Workflow actions
Resource Manager deployment scripts are defined within your Bicep file. They run Bash or PowerShell scripts, and they can interact with the Azure CLI and Azure PowerShell cmdlets. You create a managed identity for the deployment script to use to authenticate to Azure, and Azure automatically provisions and manages the other resources it needs to run the deployment script.

Deployment scripts are good when you need to run a simple script within your deployment process. However, they don't easily provide you with access to other elements from your workflow.

You can also run your own logic from within a deployment workflow. GitHub Actions provides a rich ecosystem of actions for common things you need to do. If you can't find an action that meets your needs, you can use a script to run your own Bash or PowerShell code. Workflow actions and scripts run from your workflow's runner. You often need to authenticate the action or script to the data plane of the service you're using, and the way that you do this depends on the service.

Workflow actions and scripts give you flexibility and control. They also enable you to access workflow artifacts, which you'll learn about soon. In this module, we focus on workflow actions. We link to more information about Resource Manager deployment scripts on the Summary page at the end of the module.

Your deployment workflow
In the next exercise, you'll update your deployment workflow to add new jobs to build your website's application and deploy it to each environment:


![image](https://user-images.githubusercontent.com/40992722/182663468-d9813002-6e2f-45e2-b688-bae0cfbd9c19.png)



