require 'api/endpoints/endpoint_manager'

module XClarityClient
  #
  # Class which manages the /nodes endpoint
  #   /nodes handle with all managed components on Xclarity
  #   ex: physical servers, switches, chassis, racks
  #
  class NodesManager < EndpointManager
    require 'api/endpoints/nodes/node'

    add_endpoint 'nodes', XClarityClient::NodesManager

    # @see XClarityClient::EndpointManager#model
    def model()
      XClarityClient::Node
    end
  end
end