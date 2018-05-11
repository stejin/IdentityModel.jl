# IdentityModel.jl
Partial implementation of the [IdentityModel](https://github.com/IdentityModel/IdentityModel2) library for Julia.

Current implementation is limited to retrieving tokens from an existing IdentityServer installation.

## Installation

```
Pkg.clone("https://github.com/stejin/IdentityModel.jl.git")
```

## Usage

```
using IdentityModel

dc = DiscoveryClient(authority = "https://your.identityserver.com")

dcr = IdentityModel.get(dc)

tc1 = TokenClient(endpoint = dcr.TokenEndpoint, clientId = "Client1", clientSecret = "secret")

t1 = request_client_credentials(tc1; scope = "Scope")


tc2 = TokenClient(endpoint = dcr.TokenEndpoint, clientId = "Client2")

t2 = request_resource_owner_password(tc2, "Username", "Password")

```
