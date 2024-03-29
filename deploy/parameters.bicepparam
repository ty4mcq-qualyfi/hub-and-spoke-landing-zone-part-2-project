using 'main.bicep'

param parAdminKvName = 'kv-secret-core-492181'

param parHubAddressPrefix = '10.10'
param parCoreAddressPrefix = '10.20'
param parSpokeDevAddressPrefix = '10.30'
param parSpokeProdAddressPrefix = '10.31'

// Virtual Machine Parameters
param parComputerName = 'vm1core001'
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
param parAfwPip = '10.10.3.4'

// Storage Account Parameters
param parSaKind = 'StorageV2'
param parSaSkuName = 'Standard_LRS'

param parSqlAdministratorLogin = 'adminusername'
param parSqlAdministratorLoginPassword = 'Password123!'
param parSqlSkuName = 'Basic'
param parSqlSkuTier = 'Basic'
param parSqlMaxSizeBytes = 2147483648

param parAspSkuCapacity = 1
param parAspSkuFamily = 'B'
param parAspSkuName = 'B1'
param parAspSkuSize = 'B1'
param parAspSkuTier = 'Basic'
param parWaLinuxFxVersion = 'DOTNETCORE|7.0'

param parUserObjectId = 'deb08a59-dd50-4e82-9b30-e3a84d5cd4fa'

param parRepoUrl = 'https://github.com/Azure-Samples/dotnetcore-docs-hello-world'
param parBranch = 'master'

// Application Gateway

