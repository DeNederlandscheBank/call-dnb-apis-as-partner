
import java.util.Collections;
import java.util.Set;

import com.microsoft.aad.msal4j.ClientCredentialFactory;
import com.microsoft.aad.msal4j.ClientCredentialParameters;
import com.microsoft.aad.msal4j.ConfidentialClientApplication;
import com.microsoft.aad.msal4j.IAuthenticationResult;

public class App {

    public static void main(String[] args) throws Exception {

        // The authority URI from DNB. This must be the already specified value.
        String dnbAuthorityUri = "https://login.microsoftonline.com/9ecbd628-0072-405d-8567-32c6750b0d3e";

        // The scope of a specific DNB API. You will receive a unique scope for each DNB API you want to access as a partner.
        Set<String> dnbApiClientScopes = Collections.singleton("<dnbClientScope>/.default");

        // The combination of values needed to obtain an access token from your own identity provider.
        // This example uses Entra ID.
        String entraIdClientId = "<yourEntraIdClientId>";
        String entraIdClientSecret = "<yourEntraIdClientSecret>";

        // Obtain an OAuth 2.0 Token with DNB authority and DNB scope.
        // This example uses the OAuth 2.0 Client Credentials Grant. 
        ConfidentialClientApplication dnbApp = ConfidentialClientApplication.builder(
                entraIdClientId,
                ClientCredentialFactory.createFromSecret(entraIdClientSecret))
                .authority(dnbAuthorityUri)
                .validateAuthority(true)
                .build();

        IAuthenticationResult dnbAppToken = dnbApp
                .acquireToken(ClientCredentialParameters.builder(dnbApiClientScopes).build())
                .get();

        System.out.println("Access Token via Entra ID:\n" + dnbAppToken.accessToken());
    }
}
