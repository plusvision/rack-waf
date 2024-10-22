require_relative "waf/version"

require "forwardable"
require "rack"
require "rack/waf/configuration"

require "rack/waf/railtie" if defined?(::Rails)

module Rack
  class WAF
    class Error < StandardError; end

    class << self
      attr_accessor :enabled, :count_only
      attr_reader :configuration

      extend Forwardable
      def_delegators(
        :@configuration,
        :allowlist_http_method,
        :allowlist_mime_type
      )
    end

    @enabled       = true
    @count_only    = false
    @configuration = Configuration.new

    attr_reader :configuration

    def initialize(app)
      @app = app
      @configuration = self.class.configuration
    end

    def call(env)
      return @app.call(env) unless self.class.enabled

      request = Rack::Request.new(env)

      if configuration.blocked_http_method?(request.request_method)
        log_warn("http_method", request)
        return [405, { "Content-Type" => "text/plain" }, ["Method Not Allowed"]] unless self.class.count_only
      end

      if configuration.blocked_content_type?(request.content_type || "application/octet_stream")
        log_warn("content_type", request)
        return [415, { "Content-Type" => "text/plain" }, ["Unsupported Media Type"]] unless self.class.count_only
      end

      @app.call(env)
    end

    private

    def log_warn(reason, request)
      logger = request.logger || ActionView::Base.logger || Rails.logger
      return unless logger

      logger.warn("[#{self.class.name}] #{self.class.count_only ? "Counted" : "Blocked"} reason: #{reason} request: #{request.request_method} \"#{request.fullpath}\" content_type: \"#{request.content_type || "none"}\" from #{request.ip}")
    end
  end
end
