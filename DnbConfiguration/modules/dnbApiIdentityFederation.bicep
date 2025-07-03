/*

Please note: This file is intended for internal DNB use only.
-------------------------------------------------------------

Configures an identity for DNB API Identity Federation with a DNB API role assignment.

*/

extension graphV1

@description('The object id of the Entra ID Enterprise Application (representing a DNB API)')
param dnbEntraIdAppObjectId string

@description('An App Role ID of the Entra ID Application Registration (representing a DNB API), to assign the partner identity to')
param dnbEntraIdAppRoleId string

@description('A descriptive Managed Identity resource name (already prefixed with "id-partner-") of the partner identity.')
param identityResourcePostfix string

@description('The issuer of the partner\'s identity provider. Retrieve this from your partner.')
param partnerIdentityIssuer string

@description('The subject claim of the partner\'s identity provider\'s identity-token. Retrieve this from your partner.')
param partnerIdentitySubject string

@description('The audience claim of the partner\'s identity provider\'s identity-token. In most cases, leave as default.')
param partnerIdentityAudience string = 'api://DnbPartnerIdentityTrust'

resource partnerRepresentationAsManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-01-31-preview' = {
  location: resourceGroup().location
  name: 'id-partner-${identityResourcePostfix}'

  resource federatedIdentityCredentials 'federatedIdentityCredentials' = {
    name: 'federated-identity'
    properties: {
      issuer: partnerIdentityIssuer
      subject: partnerIdentitySubject
      audiences: [partnerIdentityAudience] // Can only be a single audience, even though Bicep allows an array
    }
  }
}

resource partnerRepresentationAssignmentToEntraIdApiRole 'Microsoft.Graph/appRoleAssignedTo@v1.0' = {
  resourceId: dnbEntraIdAppObjectId
  appRoleId: dnbEntraIdAppRoleId
  resourceDisplayName: 'Partner identity assignment to a DNB API role'
  principalId: partnerRepresentationAsManagedIdentity.properties.principalId
}

@description('The Managed Identity Client ID. Share this with your partner and mention this as the `dnbClientId` for them.')
output partnerRepresentationClientId string = partnerRepresentationAsManagedIdentity.properties.clientId
