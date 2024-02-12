using 'main.bicep'

param parHubAddressPrefix = '10.10'
param parCoreAddressPrefix = '10.20'
param parSpokeDevAddressPrefix = '10.30'
param parSpokeProdAddressPrefix = '10.31'

// Virtual Machine Parameters
param parComputerName = 'vm1core001'
param parVmAdminUsername = 'adminusername'
param parVmAdminPassword = 'Password123!'
param parOsType = 'Windows'
param parVmSize = 'Standard_D2S_v3'
param parOffer = 'WindowsServer'
param parPublisher = 'MicrosoftWindowsServer'
param parSku = '2022-datacenter-azure-edition'
param parPrivateIPAddress = '10.20.1.0'
param parNicSuffix = '-nic-001'
param parCaching = 'ReadWrite'
param parDiskSizeGB = '128'
param parStorageAccountType = 'Premium_LRS'

// Bastion Parameters
// param parBastionSkuName = 'Basic'

// Firewall Policy + Firewall Parameters
param parAfwPolicyTier = 'Standard'
param parAfwPolicyThreatIntelMode = 'Alert'

// Storage Account Parameters
param parSaKind = 'StorageV2'
param parSaSkuName = 'Standard_LRS'
