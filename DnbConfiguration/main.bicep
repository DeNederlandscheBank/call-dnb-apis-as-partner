/*

Please note: This file and underlying files are intended for internal DNB use only.
-----------------------------------------------------------------------------------

az login --tenant <dnbTenantId>
az deployment group create --resource-group <dnbResourceGroup> --template-file DnbConfiguration/main.bicep

*/

extension graphV1

resource app 'Microsoft.Graph/applications@v1.0' = {
  uniqueName: '<dnbApiName>'
  displayName: '<dnbApiDisplayName>'
  signInAudience: 'AzureADMyOrg'
  identifierUris: [
    'api://<dnbApiIdentifierUri>'
  ]
  appRoles: [
    {
      id: 'ac54df91-f707-4d44-9810-345d841d9b2c'
      displayName: '<dnbApiRole>'
      description: 'Allows access to the <dnbApiName> as a <dnbApiRole>.'
      value: '<dnbApiRole>'
      allowedMemberTypes: [
        'Application'
        'User'
      ]
      isEnabled: true
    }
  ]
}

var appRoleId = filter(enterpriseApp.appRoles, role => role.value == '<dnbApiRole>')[0].id

resource enterpriseApp 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: app.appId
}

@description('This demo is related to samples in the `DnbApiIdentityFederationSamples` folder')
module dnbApiIdentityFederationDemo 'modules/dnbApiIdentityFederation.bicep' = {
  params: {
    dnbEntraIdAppObjectId: enterpriseApp.id
    dnbEntraIdAppRoleId: appRoleId
    identityResourcePostfix: '<identityResourcePostfix>'
    partnerIdentityIssuer: 'https://<yourAuth0Domain>.auth0.com/'
    partnerIdentitySubject: '<yourAuth0ClientId>@clients'
  }
}

@description('This demo is related to samples in the `DnbApiEntraIdFederationSamples` folder')
module dnbApiEntraIdFederationDemo 'modules/dnbApiEntraIdFederation.bicep' = {
  params: {
    dnbEntraIdAppObjectId: enterpriseApp.id
    dnbEntraIdAppRoleId: appRoleId
    partnerIdentityClientId: '<yourEntraIdClientId>'
  }
}
