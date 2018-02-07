require 'api/endpoints_repository'

module XClarityClient
    class Endpoint
        @@endpoint_name

        def self.registry_endpoint(endpoint_name, klass)
            @@endpoint_name = endpoint_name
            EndpointsRepository.add(endpoint_name, klass)
        end

        def self.endpoint_name()
            @@endpoint_name
        end
    end
end