param parLocation string = 'uksouth'
var varGuidSuffix = substring(uniqueString(parUtc), 1, 8)

param parUtc string = utcNow()

param parAdminKvName string

param parHubAddressPrefix string
param parCoreAddressPrefix string
param parSpokeDevAddressPrefix string
param parSpokeProdAddressPrefix string

param parComputerName string
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
param parAfwPip string

param parSaKind string
param parSaSkuName string

param parSqlAdministratorLogin string
@secure()
param parSqlAdministratorLoginPassword string
param parSqlSkuName string
param parSqlSkuTier string
param parSqlMaxSizeBytes int

param parAspSkuCapacity int
param parAspSkuFamily string 
param parAspSkuName string
param parAspSkuSize string 
param parAspSkuTier string
param parWaLinuxFxVersion string

param parRepoUrl string
param parBranch string

param parUserObjectId string

param parAppGwName string = 'agw-hub-${parLocation}-001'
param parAppGwPublicIPName string = 'pip-hub-${parLocation}-appgw-001'

resource resAdminKv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: parAdminKvName
}

// Virtual Networks
module modHubVnet 'br/public:avm/res/network/virtual-network:0.1.1' = {
  name: 'hubVnet'
  params: {
    name: 'vnet-hub-${parLocation}-001'
    addressPrefixes: [
      '${parHubAddressPrefix}.0.0/16'
    ]
    location: parLocation
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
    name: 'vnet-core-${parLocation}-001'
    addressPrefixes: [
      '${parCoreAddressPrefix}.0.0/16'
    ]
    location: parLocation
    tags: {
      Dept: 'core'
      Owner: 'coreOwner'
    }
    subnets: [
      {
        name: 'VMSubnet'
        addressPrefix: '${parCoreAddressPrefix}.1.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
        routeTableResourceId: modRt.outputs.resourceId
      }
      {
        name: 'KVSubnet'
        addressPrefix: '${parCoreAddressPrefix}.2.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
        routeTableResourceId: modRt.outputs.resourceId
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
    name: 'vnet-dev-${parLocation}-001'
    addressPrefixes: [
      '${parSpokeDevAddressPrefix}.0.0/16'
    ]
    location: parLocation
    tags: {
      Dept: 'dev'
      Owner: 'devOwner'
    }
    subnets: [
      {
        name: 'AppSubnet'
        addressPrefix: '${parSpokeDevAddressPrefix}.1.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
        routeTableResourceId: modRt.outputs.resourceId
      }
      {
        name: 'SqlSubnet'
        addressPrefix: '${parSpokeDevAddressPrefix}.2.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
        routeTableResourceId: modRt.outputs.resourceId
      }
      {
        name: 'StSubnet'
        addressPrefix: '${parSpokeDevAddressPrefix}.3.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
        routeTableResourceId: modRt.outputs.resourceId
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
    name: 'vnet-prod-${parLocation}-001'
    addressPrefixes: [
      '${parSpokeProdAddressPrefix}.0.0/16'
    ]
    location: parLocation
    tags: {
      Dept: 'prod'
      Owner: 'prodOwner'
    }
    subnets: [
      {
        name: 'AppSubnet'
        addressPrefix: '${parSpokeProdAddressPrefix}.1.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
        routeTableResourceId: modRt.outputs.resourceId
      }
      {
        name: 'SqlSubnet'
        addressPrefix: '${parSpokeProdAddressPrefix}.2.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
        routeTableResourceId: modRt.outputs.resourceId
      }
      {
        name: 'StSubnet'
        addressPrefix: '${parSpokeProdAddressPrefix}.3.0/24'
        networkSecurityGroupResourceId: modNsg.outputs.resourceId
        routeTableResourceId: modRt.outputs.resourceId
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
    name: 'vm-core-${parLocation}-001'
    location: parLocation
    tags: {
      Dept: 'core'
      Owner: 'coreOwner'
    }
    computerName: parComputerName
    adminUsername: resAdminKv.getSecret('VmAdminUsername')
    adminPassword: resAdminKv.getSecret('VmAdminPassword')
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
    encryptionAtHost: false
    extensionAzureDiskEncryptionConfig: {
      enabled: true
      settings: {
        EncryptionOperation: 'EnableEncryption'
        KeyVaultResourceId: modEncryptKv.outputs.resourceId
        KeyVaultURL: modEncryptKv.outputs.uri
        KeyEncryptionAlgorithm: 'RSA-OAEP'
        VolumeType: 'All'
        ResizeOSDisk: 'false'
      }
    }
    extensionDependencyAgentConfig: {
      enabled: true
    }
    extensionAntiMalwareConfig: {
      enabled: true
      settings: {
        AntimalwareEnabled: 'true'
        RealtimeProtectionEnabled: 'true'
      }
    }
    extensionMonitoringAgentConfig: {
      enabled: true
      monitoringWorkspaceResourceId: modLaw.outputs.resourceId
    }
  }
}

// Network Security Group
module modNsg 'br/public:avm/res/network/network-security-group:0.1.2' = {
  name: 'nsg'
  params: {
    name: 'nsg-default'
    location: parLocation
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
//     name: 'bas-hub-${parLocation}-001'
//     location: parLocation
//     tags: {
//       Dept: 'hub'
//       Owner: 'hubOwner'
//     }
//     vNetId: modHubVnet.outputs.resourceId
//     skuName: parBastionSkuName
//     publicIPAddressObject: {
//       name: 'pip-hub-${parLocation}-bas-001'
//       allocationMethod: 'Static'
//     }
//   }
// }

// Firewall Policy + Firewall
module modAfwPolicy 'br/public:avm/res/network/firewall-policy:0.1.0' = {
  name: 'afwPolicy'
  params: {
    name: 'AfwPolicy'
    location: parLocation
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
module modAfw './ResourceModules/modules/network/azure-firewall/main.bicep' = {
  name: 'afw'
  params: {
    name: 'afw-hub-${parLocation}-001'
    location: parLocation
    tags: {
      Dept: 'hub'
      Owner: 'hubOwner'
    }
    vNetId: modHubVnet.outputs.resourceId
    firewallPolicyId: modAfwPolicy.outputs.resourceId
    hubIPAddresses:{
      privateIPAddress: parAfwPip
    }
    publicIPAddressObject: {
      name: 'pip-hub-${parLocation}-afw-001'
      publicIPAllocationMethod: 'Static'
    }
    diagnosticSettings: [
      {
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'diagnosticSettings'
        workspaceResourceId: modLaw.outputs.resourceId  
      }
    ]
  }
}

// Route Table
module modRt 'br/public:avm/res/network/route-table:0.2.2' = {
  name: 'rt'
  params: {
    name: 'rt-${parLocation}-001'
    location: parLocation
    tags: {
      Dept: 'coreServices'
      Owner: 'coreServicesOwner'
    }
    routes: [
      {
        name: 'Default'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: parAfwPip
          hasBgpOverride: false
        }
      }
    ]
  }
}

// Private DNS Zones
module modWaPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.2.3'= {
  name: 'waPrivateDnsZone'
  params: {
    name: 'privatelink.azurewebsites.net'
    tags: {
      Dept: 'coreServices'
      Owner: 'coreServicesOwner'
    }
    virtualNetworkLinks: [
      {
        name: 'link-to-hub'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modHubVnet.outputs.resourceId
      }
      {
        name: 'link-to-core'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modCoreVnet.outputs.resourceId
      }
      {
        name: 'link-to-dev'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modSpokeDevVnet.outputs.resourceId
      }
      {
        name: 'link-to-prod'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modSpokeProdVnet.outputs.resourceId
      }
    ]
  }
}
module modSqlPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.2.3'= {
  name: 'sqlPrivateDnsZone'
  params: {
    name: 'privatelink${environment().suffixes.sqlServerHostname}'
    tags: {
      Dept: 'coreServices'
      Owner: 'coreServicesOwner'
    }
    virtualNetworkLinks: [
      {
        name: 'link-to-hub'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modHubVnet.outputs.resourceId
      }
      {
        name: 'link-to-core'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modCoreVnet.outputs.resourceId
      }
      {
        name: 'link-to-dev'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modSpokeDevVnet.outputs.resourceId
      }
      {
        name: 'link-to-prod'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modSpokeProdVnet.outputs.resourceId
      }
    ]
  }
}
module modSaPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.2.3'= {
  name: 'saPrivateDnsZone'
  params: {
    name: 'privatelink.blob.${environment().suffixes.storage}'
    tags: {
      Dept: 'coreServices'
      Owner: 'coreServicesOwner'
    }
    virtualNetworkLinks: [
      {
        name: 'link-to-hub'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modHubVnet.outputs.resourceId
      }
      {
        name: 'link-to-core'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modCoreVnet.outputs.resourceId
      }
      {
        name: 'link-to-dev'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modSpokeDevVnet.outputs.resourceId
      }
      {
        name: 'link-to-prod'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modSpokeProdVnet.outputs.resourceId
      }
    ]
  }
}
module modKvPrivateDnsZone 'br/public:avm/res/network/private-dns-zone:0.2.3'= {
  name: 'kvPrivateDnsZone'
  params: {
    name: 'privatelink${environment().suffixes.keyvaultDns}'
    tags: {
      Dept: 'coreServices'
      Owner: 'coreServicesOwner'
    }
    virtualNetworkLinks: [
      {
        name: 'link-to-hub'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modHubVnet.outputs.resourceId
      }
      {
        name: 'link-to-core'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modCoreVnet.outputs.resourceId
      }
      {
        name: 'link-to-dev'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modSpokeDevVnet.outputs.resourceId
      }
      {
        name: 'link-to-prod'
        location: 'global'
        tags: {
          Dept: 'coreServices'
          Owner: 'coreServicesOwner'
        }
        registrationEnabled: false
        virtualNetworkResourceId: modSpokeProdVnet.outputs.resourceId
      }
    ]
  }
}

// App Service Plans + Web Apps
module modDevAsp 'br/public:avm/res/web/serverfarm:0.1.0' = {
  name: 'devAsp'
  params: {
    name: 'asp-dev-${parLocation}-001-${uniqueString(parUtc)}'
    location: parLocation
    tags: {
      Dept: 'dev'
      Owner: 'devOwner'
    }
    sku: {
      capacity: parAspSkuCapacity
      family: parAspSkuFamily
      name: parAspSkuName
      size: parAspSkuSize
      tier: parAspSkuTier
    }
    kind: 'Linux'
    reserved: true
  }
}
module modProdAsp 'br/public:avm/res/web/serverfarm:0.1.0' = {
  name: 'prodAsp'
  params: {
    name: 'asp-prod-${parLocation}-001-${uniqueString(parUtc)}'
    location: parLocation
    tags: {
      Dept: 'prod'
      Owner: 'prodOwner'
    }
    sku: {
      capacity: parAspSkuCapacity
      family: parAspSkuFamily
      name: parAspSkuName
      size: parAspSkuSize
      tier: parAspSkuTier
    }
    kind: 'Linux'
    reserved: true
  }
}

module modDevWa 'br/public:avm/res/web/site:0.2.0' = {
  name: 'devWa'
  params: {
    kind: 'app'
    name: 'wa-dev-${parLocation}-001-${uniqueString(parUtc)}'
    location: parLocation
    tags: {
      Dept: 'dev'
      Owner: 'devOwner'
    }
    serverFarmResourceId: modDevAsp.outputs.resourceId
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        name: 'pe-dev-${parLocation}-wa-001'
        location: parLocation
        tags: {
          Dept: 'dev'
          Owner: 'devOwner'
        }
        privateDnsZoneResourceIds: [
          '${modWaPrivateDnsZone.outputs.resourceId}'
        ]
        privateDnsZoneGroupName: 'waPeDnsGroup'
        subnetResourceId: modSpokeDevVnet.outputs.subnetResourceIds[0]
        service: 'sites'
      }
    ]
    siteConfig: {
      linuxFxVersion: parWaLinuxFxVersion
    }
    diagnosticSettings: [
      {
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'diagnosticSettings'
        workspaceResourceId: modLaw.outputs.resourceId
      }
    ]
  }
}
module modProdWa 'br/public:avm/res/web/site:0.2.0' = {
  name: 'prodWa'
  params: {
    kind: 'app'
    name: 'wa-prod-${parLocation}-001-${uniqueString(parUtc)}'
    location: parLocation
    tags: {
      Dept: 'prod'
      Owner: 'prodOwner'
    }
    serverFarmResourceId: modProdAsp.outputs.resourceId
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        name: 'pe-prod-${parLocation}-wa-001'
        location: parLocation
        tags: {
          Dept: 'prod'
          Owner: 'prodOwner'
        }
        privateDnsZoneResourceIds: [
          '${modWaPrivateDnsZone.outputs.resourceId}'
        ]
        privateDnsZoneGroupName: 'waPeDnsGroup'
        subnetResourceId: modSpokeProdVnet.outputs.subnetResourceIds[0]
        service: 'sites'
      }
    ]
    siteConfig: {
      linuxFxVersion: parWaLinuxFxVersion
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: modProdAppInsights.outputs.instrumentationKey
        }
        {
          name:'ApplicationInsightsAgent_EXTENSION_VERSION'
          value:'~3'
        }
        {
          name:'XDT_MicrosoftApplicationInsights_Mode'
          value:'default'
        }
      ]
    }
    appInsightResourceId: modProdAppInsights.outputs.resourceId
    diagnosticSettings: [
      {
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'diagnosticSettings'
        workspaceResourceId: modLaw.outputs.resourceId
      }
    ]
  }
}

