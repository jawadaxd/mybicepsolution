@description('The Azure region into which the resources should be deployed.')
param location string = resourceGroup().location

@description('The type of environment. This must be nonprod or prod.')
@allowed([
  'prod'
  'nonprod'
])
param environmentType string

@description('A unique suffix to add to resource names that need to be globally unique.')
@maxLength(13)
param resourceNameSuffix string = uniqueString(resourceGroup().id)

var appServiceAppName = 'toy-website-${resourceNameSuffix}'
var appServicePlanName = 'toy-website-plan'
var toyManualsStorageAccountName = 'toyweb${resourceNameSuffix}'
var storageAccountImagesBlobContainerName = 'toyimages'

// Define the SKUs for each component based on the environment type.
var environmentConfigurationMap = {
  nonprod: {
    appServiceApp: {
      alwaysOn: false 
      }
    appServicePlan: {
      sku: {
        name: 'F1'
        capacity: 1
      }
    }
    toyManualsStorageAccount: {
      sku: {
        name: 'Standard_LRS'
      }
    }
  }
  prod: {
    appServiceApp: {
      alwaysOn: true
    }
    appServicePlan: {
      sku: {
        name: 'S1'
        capacity: 2
      }
    }
    toyManualsStorageAccount: {
      sku: {
        name: 'Standard_ZRS'
      }
    }
  }
}
var toyManualsStorageAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${toyManualsStorageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${toyManualsStorageAccount.listKeys().keys[0].value}'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  kind: 'linux'
  sku: environmentConfigurationMap[environmentType].appServicePlan.sku
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'python|3.9'
      alwaysOn: environmentConfigurationMap[environmentType].appServiceApp.alwaysOn
      appSettings: [
        {
          name: 'ToyManualsStorageAccountConnectionString'
          value: toyManualsStorageAccountConnectionString
        }
        {
          name: 'StorageAccountName'
          value: toyManualsStorageAccount.name
        }
        {
          name: 'StorageAccountBlobEndpoint'
          value: toyManualsStorageAccount.properties.primaryEndpoints.blob
        }
        {
          name: 'StorageAccountImagesContainerName'
          value: toyManualsStorageAccount::blobService::storageAccountImagesBlobContainer.name
        }
      ]
    }
  }
}

resource toyManualsStorageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: toyManualsStorageAccountName
  location: location
  kind: 'StorageV2'
  sku: environmentConfigurationMap[environmentType].toyManualsStorageAccount.sku

  resource blobService 'blobServices' = {
    name: 'default'

    resource storageAccountImagesBlobContainer 'containers' = {
      name: storageAccountImagesBlobContainerName

      properties: {
        publicAccess: 'Blob'
      }
    }
  }
}

// PostgreSQL DB ------

param flexibleServers_pgserver018_name string = 'pgserver018'
@secure()
param DBadministratorLogin string 
@secure()
param DBadministratorLoginPassword string 

resource flexibleServers_pgserver018_name_resource 'Microsoft.DBforPostgreSQL/flexibleServers@2022-01-20-preview' = {
  name: flexibleServers_pgserver018_name
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: { 
    administratorLogin: DBadministratorLogin
    administratorLoginPassword: DBadministratorLoginPassword
  }
}

resource flexibleServers_pgserver018_name_pgdb1 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2022-01-20-preview' = {
  parent: flexibleServers_pgserver018_name_resource
  name: 'pgdb1'
  properties: {
    charset: 'UTF8'
    collation: 'en_US.utf8'
  }
}

resource flexibleServers_pgserver018_name_pgdb2 'Microsoft.DBforPostgreSQL/flexibleServers/databases@2022-01-20-preview' = {
  parent: flexibleServers_pgserver018_name_resource
  name: 'pgdb2'
  properties: {
    charset: 'UTF8'
    collation: 'en_US.utf8'
  }
}


resource flexibleServers_pgserver018_name_AllowAllAzureServicesAndResourcesWithinAzureIps_2022_8_6_12_2_33 'Microsoft.DBforPostgreSQL/flexibleServers/firewallRules@2022-01-20-preview' = {
  parent: flexibleServers_pgserver018_name_resource
  name: 'AllowAllAzureServicesAndResourcesWithinAzureIps_2022-8-6_12-2-33'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource flexibleServers_pgserver018_name_ClientIPAddress_2022_8_6_12_2_21 'Microsoft.DBforPostgreSQL/flexibleServers/firewallRules@2022-01-20-preview' = {
  parent: flexibleServers_pgserver018_name_resource
  name: 'ClientIPAddress_2022-8-6_12-2-21'
  properties: {
    startIpAddress: '91.100.125.250'
    endIpAddress: '91.100.125.250'
  }
}

//output pgServerFullyQualifiedDomainName string = flexibleServers_pgserver018_name.fullyQualifiedDomainName
output pgDatabaseName string = flexibleServers_pgserver018_name_pgdb1.name

// Postgre DB End-----------

output appServiceAppName string = appServiceApp.name
output appServiceAppHostName string = appServiceApp.properties.defaultHostName
output toyManualsStorageAccount string = toyManualsStorageAccount.name
output storageAccountImagesBlobContainerName string = toyManualsStorageAccount::blobService::storageAccountImagesBlobContainer.name
