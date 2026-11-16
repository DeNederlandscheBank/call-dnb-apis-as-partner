/*

Please note: This file and underlying files are intended for internal DNB use only.
-----------------------------------------------------------------------------------

See README.md in this folder for parameters, parameter files, and deployment instructions.

*/

param dnbApiName string = 'dnb-partner-test-api'
param dnbApiDisplayName string = 'DNB Partner Test API'
param dnbApiIdentifierUri string = 'dnb-partner-test-api'

// DNB API Identity Federation (DnbApiIdentityFederationSamples)
param identityResourcePostfix string
param partnerIdentityIssuer string
param partnerIdentitySubject string

// DNB API Entra ID Federation (DnbApiEntraIdFederationSamples)
param partnerEntraIdClientId string = 'd2bead47-9a39-4bfd-af7b-38b0c8ae3c48'

var roleName = 'mvp'

extension graphV1

resource app 'Microsoft.Graph/applications@v1.0' = {
  uniqueName: dnbApiName
  displayName: dnbApiDisplayName
  signInAudience: 'AzureADMyOrg'
  api: {
    requestedAccessTokenVersion: 2
  }
  identifierUris: [
    'api://${dnbApiIdentifierUri}'
  ]
  appRoles: [
    {
      id: '845b5f59-78c9-4607-b705-7b507487a253'
      displayName: roleName
      description: 'Allows access to the ${dnbApiName} as a ${roleName}.'
      value: roleName
      allowedMemberTypes: [
        'Application'
        'User'
      ]
      isEnabled: true
    }
  ]
}

var appRoleId = filter(app.appRoles, role => role.value == roleName)[0].id

resource enterpriseApp 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: app.appId
}

module dnbApiIdentityFederationDemo 'modules/dnbApiIdentityFederation.bicep' = {
  params: {
    dnbEntraIdAppObjectId: enterpriseApp.id
    dnbEntraIdAppRoleId: appRoleId
    identityResourcePostfix: identityResourcePostfix
    partnerIdentityIssuer: partnerIdentityIssuer
    partnerIdentitySubject: partnerIdentitySubject
  }
}

module dnbApiEntraIdFederationDemo 'modules/dnbApiEntraIdFederation.bicep' = {
  params: {
    dnbEntraIdAppObjectId: enterpriseApp.id
    dnbEntraIdAppRoleId: appRoleId
    partnerIdentityClientId: partnerEntraIdClientId
  }
}