module modDevWaSrcCntrl './modules/srccntrl.bicep' = {
  name: 'devWaSrcCntrl'
  params: {
    parWaName: '${modDevWa.outputs.name}/web'
    parRepoUrl: parRepoUrl
    parBranch: parBranch
  }
}
module modProdWaSrcCntrl './modules/srccntrl.bicep' = {
  name: 'prodWaSrcCntrl'
  params: {
    parWaName: '${modProdWa.outputs.name}/web'
    parRepoUrl: parRepoUrl
    parBranch: parBranch
  }
}

// SQL Servers + Databases
module modDevSql 'br/public:avm/res/sql/server:0.1.5' = {
  name: 'devSql'
  params: {
    name: 'sql-dev-${parLocation}-001-${uniqueString(parUtc)}'
    location: parLocation
    tags: {
      Dept: 'dev'
      Owner: 'devOwner'
    }
    administratorLogin: parSqlAdministratorLogin
    administratorLoginPassword: parSqlAdministratorLoginPassword
    publicNetworkAccess: 'Disabled'
    databases: [
      {
        name: 'sqldb-dev-${parLocation}-001'
        tags: {
          Dept: 'dev'
          Owner: 'devOwner'
        }
        skuName: parSqlSkuName
        skuTier: parSqlSkuTier
        maxSizeBytes: parSqlMaxSizeBytes
      }
    ]
    privateEndpoints: [
      {
        name: 'pe-dev-${parLocation}-sql-001'
        location: parLocation
        tags: {
          Dept: 'dev'
          Owner: 'devOwner'
        }
        privateDnsZoneResourceIds: [
          '${modSqlPrivateDnsZone.outputs.resourceId}'
        ]
        privateDnsZoneGroupName: 'sqlPeDnsGroup'
        subnetResourceId: modSpokeDevVnet.outputs.subnetResourceIds[1]
        service: 'sqlServer'
      }
    ]
  }
}
module modProdSql 'br/public:avm/res/sql/server:0.1.5' = {
  name: 'prodSql'
  params: {
    name: 'sql-prod-${parLocation}-001-${uniqueString(parUtc)}'
    location: parLocation
    tags: {
      Dept: 'prod'
      Owner: 'prodOwner'
    }
    administratorLogin: parSqlAdministratorLogin
    administratorLoginPassword: parSqlAdministratorLoginPassword
    publicNetworkAccess: 'Disabled'
    databases: [
      {
        name: 'sqldb-prod-${parLocation}-001'
        tags: {
          Dept: 'prod'
          Owner: 'prodOwner'
        }
        skuName: parSqlSkuName
        skuTier: parSqlSkuTier
        maxSizeBytes: parSqlMaxSizeBytes
      }
    ]
    privateEndpoints: [
      {
        name: 'pe-prod-${parLocation}-sql-001'
        location: parLocation
        tags: {
          Dept: 'prod'
          Owner: 'prodOwner'
        }
        privateDnsZoneResourceIds: [
          '${modSqlPrivateDnsZone.outputs.resourceId}'
        ]
        privateDnsZoneGroupName: 'sqlPeDnsGroup'
        subnetResourceId: modSpokeProdVnet.outputs.subnetResourceIds[1]
        service: 'sqlServer'
      }
    ]
  }
}

