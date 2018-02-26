require 'spec_helper'

describe XClarityClient do

  before :all do
    WebMock.allow_net_connect! #-- Uncomment this line if you're testing with a external mock.

    conf = XClarityClient::Configuration.new(
    :username => ENV['LXCA_USERNAME'],
    :password => ENV['LXCA_PASSWORD'],
    :host     => ENV['LXCA_HOST'],
    :port     => ENV['LXCA_PORT'],
    :auth_type => ENV['LXCA_AUTH_TYPE'],
    :verify_ssl => ENV['LXCA_VERIFY_SSL']
    )

    @client = XClarityClient::Client.new(conf)

  end

  before :each do
    @includeAttributes = %w(nodeCount partition)
    @excludeAttributes = %w(nodeCount partition)
    @uuidArray = @client.discover_scalableComplexes.map { |scalableComplex| scalableComplex.uuid }
  end

  it 'has a version number' do
    expect(XClarityClient::VERSION).not_to be nil
  end

  describe 'GET /scalableComplexes' do

    it 'should respond with an array' do
      expect(@client.discover_scalableComplexes.class).to eq(Array)
    end

=begin
    context "with includeAttributes" do
      before :each do
        @response = @client.fetch_scalableComplexes(nil,@includeAttributes,nil)
      end

      it 'missing attributes should be nil' do
        @response.map do |scalableComplex|
          @includeAttributes.map do |attribute|
            expect(scalableComplex.send(attribute)).not_to be_nil
          end
        end
      end
    end
=end
# This block above must be uncomment when the parameter has been fixed

    context "with excludeAttributes" do
      it 'missing attributes should be nil' do
        @response = @client.fetch_scalableComplexes(nil,nil,@excludeAttributes)
        @response.map do |scalableComplex|
          @excludeAttributes.map do |attribute|
            expect(scalableComplex.send(attribute)).to be_nil
          end
        end
      end
    end
  end

  describe 'GET /scalable_complexes/UUID' do

=begin
    context "with includeAttributes" do
      before :each do
        @response = @client.fetch_scalableComplexes(@uuidArray, @includeAttributes)
      end

      it 'missing attributes should be nil' do
        @response.map do |scalableComplex|
          @includeAttributes.map do |attribute|
            expect(scalableComplex.send(attribute)).not_to be_nil
          end
        end
      end
    end
=end
# This block above must be uncomment when the parameter has been fixed

    context "with excludeAttributes" do

      it 'missing attributes should be nil' do
        @response = @client.fetch_scalableComplexes(@uuidArray, nil, @excludeAttributes)
        @response.map do |scalableComplex|
          @excludeAttributes.map do |attribute|
            expect(scalableComplex.send(attribute)).to be_nil
          end
        end
      end
    end
  end
end
