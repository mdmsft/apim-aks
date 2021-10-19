param applicationInsights object

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet-${resourceGroup().name}-api'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.17.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-api'
        properties: {
          addressPrefix: '172.17.0.0/24'
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: 'nsg-${resourceGroup().name}-api'
  location: resourceGroup().location
  properties: {
    securityRules: [
      {
        name: 'AllowInternetIn'
        properties: {
          priority: 100
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Inbound'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowApiManagementIn'
        properties: {
          priority: 110
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Inbound'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '3443'
          sourceAddressPrefix: 'ApiManagement'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowRedisCacheIn'
        properties: {
          priority: 120
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Inbound'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '6381-6383'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowSyncCountersIn'
        properties: {
          priority: 130
          access: 'Allow'
          protocol: 'Udp'
          direction: 'Inbound'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '4290'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowLoadBalancerIn'
        properties: {
          priority: 140
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Inbound'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '6390'
          sourceAddressPrefix: 'AzureLoadBalancer'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowStorageOut'
        properties: {
          priority: 100
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Outbound'
          destinationAddressPrefix: 'Storage'
          destinationPortRange: '443'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowActiveDirectoryOut'
        properties: {
          priority: 110
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Outbound'
          destinationAddressPrefix: 'AzureActiveDirectory'
          destinationPortRange: '443'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowSqlOut'
        properties: {
          priority: 120
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Outbound'
          destinationAddressPrefix: 'Sql'
          destinationPortRange: '1443'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowKeyVaultOut'
        properties: {
          priority: 130
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Outbound'
          destinationAddressPrefix: 'AzureKeyVault'
          destinationPortRange: '443'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowEventHubOut'
        properties: {
          priority: 140
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Outbound'
          destinationAddressPrefix: 'EventHub'
          destinationPortRanges: [
            '5671-5672'
            '443'
          ]
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowSmbOut'
        properties: {
          priority: 150
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Outbound'
          destinationAddressPrefix: 'Storage'
          destinationPortRange: '445'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowCloudOut'
        properties: {
          priority: 160
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Outbound'
          destinationAddressPrefix: 'AzureCloud'
          destinationPortRanges: [
            '443'
            '12000'
          ]
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowMonitorOut'
        properties: {
          priority: 170
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Outbound'
          destinationAddressPrefix: 'AzureMonitor'
          destinationPortRanges: [
            '443'
            '1886'
          ]
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowSmtpOut'
        properties: {
          priority: 180
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Outbound'
          destinationAddressPrefix: 'Internet'
          destinationPortRanges: [
            '25'
            '587'
            '25028'
          ]
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowRedisCacheOut'
        properties: {
          priority: 190
          access: 'Allow'
          protocol: 'Tcp'
          direction: 'Outbound'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '6381-6383'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowSyncCountersOut'
        properties: {
          priority: 200
          access: 'Allow'
          protocol: 'Udp'
          direction: 'Outbound'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '4290'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
        }
      }
    ]
  }
}

resource apiManagementInstance 'Microsoft.ApiManagement/service@2021-01-01-preview' = {
  name: 'api-${resourceGroup().name}'
  location: resourceGroup().location
  sku: {
    capacity: 1
    name: 'Developer'
  }
  identity: {
    type: 'None'
  }
  properties:{
    virtualNetworkType: 'External'
    publisherEmail: 'api@contoso.com'
    publisherName: 'Contoso'
    virtualNetworkConfiguration: {
      subnetResourceId: virtualNetwork.properties.subnets[0].id
    }
  }

  resource logger 'loggers' = {
    name: 'application-insights'
    properties: {
      loggerType: 'applicationInsights'
      resourceId: applicationInsights.id
      credentials: {
        instrumentationKey: applicationInsights.instrumentationKey
      }
    }
  }

  resource api 'apis' = {
    name: 'items'
    properties: {
      protocols: [
        'https'
      ]
      path: '/items'
      displayName: 'Items'
      serviceUrl: 'http://172.18.0.100'
      format: 'openapi+json'
      value: loadTextContent('./openapi.json')
      subscriptionRequired: false
    }

    resource diagnostic 'diagnostics' = {
      name: 'applicationinsights'
      properties: {
        loggerId: logger.id
        httpCorrelationProtocol: 'W3C'
        logClientIp: false
        alwaysLog: 'allErrors'
        verbosity: 'error'
        sampling: {
          percentage: 100
          samplingType: 'fixed'
        }
      }
    }

    resource policy 'policies' = {
      name: 'policy'
      properties: {
        format: 'xml'
        value: loadTextContent('./policy.xml')
      }
    }
  }
}

output vnetId string = virtualNetwork.id
