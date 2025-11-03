# Call DNB APIs as a partner 🎏

![GitHub commit activity](https://img.shields.io/github/commit-activity/m/DeNederlandscheBank/call-dnb-apis-as-partner)

![Logo designed by Freepik](.images/logo.png)

Securely call RESTful DNB APIs as a partner with DNB's own identity federation mechanisms, tailored to [machine to machine](https://en.wikipedia.org/wiki/Machine_to_machine) API communications.

For partners running on Entra ID (Workforce tenant type), please refer to [DNB API Entra ID Federation](#dnb-api-entra-id-federation-). For all other partners, please refer to [DNB API Identity Federation](#dnb-api-identity-federation-). For both mechanisms, you provide a credential from your own identity provider to DNB, which returns a short-lived access token in exchange. This token grants you role-based access to one or more DNB APIs.

## DNB API Entra ID Federation 🏦

DNB API Entra ID Federation configures your ([multi-tenant](https://learn.microsoft.com/en-us/entra/identity-platform/howto-convert-app-to-be-multi-tenant#update-registration-to-be-multitenant)) Application Registration as a [nonconsensual (no tenant-wide admin consent)](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/grant-admin-consent) representation in our tenant. Please see [the configuration documentation for DNB API Entra ID Federation](/README_CONFIG_ENTRAID_FED.md) to configure this as a partner.

## DNB API Identity Federation 🏦

DNB API Identity Federation follows the [OAuth 2.0 Token Exchange specification (RFC 8693)](https://datatracker.ietf.org/doc/html/rfc8693). Please see [the configuration documentation for DNB API Identity Federation](/README_CONFIG_IDENTITY_FED.md) to configure this as a partner.

## Contributing

We welcome pull requests! Contributions that add sample configurations in additional programming languages or for new identity providers are especially appreciated.

To maintain consistency, new samples should follow the same structure and conventions as the existing .NET and Java samples:

- Declare all variables and comments in the same order as in the .NET and Java samples.
- Avoid introducing abstractions beyond those already present in the .NET and Java samples.
- For new samples written in Java, use Gradle as the build tool.
- For new samples written in .NET, integrate with the existing setup by adding your project to the [existing solution file](/cross-company-auth.slnx).
- To help us validate your sample, please include an expired access token or temporary credentials in the PR description to prove that the configuration works end-to-end.

## License

This work is licensed under the MIT/X license.
