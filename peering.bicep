param apiVirtualNetworkId string
param aksVirtualNetworkId string

resource apiVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: last(split(apiVirtualNetworkId, '/'))
}

resource aksVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: last(split(aksVirtualNetworkId, '/'))
}

resource peeringApiAks 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: 'api-aks'
  parent: apiVirtualNetwork
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    remoteVirtualNetwork: {
      id: aksVirtualNetworkId
    }
  }
}

resource peeringAksApi 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-02-01' = {
  name: 'aks-api'
  parent: aksVirtualNetwork
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    remoteVirtualNetwork: {
      id: apiVirtualNetworkId
    }
  }
}
