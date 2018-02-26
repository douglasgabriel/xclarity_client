module XClarityClient
    #
    # Repository for XClarity API endpoints
    #
    class EndpointsRepository

        @@endpoints = {}

        # Registers a new endpoint on repositoiry
        #
        # @param [String] key the name of the new endpoint
        # @param [XClarityClient::Endpoint] endpoint the class who manages the endpoint
        def self.add(key, endpoint)
            @@endpoints[key.to_sym] = endpoint
        end

        # Gets all the repository registered keys
        # @return [Array]
        def self.endpoints()
            @@endpoints.keys
        end

        # Gets the class who manages the endpoint associated with the key
        #
        # @param [String] key key of the endpoint
        # @return [XClarityClient::Endpoint]
        def self.endpoint_handler(key)
            handler = @@endpoints[key.to_sym]
            raise Exception, 'No endpoint defined' if handler.nil?
            handler
        end
    end
end