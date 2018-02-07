require 'api/endpoints/endpoint'

module XClarityClient
    class Nodes < Endpoint
        registry_endpoint 'nodes', Nodes
    end
end