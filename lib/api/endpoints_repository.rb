module XClarityClient
    class EndpointsRepository

        @@endpoints = {}

        def self.add(key, endpoint)
            @@endpoints[key.to_sym] = endpoint
        end

        def self.endpoints()
            @@endpoints.keys
        end

        def self.endpoint_handler(endpoint)
            handler = @@endpoints[endpoint.to_sym]
            raise Exception, 'No endpoint defined' if handler.nil?
            handler
        end
    end
end