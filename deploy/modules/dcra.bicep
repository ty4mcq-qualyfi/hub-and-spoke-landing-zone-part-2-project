param parVmDcrName string
param parVmDcrId string

resource resVmDcr 'Microsoft.Insights/dataCollectionRules@2022-06-01' existing = {
  name: parVmDcrName
}

resource resVmDcrAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2022-06-01' = {
  name: 'vmDcrAssociation'
  scope: resVmDcr
  properties: {
    description: 'Association of data collection rule. Deleting this association will break the data collection for this virtual machine.'
    dataCollectionRuleId: parVmDcrId
  }
}
