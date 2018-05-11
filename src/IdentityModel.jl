__precompile__()
module IdentityModel
    export  DiscoveryClient,
            TokenClient,
            request_client_credentials,
            request_resource_owner_password

    include("client.jl")

end
