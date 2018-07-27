require 'json'
require 'pathname'

module XClarityClient
  class HostPlatformManagement < XClarityBase

    include XClarityClient::ManagementMixin

    def initialize(conf)
        super(conf, HostPlatform::BASE_URI)
    end

    def population
        get_all_resources(HostPlatform)
    end

    def get_osimage_deployment_status(uuid)
        if Schemas.validate_input_parameter("uuid", uuid, String)
          response = connection("#{HostPlatform::BASE_URI}/#{uuid}")
          response = JSON.parse(response.body)
        end
    end

    def deploy_osimage(opts=[])
        request_body = JSON.generate(opts)
        if Schemas.validate_input("deploy_osimage", request_body)
          response = do_put("#{HostPlatform::BASE_URI}", request_body)
          response = JSON.parse(response.body)
        end
    end
  end
end
