require 'faraday'
require 'faraday-cookie_jar'
require 'uri'
require 'uri/https'

module XClarityClient
  class Connection
    def initialize(configuration)
      @configuration = configuration
    end

    def valid?()
      not open.nil?
    end

    def do_get(uri, opts = {})
      connect do |connection|
        begin
          connection.get(uri + mount_url_query(opts))
        rescue Faraday::Error::ConnectionFailed => e
          $lxca_log.error "XClarityClient::XclarityBase connection", "Error trying to send a GET to #{uri + query}"
          Faraday::Response.new
        end
      end
    end

    def do_post(uri, request_body = {})
      connect do |connection|
        begin
          connection.post do |req|
            mount_request(req, uri, request_body)
          end
        rescue
          $lxca_log.error "XClarityClient::XclarityBase do_post", "Error trying to send a POST to #{uri}"
          $lxca_log.error "XClarityClient::XclarityBase do_post", "Request sent: #{request_body}"
          Faraday::Response.new
        end
      end
    end

    def do_put (uri="", request_body = {})
      connect do |connection|
        begin
          connection.put do |req|
            mount_request(req, uri, request_body)
          end
        rescue
          $lxca_log.error "XClarityClient::XclarityBase do_put", "Error trying to send a PUT to #{uri}"
          $lxca_log.error "XClarityClient::XclarityBase do_put", "Request sent: #{request_body}"
          Faraday::Response.new
        end
      end
    end

    def do_delete (uri="")
      connect do |connection|
        connection.delete do |req|
          mount_request(req, uri)
        end
      end
    end

    private

    def open()
      $lxca_log.info "XClarityClient::Connection open", "Building the url"
      #Building configuration
      hostname = URI.parse(@configuration.host)
      url = URI::HTTPS.build({ :host     => hostname.scheme ? hostname.host : hostname.path,
                               :port     => @configuration.port.to_i,
                               :path     => uri,
                               :query    => hostname.query,
                               :fragment => hostname.fragment }).to_s

      $lxca_log.info "XClarityClient::XClarityBase connection_builder", "Creating connection to #{url}"

      connection = Faraday.new(url: url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT -- This line, should be uncommented if you wanna inspect the URL Request
        faraday.use :cookie_jar if @configuration.auth_type == 'token'
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        faraday.ssl[:verify] = @configuration.verify_ssl == 'PEER'
      end

      connection.headers[:user_agent] = "LXCA via Ruby Client/#{XClarityClient::VERSION}" + (@configuration.user_agent_label.nil? ? "" : " (#{@configuration.user_agent_label})")
      connection.basic_auth(@configuration.username, @configuration.password) if @configuration.auth_type == 'basic_auth'
      $lxca_log.info "XClarityClient::XclarityBase connection_builder", "Connection created Successfuly"
      connection
    end

    def invalidate()
    end

    def connect()
      connection = open
      yield(connection)
    ensure
      invalidate
    end

    # Mounts query params to be appended on URL
    #
    # @param [Hash] opts hash containing the query params
    #
    # @return [String] string to be appended on URL
    def mount_url_query(opts)
      opts.size > 0 ? "?" + opts.map {|k, v| "#{k}=#{v}"}.join(",") : ""
    end

    def mount_request(request, uri, body = {})
      request.url uri
      request.headers['Content-Type'] = 'application/json'
      request.body = body
    end
  end
end