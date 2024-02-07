var varLocation = 'uksouth'

param parHubAddressPrefix string
param parCoreAddressPrefix string
param parSpokeDevAddressPrefix string
param parSpokeProdAddressPrefix string

param parComputerName string
param parVmAdminUsername string
@secure()
param parVmAdminPassword string
param parOsType string
param parVmSize string
param parOffer string
param parPublisher string
param parSku string
param parPrivateIPAddress string
param parNicSuffix string
param parCaching string
param parDiskSizeGB string
param parStorageAccountType string

// param parBastionSkuName string

param parAfwPolicyTier string
param parAfwPolicyThreatIntelMode string

// Virtual Networks
module modHubVnet 'br/public:avm/res/network/virtual-network:0.1.1' = {
  name: 'hubVnet'
  params: {
    name: 'vnet-hub-${varLocation}-001'
    addressPrefixes: [
      '${parHubAddressPrefix}.0.0/16'
    ]
    location: varLocation
    tags: {
      Dept: 'hub'
      Owner: 'hubOwner'
    }
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
    tags: {
      Dept: 'core'
      Owner: 'coreOwner'
    }
    subnets: [
      {
        name: 'VMSubnet'
        addressPrefix: '${parCoreAddressPrefix}.1.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
      }
      {
        name: 'KVSubnet'
        addressPrefix: '${parCoreAddressPrefix}.2.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
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
    tags: {
      Dept: 'dev'
      Owner: 'devOwner'
    }
    subnets: [
      {
        name: 'AppSubnet'
        addressPrefix: '${parSpokeDevAddressPrefix}.1.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
      }
      {
        name: 'SqlSubnet'
        addressPrefix: '${parSpokeDevAddressPrefix}.2.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
      }
      {
        name: 'StSubnet'
        addressPrefix: '${parSpokeDevAddressPrefix}.3.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
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
    tags: {
      Dept: 'prod'
      Owner: 'prodOwner'
    }
    subnets: [
      {
        name: 'AppSubnet'
        addressPrefix: '${parSpokeProdAddressPrefix}.1.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
      }
      {
        name: 'SqlSubnet'
        addressPrefix: '${parSpokeProdAddressPrefix}.2.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
      }
      {
        name: 'StSubnet'
        addressPrefix: '${parSpokeProdAddressPrefix}.3.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
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

// Virtual Machine
module modVm 'br/public:avm/res/compute/virtual-machine:0.2.1' = {
  name: 'vm'
  params: {
    name: 'vm-core-${varLocation}-001'
    location: varLocation
    tags: {
      Dept: 'core'
      Owner: 'coreOwner'
    }
    computerName: parComputerName
    adminUsername: parVmAdminUsername
    adminPassword: parVmAdminPassword
    osType: parOsType
    vmSize: parVmSize
    imageReference: {
      offer: parOffer
      publisher: parPublisher
      sku: parSku
      version: 'latest'
    }
    osDisk: {
      caching: parCaching
      diskSizeGB: parDiskSizeGB
      managedDisk: {
        storageAccountType: parStorageAccountType
      }
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipConfig'
            properties: {
              privateIPAllocationMethod: 'Static'
              privateIPAddress: parPrivateIPAddress
            }
            subnetResourceId: modCoreVnet.outputs.subnetResourceIds[0]
          }
        ]
        nicSuffix: parNicSuffix
      }
    ]
  }
}

// Network Security Group
module modNsg 'br/public:avm/res/network/network-security-group:0.1.2' = {
  name: 'nsg'
  params: {
    name: 'nsg-default'
    location: varLocation
    tags: {
      Dept: 'coreServices'
      Owner: 'coreServicesOwner'
    }
  }
}

// Bastion
// module modBastion 'br/public:avm/res/network/bastion-host:0.1.1' = {
//   name: 'bastion'
//   params: {
//     name: 'bas-hub-${varLocation}-001'
//     location: varLocation
//     tags: {
//       Dept: 'hub'
//       Owner: 'hubOwner'
//     }
//     vNetId: modHubVnet.outputs.resourceId
//     skuName: parBastionSkuName
//     publicIPAddressObject: {
//       name: 'pip-hub-${varLocation}-bas-001'
//       allocationMethod: 'Static'
//     }
//   }
// }

// Firewall Policy + Firewall Test
module modAfwPolicy 'br/public:avm/res/network/firewall-policy:0.1.0' = {
  name: 'afw'
  params: {
    name: 'AfwPolicy'
    location: varLocation
    tags: {
      Dept: 'hub'
      Owner: 'hubOwner'
    }
    enableProxy: true
    tier: parAfwPolicyTier
    threatIntelMode: parAfwPolicyThreatIntelMode
    ruleCollectionGroups: [
      {
        name: 'DefaultNetworkRuleCollectionGroup'
        priority: 200
        ruleCollections: [
          {
            action: {
              type: 'Allow'
            }
            name: 'NetworkRuleCollection'
            priority: 1000
            ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
            rules: [
              {
                name: 'any/any'
                ruleType: 'NetworkRule'
                destinationAddresses: [
                  '*'
                ]
                destinationPorts: [
                  '*'
                ]
                sourceAddresses: [
                  '*'
                ]
                ipProtocols: [
                  'Any'
                ]
              }
            ]
          }
        ]
      }
    ]
  }
}

// module modAfwPolicy 'br/public:avm/res/network/firewall-policy:0.1.0' = {
//   name: 'afwPolicy'
//   params: {
//     name: 'AfwPolicy'
//     location: varLocation
//   }
// }
