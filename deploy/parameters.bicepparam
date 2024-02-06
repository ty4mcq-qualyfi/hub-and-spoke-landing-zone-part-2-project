using 'main.bicep'

//Hub Virtual Network Parameters
param parHubAddressPrefix = '10.10.0.0/16'
param parGatewaySubnetAddressPrefix = '10.10.1.0/24'
param parAppgwSubnetAddressPrefix = '10.10.2.0/24'
param parAzureFirewallSubnetAddressPrefix = '10.10.3.0/24'
param parAzureBastionSubnetAddressPrefix = '10.10.4.0/24'

//Core Virtual Network Parameters
param parCoreAddressPrefix = '10.20.0.0/16'
param parVMSubnetAddressPrefix = '10.20.1.0/24'
param parKVSubnetAddressPrefix = '10.20.2.0/24'

//Spoke Dev Virtual Network Parameters
param parSpokeDevAddressPrefix = '10.30.0.0/16'
param parSpokeDevAppSubnetAddressPrefix = '10.30.1.0/24'
param parSpokeDevSqlSubnetAddressPrefix = '10.30.2.0/24'
param parSpokeDevStSubnetAddressPrefix = '10.30.3.0/24'

//Spoke Prod Virtual Network Parameters
param parSpokeProdAddressPrefix = '10.31.0.0/16'
param parSpokeProdAppSubnetAddressPrefix = '10.31.1.0/24'
param parSpokeProdSqlSubnetAddressPrefix = '10.31.1.0/24'
param parSpokeProdStSubnetAddressPrefix = '10.31.1.0/24'
