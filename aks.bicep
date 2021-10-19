param logAnalyticsWorkspaceId string

var name = 'aks-${resourceGroup().name}'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet-${resourceGroup().name}-aks'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.18.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-aks'
        properties: {
          addressPrefix: '172.18.0.0/24'
        }
      }
    ]
  }
}

resource managedCluster 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: name
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: '1.21.2'
    dnsPrefix: name
    enableRBAC: true
    agentPoolProfiles: [
      {
        name: 'default'
        count: 1
        minCount: 1
        maxCount: 3
        enableAutoScaling: true
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
        mode: 'System'
        vnetSubnetID: virtualNetwork.properties.subnets[0].id
      }
    ]
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure'
      serviceCidr: '10.10.10.0/24'
      dnsServiceIP: '10.10.10.10'
    }
    addonProfiles: {
      omsagent: {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspaceId
        }
      }
    }
  }
}

var networkContributorRoleId = '4d97b98b-1d4f-4787-a291-c67834d212e7'

resource rbacKubelet 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid(subscription().subscriptionId, subscription().tenantId, virtualNetwork.id, networkContributorRoleId)
  scope: virtualNetwork
  properties: {
    principalId: managedCluster.properties.identityProfile.kubeletidentity.objectId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', networkContributorRoleId)
  }
}

resource rbacKubernetes 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid(subscription().subscriptionId, subscription().tenantId, managedCluster.id, networkContributorRoleId)
  scope: virtualNetwork
  properties: {
    principalId: managedCluster.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', networkContributorRoleId)
  }
}

output name string = managedCluster.name
output vnetId string = virtualNetwork.id
