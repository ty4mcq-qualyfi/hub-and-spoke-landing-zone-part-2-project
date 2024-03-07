param parVmName string
param parVmDcrId string

resource resVm 'Microsoft.Compute/virtualMachines@2023-09-01' existing = {
  name: parVmName
}

resource resVmDcrAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'vmDcrAssociation'
  scope: resVm
  properties: {
    description: 'Association of data collection rule. Deleting this association will break the data collection for this virtual machine.'
    dataCollectionRuleId: parVmDcrId
  }
}
