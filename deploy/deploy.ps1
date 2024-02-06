Connect-AzAccount

$resourceGroupName = 'tyler-hub-and-spoke-part-2-exercise'

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile '.\deploy\main.bicep' -TemplateParameterFile '.\deploy\parameters.bicepparam'