
import java.util.Collections;
import java.util.Set;

import com.auth0.client.auth.AuthAPI;
import com.auth0.json.auth.TokenHolder;
import com.microsoft.aad.msal4j.ClientCredentialFactory;
import com.microsoft.aad.msal4j.ClientCredentialParameters;
import com.microsoft.aad.msal4j.ConfidentialClientApplication;
import com.microsoft.aad.msal4j.IAuthenticationResult;

public class App {

    // The shared audience. The already specified value must be used as the audience for your own identity provider's API or application.
    public static String sharedAudience = "api://DnbPartnerIdentityTrust";

    // The authority URI from DNB. This must be the already specified value.
    public static String dnbAuthorityUri = "https://login.microsoftonline.com:443/9ecbd628-0072-405d-8567-32c6750b0d3e";

    // The client ID from a DNB Identity, representing you as a partner at DNB. You will receive a unique client ID for each identity you federate with DNB as a partner.
    public static String dnbClientId = "<dnbClientId>";

    // The scope of a specific DNB API. You will receive a unique scope for each DNB API you want to access as a partner.
    public static Set<String> dnbApiClientScopes = Collections.singleton("<dnbClientScope>/.default");

    // The combination of values needed to obtain an access token from your own identity provider.
    // This example uses Auth0, but you can use any identity provider or technique that supports generating JWTs.
    public static String auth0ClientId = "<yourAuth0ClientId>";
    public static String auth0ClientSecret = "<yourAuth0ClientSecret>";
    public static String auth0Domain = "<yourAuth0Domain>.auth0.com";

    // Obtain an OAuth 2.0 Token with DNB authority and DNB scope.
    // This example uses the OAuth 2.0 Client Credentials Grant. 
    public static String GetMyProviderTokenAsync() throws Exception {
        AuthAPI authAPI = new AuthAPI(auth0Domain, auth0ClientId, auth0ClientSecret);
        TokenHolder tokenHolder = authAPI.requestToken(sharedAudience)
                .execute().getBody();

        return tokenHolder.getAccessToken();
    }

    public static void main(String[] args) throws Exception {

        // The actual token exchange. You provide your own token from your identity provider to DNB, which will then exchange it for a DNB access token.
        ConfidentialClientApplication dnbApp = ConfidentialClientApplication.builder(
                dnbClientId,
                ClientCredentialFactory.createFromClientAssertion(GetMyProviderTokenAsync()))
                .authority(dnbAuthorityUri)
                .validateAuthority(true)
                .build();

        IAuthenticationResult dnbAppToken = dnbApp
                .acquireToken(ClientCredentialParameters.builder(dnbApiClientScopes).build())
                .get();

        System.out.println("Access Token via Auth0:\n" + dnbAppToken.accessToken());
    }
}