// Storage Accounts
module modDevSa 'br/public:avm/res/storage/storage-account:0.6.0' = {
  name: 'devSa'
  params: {
    name: 'stdev001${varGuidSuffix}'
    tags: {
      Dept: 'dev'
      Owner: 'devOwner'
    }
    kind: parSaKind
    skuName: parSaSkuName
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        name: 'pe-dev-${parLocation}-sa-001'
        location: parLocation
        tags: {
          Dept: 'dev'
          Owner: 'devOwner'
        }
        privateDnsZoneResourceIds: [
          '${modSaPrivateDnsZone.outputs.resourceId}'
        ]
        privateDnsZoneGroupName: 'saPeDnsGroup'
        subnetResourceId: modSpokeDevVnet.outputs.subnetResourceIds[2]
        service: 'blob'
      }
    ]
  }
}
module modProdSa 'br/public:avm/res/storage/storage-account:0.6.0' = {
  name: 'prodSa'
  params: {
    name: 'stprod001${varGuidSuffix}'
    tags: {
      Dept: 'prod'
      Owner: 'prodOwner'
    }
    kind: parSaKind
    skuName: parSaSkuName
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        name: 'pe-prod-${parLocation}-sa-001'
        location: parLocation
        tags: {
          Dept: 'prod'
          Owner: 'prodOwner'
        }
        privateDnsZoneResourceIds: [
          '${modSaPrivateDnsZone.outputs.resourceId}'
        ]
        privateDnsZoneGroupName: 'saPeDnsGroup'
        subnetResourceId: modSpokeProdVnet.outputs.subnetResourceIds[2]
        service: 'blob'
      }
    ]
  }
}

