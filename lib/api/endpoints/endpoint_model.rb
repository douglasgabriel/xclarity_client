module XClarityClient
  #
  # Abstract class that provides common methods for endpoints models
  #
  # @abstract
  #
  class EndpointModel
    def initialize(attributes)
      build_resource(attributes)
    end

    private

    def build_resource(attributes)
      attributes.each do |key, value|
        begin
          value = value.gsub("\u0000", '') if value.is_a?(String)
          key = key.to_s.gsub("-","_")
          send("#{key}=", value)
        rescue
          $log.warn("UNEXISTING ATTRIBUTES FOR #{self.class}: #{key}") unless defined?(Rails).nil?
        end
      end
    end

    def to_hash
      hash = {}
      instance_variables.each {|var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
      hash
    end
  end
end
