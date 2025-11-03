using Auth0.AuthenticationApi;
using Auth0.AuthenticationApi.Models;
using Microsoft.Identity.Client;

// The shared audience. The already specified value must be used as the audience for your own identity provider's API or application.
var sharedAudience = "api://DnbPartnerIdentityTrust";

// The authority URI from DNB. This must be the already specified value.
var dnbAuthorityUri = "https://login.microsoftonline.com:443/9ecbd628-0072-405d-8567-32c6750b0d3e";

// The client ID from a DNB Identity, representing you as a partner at DNB. You will receive a unique client ID for each identity you federate with DNB as a partner.
var dnbClientId = "<dnbClientId>";

// The scope of a specific DNB API. You will receive a unique scope for each DNB API you want to access as a partner.
var dnbApiClientScopes = new[] { "<dnbClientScope>/.default" };

// The combination of values needed to obtain an access token from your own identity provider.
// This example uses Auth0, but you can use any identity provider or technique that supports generating JWTs.
var auth0ClientId = "<yourAuth0ClientId>";
var auth0ClientSecret = "<yourAuth0ClientSecret>";
var auth0Domain = "<yourAuth0Domain>.auth0.com";

// Obtain an OAuth 2.0 Token from your own identity provider.
// This example uses the OAuth 2.0 Client Credentials Grant. 
async Task<string> GetMyProviderTokenAsync()
{
    var authClient = new AuthenticationApiClient(auth0Domain);
    var accessTokenResponse = await authClient.GetTokenAsync(new ClientCredentialsTokenRequest()
    {
        Audience = sharedAudience,
        ClientId = auth0ClientId,
        ClientSecret = auth0ClientSecret,
    });

    return accessTokenResponse.AccessToken;
}

// The actual token exchange. You provide your own token from your identity provider to DNB, which will then exchange it for a DNB access token.
var dnbApp = ConfidentialClientApplicationBuilder
            .Create(dnbClientId)
            .WithAuthority(authorityUri: dnbAuthorityUri, validateAuthority: true)
            .WithClientAssertion((AssertionRequestOptions options) => GetMyProviderTokenAsync())
            .Build();

var dnbAppToken = await dnbApp.AcquireTokenForClient(dnbApiClientScopes).ExecuteAsync();

Console.WriteLine($"Access Token via Auth0: {Environment.NewLine}{dnbAppToken.AccessToken}");
