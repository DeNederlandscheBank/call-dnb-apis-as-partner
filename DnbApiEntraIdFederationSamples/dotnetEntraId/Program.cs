using Microsoft.Identity.Client;

// The authority URI from DNB. This must be the already specified value.
var dnbAuthorityUri = "https://login.microsoftonline.com:443/9ecbd628-0072-405d-8567-32c6750b0d3e";

// The scope of a specific DNB API. You will receive a unique scope for each DNB API you want to access as a partner.
var dnbApiClientScopes = new[] { "<dnbClientScope>/.default" };

// The combination of values needed to obtain an access token from your own identity provider.
// This example uses Entra ID.
var entraIdClientId = "<yourEntraIdClientId>";
var entraIdClientSecret = "<yourEntraIdClientSecret>";

// Obtain an OAuth 2.0 Token with DNB authority and DNB scope.
// This example uses the OAuth 2.0 Client Credentials Grant. 
var dnbApp = ConfidentialClientApplicationBuilder
            .Create(entraIdClientId)
            .WithAuthority(authorityUri: dnbAuthorityUri, validateAuthority: true)
            .WithClientSecret(entraIdClientSecret)
            .Build();

var dnbAppToken = await dnbApp.AcquireTokenForClient(dnbApiClientScopes).ExecuteAsync();

Console.WriteLine($"Access Token via Entra ID: {Environment.NewLine}{dnbAppToken.AccessToken}");