// Key Vault
module modEncryptKv 'br/public:avm/res/key-vault/vault:0.3.4' = {
  name: 'encryptKv'
  params: {
    name: 'kv-encrypt-core-${varGuidSuffix}'
    location: parLocation
    tags: {
      Dept: 'core'
      Owner: 'coreOwner'
    }
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: false
    enableVaultForDeployment: false
    publicNetworkAccess: 'Enabled'
    sku: 'standard'
    privateEndpoints: [
      {
        name: 'pe-core-${parLocation}-kv-001'
        location: parLocation
        tags: {
          Dept: 'core'
          Owner: 'coreOwner'
        }
        privateDnsZoneResourceIds: [
          '${modKvPrivateDnsZone.outputs.resourceId}'
        ]
        privateDnsZoneGroupName: 'kvPeDnsGroup'
        subnetResourceId: modCoreVnet.outputs.subnetResourceIds[1]
        service: 'vault'
      }
    ]
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: parUserObjectId
        permissions: {
          keys: [
            'all'
          ]
          secrets: [
            'all'
          ]
          certificates: [
            'all'
          ]
        }
      }
    ]
  }
}

// Log Analytics Workspace + Insights
module modLaw 'br/public:avm/res/operational-insights/workspace:0.3.3' = {
  name: 'law'
  params: {
    name: 'law-core-${parLocation}-001-${varGuidSuffix}'
    location: parLocation
    tags: {
      Dept: 'coreServices'
      Owner: 'coreServicesOwner'
    }
  }
}
module modVmDcr 'br/public:avm/res/insights/data-collection-rule:0.1.2' = {
  name: 'vmDcr'
  params: {
    name: 'MSVMI-vmDcr'
    location: parLocation
    dataFlows: [
      {
        destinations: [
          'VMInsightsPerf-Logs-Dest'
        ]
        streams: [
          'Microsoft-InsightsMetrics'
        ]
      }
      {
        destinations: [
          modLaw.outputs.name
        ]
        streams: [
          'Microsoft-Event'
        ]
      }
    ]
    dataSources: {
      performanceCounters: [
        {
          counterSpecifiers: [
            '\\LogicalDisk(_Total)\\% Disk Read Time'
            '\\LogicalDisk(_Total)\\% Disk Time'
            '\\LogicalDisk(_Total)\\% Disk Write Time'
            '\\LogicalDisk(_Total)\\% Free Space'
            '\\LogicalDisk(_Total)\\% Idle Time'
            '\\LogicalDisk(_Total)\\Avg. Disk Queue Length'
            '\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Read'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer'
            '\\LogicalDisk(_Total)\\Avg. Disk sec/Write'
            '\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length'
            '\\LogicalDisk(_Total)\\Disk Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Read Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Reads/sec'
            '\\LogicalDisk(_Total)\\Disk Transfers/sec'
            '\\LogicalDisk(_Total)\\Disk Write Bytes/sec'
            '\\LogicalDisk(_Total)\\Disk Writes/sec'
            '\\LogicalDisk(_Total)\\Free Megabytes'
            '\\Memory\\% Committed Bytes In Use'
            '\\Memory\\Available Bytes'
            '\\Memory\\Cache Bytes'
            '\\Memory\\Committed Bytes'
            '\\Memory\\Page Faults/sec'
            '\\Memory\\Pages/sec'
            '\\Memory\\Pool Nonpaged Bytes'
            '\\Memory\\Pool Paged Bytes'
            '\\Network Interface(*)\\Bytes Received/sec'
            '\\Network Interface(*)\\Bytes Sent/sec'
            '\\Network Interface(*)\\Bytes Total/sec'
            '\\Network Interface(*)\\Packets Outbound Errors'
            '\\Network Interface(*)\\Packets Received Errors'
            '\\Network Interface(*)\\Packets Received/sec'
            '\\Network Interface(*)\\Packets Sent/sec'
            '\\Network Interface(*)\\Packets/sec'
            '\\Process(_Total)\\Handle Count'
            '\\Process(_Total)\\Thread Count'
            '\\Process(_Total)\\Working Set'
            '\\Process(_Total)\\Working Set - Private'
            '\\Processor Information(_Total)\\% Privileged Time'
            '\\Processor Information(_Total)\\% Processor Time'
            '\\Processor Information(_Total)\\% User Time'
            '\\Processor Information(_Total)\\Processor Frequency'
            '\\System\\Context Switches/sec'
            '\\System\\Processes'
            '\\System\\Processor Queue Length'
            '\\System\\System Up Time'
          ]
          name: 'VMInsightsPerfCounters'
          samplingFrequencyInSeconds: 60
          streams: [
            'Microsoft-InsightsMetrics'
          ]
        }
      ]
      windowsEventLogs: [
        {
          name: 'eventLogsDataSource'
          streams: [
            'Microsoft-Event'
          ]
          xPathQueries: [
            'Application!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
            'Security!*[System[(band(Keywords,13510798882111488))]]'
            'System!*[System[(Level=1 or Level=2 or Level=3 or Level=4 or Level=0 or Level=5)]]'
          ]
        }
      ]
    }
    destinations: {
      azureMonitorMetrics: {
        name: 'VMInsightsPerf-Logs-Dest'
      }
      logAnalytics: [
        {
          name: modLaw.outputs.name
          workspaceResourceId: modLaw.outputs.resourceId
        }
      ]
    }
    kind: 'Windows'
  }
}
module modVmDcrA './modules/dcra.bicep' = {
  name: 'vmDcrA'
  params: {
    parVmName: modVm.outputs.name
    parVmDcrId: modVmDcr.outputs.resourceId
  }
}
module modProdAppInsights 'br/public:avm/res/insights/component:0.2.1' = {
  name: 'prodAppInsights'
  params: {
    name: 'appinsights-prod-001'
    location: parLocation
    workspaceResourceId: modLaw.outputs.resourceId
    applicationType: 'web'
    kind: 'web'
  }
}

