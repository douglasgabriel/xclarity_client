module XClarityClient
  class FanMux
    include XClarityClient::Resource

    BASE_URI = '/fanMuxes'.freeze
    LIST_NAME = 'fanMuxList'.freeze

    attr_accessor :cmmDisplayName, :cmmHealthState, :dataHandle, :description, :FRU, :fruSerialNumber, :hardwareRevision,
                  :leds, :machineType, :manufactureDate, :manufacturer, :manufacturerId, :model, :name, :parent, :partNumber, :productId, 
                  :productName, :serialNumber, :slots, :status, :type, :uri, :uuid


    def initialize(attributes)
      build_resource(attributes)
    end

  end
end
