# DnbConfiguration

The files in this folder are intended for internal DNB use only. They serve as a reference to illustrate how internal configuration for DNB API Entra ID Federation and DNB API Identity Federation can be implemented.

## Deploy (dev environment with auth0 partner)

```bash
az login --tenant b81eb003-1c5c-45fd-848f-90d9d3f8d016
az deployment group create \
  --resource-group apim001 \
  --template-file DnbConfiguration/main.bicep \
  --parameters DnbConfiguration/main.auth0.bicepparam
```