module modAppGw  './ResourceModules/modules/network/application-gateway/main.bicep' = {
  name:'appGw'
  params: {
    name: parAppGwName
    location: parLocation
    tags: {
      Dept: 'hub'
      Owner: 'hubOwner'
    }
    sku:'Standard_v2'
    gatewayIPConfigurations: [
      {
        name:'ipConfig'
        properties: {
          subnet: {
            id: modHubVnet.outputs.subnetResourceIds[1]
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'frontendPIP'
        properties: {
          publicIPAddress: {
            id: modAppGwPublicIP.outputs.resourceId
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'bepool-webapp'
        properties: {
          backendAddresses: [
            {
              fqdn: '${modProdWa.outputs.name}.azurewebsites.net'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'bepool-settings'
        properties: {
          port: 80
          protocol: 'Http'
          pickHostNameFromBackendAddress: true
        }
      }
    ]
    httpListeners: [
      {
        name: 'http-listener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', parAppGwName, 'frontendPIP')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', parAppGwName, 'port_80')
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'http-only'
        properties: {
          ruleType: 'Basic'
          priority: 1000
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', parAppGwName, 'http-listener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', parAppGwName, 'bepool-webapp')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', parAppGwName, 'bepool-settings')
          }
        }
      }
    ]
    autoscaleMinCapacity: 0
    autoscaleMaxCapacity: 10
  }
}

module modAppGwPublicIP 'br/public:avm/res/network/public-ip-address:0.2.2' = {
  name:'appGatewayPIPDeployment'
  params:{
    name: parAppGwPublicIPName
    location: parLocation
    skuName: 'Standard'
    tags: {
      Dept: 'hub'
      Owner: 'hubOwner'
    }
    publicIPAllocationMethod: 'Static'
  }
}
