using HTTP
using JSON


struct DiscoveryClient
    Authority::String

    function DiscoveryClient(;
        authority = "") # https://your.server.com
        endswith(authority, "/") && (authority = chop(authority))
        new(authority)
    end

end

struct DiscoveryResponse
    TokenEndpoint::String

    function DiscoveryResponse(;
        tokenEndpoint = "")
        new(tokenEndpoint)
    end

end

struct TokenClient
    Endpoint::String
    Headers::Dict
    Payload::Dict

    function TokenClient(;
        endpoint = "",
        headers = Dict("Accept" => "application/json", "Content-Type" => "application/x-www-form-urlencoded"),
        clientId = "",
        clientSecret = nothing
        )
        payload = Dict("client_id" => clientId)
        (clientSecret != nothing) && (payload["client_secret"] = clientSecret)
        new(endpoint, headers, payload)
    end

end

struct TokenResponse
    AccessToken::String
    TokenType::String
    ExpiresIn::Int

    function TokenResponse(response)
        if response.status == 200
            r = JSON.parse(String(response.body))
            return new(r["access_token"], r["token_type"], r["expires_in"])
        end
        response
    end

end

function get(client::DiscoveryClient)
    DiscoveryResponse(tokenEndpoint = "$(client.Authority)/connect/token")
end

function add_scope(data, scope)
    payload = copy(data)
    (scope != nothing) && (payload["scope"] = scope)
    return payload
end

function request(client::TokenClient, payload)
    r = HTTP.post(client.Endpoint, client.Headers, HTTP.URIs.escapeuri(payload))
    return TokenResponse(r)
end

function request_client_credentials(client::TokenClient; scope = nothing)
    payload = add_scope(client.Payload, scope)
    payload["grant_type"] = "client_credentials"
    request(client, payload)
end

function request_resource_owner_password(client::TokenClient, username::String, password::String; scope = nothing)
    payload = add_scope(client.Payload, scope)
    payload["username"] = username
    payload["password"] = password
    payload["grant_type"] = "password"
    request(client, payload)
end
