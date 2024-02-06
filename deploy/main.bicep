var varLocation = 'uksouth'

param parHubAddressPrefix string
param parCoreAddressPrefix string
param parSpokeDevAddressPrefix string
param parSpokeProdAddressPrefix string

module modHubVnet 'br/public:avm/res/network/virtual-network:0.1.1' = {
  name: 'hubVnet'
  params: {
    name: 'vnet-hub-${varLocation}-001'
    addressPrefixes: [
      '${parHubAddressPrefix}.0.0/16'
    ]
    location: varLocation
    subnets: [
      {
        name: 'GatewaySubnet'
        addressPrefix: '${parHubAddressPrefix}.1.0/24'
      }
      {
        name: 'AppgwSubnet'
        addressPrefix: '${parHubAddressPrefix}.2.0/24'
      }
      {
        name: 'AzureFirewallSubnet'
        addressPrefix: '${parHubAddressPrefix}.3.0/24'
      }
      {
        name: 'AzureBastionSubnet'
        addressPrefix: '${parHubAddressPrefix}.4.0/24'
      }
    ]
  }
}

module modCoreVnet 'br/public:avm/res/network/virtual-network:0.1.1' = {
  name: 'coreVnet'
  params: {
    name: 'vnet-core-${varLocation}-001'
    addressPrefixes: [
      '${parCoreAddressPrefix}.0.0/16'
    ]
    location: varLocation
    subnets: [
      {
        name: 'VMSubnet'
        addressPrefix: '${parCoreAddressPrefix}.1.0/24'
      }
      {
        name: 'KVSubnet'
        addressPrefix: '${parCoreAddressPrefix}.2.0/24'
      }
    ]
    peerings: [
      {
        allowForwardedTraffic: true
        allowGatewayTransit: false
        allowVirtualNetworkAccess: true
        remotePeeringAllowForwardedTraffic: true
        remotePeeringAllowVirtualNetworkAccess: true
        remotePeeringEnabled: true
        remoteVirtualNetworkId: modHubVnet.outputs.resourceId
        useRemoteGateways: false
      }
    ]
  }
}

module modSpokeDevVnet 'br/public:avm/res/network/virtual-network:0.1.1' = {
  name: 'spokeDevVnet'
  params: {
    name: 'vnet-dev-${varLocation}-001'
    addressPrefixes: [
      '${parSpokeDevAddressPrefix}.0.0/16'
    ]
    location: varLocation
    subnets: [
      {
        name: 'AppSubnet'
        addressPrefix: '${parSpokeDevAddressPrefix}.1.0/24'
      }
      {
        name: 'SqlSubnet'
        addressPrefix: '${parSpokeDevAddressPrefix}.2.0/24'
      }
      {
        name: 'StSubnet'
        addressPrefix: '${parSpokeDevAddressPrefix}.3.0/24'
      }
    ]
    peerings: [
      {
        allowForwardedTraffic: false
        allowGatewayTransit: false
        allowVirtualNetworkAccess: true
        remotePeeringAllowForwardedTraffic: false
        remotePeeringAllowVirtualNetworkAccess: true
        remotePeeringEnabled: true
        remoteVirtualNetworkId: modHubVnet.outputs.resourceId
        useRemoteGateways: false
      }
    ]
  }
}

module modSpokeProdVnet 'br/public:avm/res/network/virtual-network:0.1.1' = {
  name: 'spokeProdVnet'
  params: {
    name: 'vnet-prod-${varLocation}-001'
    addressPrefixes: [
      '${parSpokeProdAddressPrefix}.0.0/16'
    ]
    location: varLocation
    subnets: [
      {
        name: 'AppSubnet'
        addressPrefix: '${parSpokeProdAddressPrefix}.1.0/24'
      }
      {
        name: 'SqlSubnet'
        addressPrefix: '${parSpokeProdAddressPrefix}.2.0/24'
      }
      {
        name: 'StSubnet'
        addressPrefix: '${parSpokeProdAddressPrefix}.3.0/24'
      }
    ]
    peerings: [
      {
        allowForwardedTraffic: false
        allowGatewayTransit: false
        allowVirtualNetworkAccess: true
        remotePeeringAllowForwardedTraffic: false
        remotePeeringAllowVirtualNetworkAccess: true
        remotePeeringEnabled: true
        remoteVirtualNetworkId: modHubVnet.outputs.resourceId
        useRemoteGateways: false
      }
    ]
  }
}
