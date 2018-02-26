module XClarityClient
  class API
    require 'connection/connection'
    require 'api/endpoints_repository'

    # Import all endpoints
    Dir["#{File.dirname(__FILE__)}/api/endpoints/**/*_manager.rb"].each { |f| require f }

    attr_reader :connection

    # Builds the API
    #
    # @param [Hash] connection_conf the data to create a connection with some LXCA
    # @option connection_conf [String] :host             the LXCA host
    # @option connection_conf [String] :username         the LXCA username
    # @option connection_conf [String] :password         the username password
    # @option connection_conf [String] :port             the LXCA port
    # @option connection_conf [String] :auth_type        the type of the authentication ('token', 'basic_auth')
    # @option connection_conf [String] :verify_ssl       ('PEER', 'NONE')
    # @option connection_conf [String] :user_agent_label Api gem client identification
    def self.build(connection_conf)
      new(Connection.new(connection_conf))
    end

    def initialize(connection)
      @connection = connection

      define_endpoints_getters
    end

    # Returns the Xclarity endpoints
    # @return [Array]
    def endpoints()
      EndpointsRepository.endpoints
    end

    private

    # Defines get methods to all registry endpoints
    def define_endpoints_getters()
      endpoints.each do |endpoint|
        self.class.send(:define_method, endpoint) { EndpointsRepository.endpoint_handler(endpoint.to_sym).new(@connection) }
      end
    end
  end
end