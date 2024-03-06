param parWaName string
param parRepoUrl string
param parBranch string

resource resSrcControls 'Microsoft.Web/sites/sourcecontrols@2022-09-01' = {
  name: parWaName
  properties: {
    repoUrl: parRepoUrl
    branch: parBranch
    isManualIntegration: true
  }
}
