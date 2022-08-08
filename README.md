# My bicep django-app "Azelian (azelian.com)" development workflow
What works:
It will deploy azure app, app service plan, postgres db and storage account in test env. and prod env.
There is no integration between postgresDB and App yet.
Keyavult needs to be provided manually with DB credentials(username and password). Parameters.json file is where therse parameters are called.
-------

This repo contains code for REUSABLE WORKFLOWS with multiple github actions ENVIRONMENTS(Test, Production), deployed in two resource groups(mywebsite, mywebsiteTest)

![image](https://user-images.githubusercontent.com/40992722/182538193-1c220304-3eb5-4974-b039-2d1c35a2dc0a.png)

The workflow runs the Bicep linter to check that the Bicep code is valid and follows best practices.

Linting happens on the Bicep code without needing to connect to Azure, so it doesn't matter how many environments you're deploying to. It runs only once.

The workflow deploys to the test environment. This requires:

Running the Azure Resource Manager preflight validation.
Deploying the Bicep code.
Running some tests against your test environment.
If any part of the workflow fails, then the whole workflow stops so you can investigate and resolve the issue. But if everything succeeds, your workflow continues to deploy to your production environment:

The workflow includes a preview step, which runs the what-if operation on your production environment to list the changes that will be made to your production Azure resources. The what-if operation also validates your deployment, so you don't need to run a separate validation step for your production environment.
The workflow pauses for manual validation.
If approval is received, the workflow runs the deployment and smoke tests against your production environment.
Some of these tasks are repeated between your test and production environments, and some are run only for specific environments:

![Screenshot 2022-08-03 at 08 24 45](https://user-images.githubusercontent.com/40992722/182538747-8d2af973-b134-47c8-aef4-6b3262cb9732.png)
