require 'api/endpoints_repository'

module XClarityClient
  #
  # Abstract class that provides common methods for endpoints managers
  #
  class EndpointManager
    @@endpoint_name

    # Adds the endpoint on the repository
    #
    # Must be called on all XClarityClient::EndpointManager subclasses
    #
    # @param [String] endpoint_name key that identifies the endpoint manager
    # @param [Class]  klass XClarityClient::EndpointManager subclass
    def self.add_endpoint(endpoint_name, klass)
      @@endpoint_name = endpoint_name
      EndpointsRepository.add(endpoint_name, klass)
    end

    def initialize(connection)
      @connection = connection
    end

    # Gets endpoint model
    #
    # @return [XClarityClient::EndpointModel]
    def model()
      raise NotImplementedError, "must be implemented in subclass"
    end

    # @see XClarityClient::ManagementMixin#get_object
    def fetch(uuids, includeAttributes, excludeAttributes)

    end

    # @see XClarityClient::ManagementMixin#get_all_resources
    def fetch_all(opts = {})
      $lxca_log.info "XclarityClient::ManagementMixin get_all_resources", "Sending request to #{resource} resource"

      response = @connection.do_get(model::BASE_URI, opts)

      $lxca_log.info "XclarityClient::ManagementMixin get_all_resources", "Response received from #{resource::BASE_URI}"

      return [] unless response.success?

      mount_response(response)
    end

    private

    def mount_response(response)
      body = JSON.parse(response.body)

      # TODO: implement this on UserManager
      # if resource == XClarityClient::User
      #   body = body['response']
      # end

      list_name, body = add_listname_on_body(resource, body)

      body[list_name].map do |resource_params|
        resource.new resource_params
      end
    end

    # Process the response body to make sure that its contains the list name defined on resource
    # Returns the list name present on body and the body itself
    def add_listname_on_body(resource, body)
      body.kind_of?(Array) ? process_body_as_array(resource, body) : process_body_as_hash(resource, body)
    end

    # Return any listname described on resource
    def any_listname_of(resource)
      if resource::LIST_NAME.kind_of?(Array)
        resource::LIST_NAME.first # If is an array, any listname can be use
      else
        resource::LIST_NAME # If is not an array, just return the listname of resource
      end
    end

    # Returns the body value assigned to the list name defined on resource
    def process_body_as_array(resource, body)
      list_name = any_listname_of(resource)

      return list_name, { list_name => body } # assign the list name to the body
    end

    # Discover what list name defined on resource is present on body
    # If none of then is find assume that the body is a single resource
    # and add it value into array and assing to any list name
    def process_body_as_hash(resource, body)
      result = body

      if resource::LIST_NAME.kind_of? Array # search which list name is present on body
        list_name = resource::LIST_NAME.find { |name| body.keys.include?(name) && body[name].kind_of?(Array) }
      else
        list_name = any_listname_of(resource)
      end
      result = {list_name => [body]} unless body.has_key? list_name # for the cases where body represents a single resource
      return list_name, result
    end
  end
end
