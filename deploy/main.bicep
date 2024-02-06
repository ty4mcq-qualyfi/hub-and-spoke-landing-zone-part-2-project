param parHubAddressPrefix string
param parGatewaySubnetAddressPrefix string
param parAppgwSubnetAddressPrefix string
param parAzureFirewallSubnetAddressPrefix string
param parAzureBastionSubnetAddressPrefix string

param parCoreAddressPrefix string
param parVMSubnetAddressPrefix string
param parKVSubnetAddressPrefix string

param parSpokeDevAddressPrefix string
param parSpokeDevAppSubnetAddressPrefix string
param parSpokeDevSqlSubnetAddressPrefix string
param parSpokeDevStSubnetAddressPrefix string

param parSpokeProdAddressPrefix string
param parSpokeProdAppSubnetAddressPrefix string
param parSpokeProdSqlSubnetAddressPrefix string
param parSpokeProdStSubnetAddressPrefix string

var varLocation = 'uksouth'

var varHubVnetName = 'vnet-hub-${varLocation}-001'
var varCoreVnetName = 'vnet-core-${varLocation}-001'
var varSpokeDevVnetName = 'vnet-dev-${varLocation}-001'
var varSpokeProdVnetName = 'vnet-prod-${varLocation}-001'


module modHubVnet 'br/public:avm/res/network/virtual-network:0.1.1' = {
  name: 'hubVnet'
  params: {
    name: varHubVnetName
    addressPrefixes: [
      parHubAddressPrefix
    ]
    location: varLocation
    subnets: [
      {
        name: 'GatewaySubnet'
        addressPrefix: parGatewaySubnetAddressPrefix
      }
      {
        name: 'AppgwSubnet'
        addressPrefix: parAppgwSubnetAddressPrefix
      }
      {
        name: 'AzureFirewallSubnet'
        addressPrefix: parAzureFirewallSubnetAddressPrefix
      }
      {
        name: 'AzureBastionSubnet'
        addressPrefix: parAzureBastionSubnetAddressPrefix
      }
    ]
  }
}

module modCoreVnet 'br/public:avm/res/network/virtual-network:0.1.1' = {
  name: 'coreVnet'
  params: {
    name: varCoreVnetName
    addressPrefixes: [
      parCoreAddressPrefix
    ]
    location: varLocation
    subnets: [
      {
        name: 'VMSubnet'
        addressPrefix: parVMSubnetAddressPrefix
      }
      {
        name: 'KVSubnet'
        addressPrefix: parKVSubnetAddressPrefix
      }
    ]
  }
}

module modSpokeDevVnet 'br/public:avm/res/network/virtual-network:0.1.1' = {
  name: 'spokeDevVnet'
  params: {
    name: varSpokeDevVnetName
    addressPrefixes: [
      parSpokeDevAddressPrefix
    ]
    location: varLocation
    subnets: [
      {
        name: 'AppSubnet'
        addressPrefix: parSpokeDevAppSubnetAddressPrefix
      }
      {
        name: 'SqlSubnet'
        addressPrefix: parSpokeDevSqlSubnetAddressPrefix
      }
      {
        name: 'StSubnet'
        addressPrefix: parSpokeDevStSubnetAddressPrefix
      }
    ]
  }
}

module modSpokeProdVnet 'br/public:avm/res/network/virtual-network:0.1.1' = {
  name: 'spokeProdVnet'
  params: {
    name: varSpokeProdVnetName
    addressPrefixes: [
      parSpokeProdAddressPrefix
    ]
    location: varLocation
    subnets: [
      {
        name: 'AppSubnet'
        addressPrefix: parSpokeProdAppSubnetAddressPrefix
      }
      {
        name: 'SqlSubnet'
        addressPrefix: parSpokeProdSqlSubnetAddressPrefix
      }
      {
        name: 'StSubnet'
        addressPrefix: parSpokeProdStSubnetAddressPrefix
      }
    ]
  }
}
