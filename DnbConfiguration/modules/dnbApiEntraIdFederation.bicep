/*

Please note: This file is intended for internal DNB use only.
-------------------------------------------------------------

Configures an identity for DNB API Entra ID Federation with a DNB API role assignment.

*/

extension graphV1

@description('The object id of the Entra ID Enterprise Application (representing a DNB API)')
param dnbEntraIdAppObjectId string

@description('An App Role ID of the Entra ID Application Registration (representing a DNB API), to assign the partner identity to')
param dnbEntraIdAppRoleId string

@description('The client id of the partner\'s identity provider\'s identity. Retrieve this from your partner.')
param partnerIdentityClientId string

resource partnerRepresentationAsEntraIdIdentity 'Microsoft.Graph/servicePrincipals@v1.0' = {
  appId: partnerIdentityClientId
  notes: 'Federated identity from a partner company, used to access DNB APIs.'
}

resource partnerRepresentationAssignmentToEntraIdApiRole 'Microsoft.Graph/appRoleAssignedTo@v1.0' = {
  resourceId: dnbEntraIdAppObjectId
  appRoleId: dnbEntraIdAppRoleId
  resourceDisplayName: 'Partner identity assignment to a DNB API role'
  principalId: partnerRepresentationAsEntraIdIdentity.id
}
