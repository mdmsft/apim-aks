module log 'log.bicep' = {
  name: '${deployment().name}-log'
}

module api 'api.bicep' = {
  name: '${deployment().name}-api'
  params: {
    applicationInsights: log.outputs.applicationInsights
  }
}

module aks 'aks.bicep' = {
  name: '${deployment().name}-aks'
  params: {
    logAnalyticsWorkspaceId: log.outputs.logAnalyticsWorkspaceId
  }
}

module peering 'peering.bicep' = {
  name: '${deployment().name}-peering'
  params: {
    aksVirtualNetworkId: aks.outputs.vnetId
    apiVirtualNetworkId: api.outputs.vnetId
  }
}


output clusterName string = aks.outputs.name
