module Rack
  class WAF
    class Configuration
      # https://github.com/rails/rails/blob/7-0-stable/actionpack/lib/action_dispatch/http/request.rb
      DEFAULT_HTTP_METHOD_SET = %w[
        OPTIONS GET HEAD POST PUT DELETE TRACE CONNECT
        PROPFIND PROPPATCH MKCOL COPY MOVE LOCK UNLOCK
        VERSION-CONTROL REPORT CHECKOUT CHECKIN UNCHECKOUT MKWORKSPACE UPDATE LABEL MERGE BASELINE-CONTROL MKACTIVITY
        ORDERPATCH
        ACL
        SEARCH
        MKCALENDAR
        PATCH
      ].to_set

      # https://github.com/rack/rack/blob/2-2-stable/lib/rack/mime.rb
      DEFAULT_MIME_TYPE_SET = ::Rack::Mime::MIME_TYPES.values.to_set

      # https://github.com/rails/rails/blob/7-0-stable/actionpack/lib/action_dispatch/http/mime_type.rb
      DEFAULT_MIME_NAME            = "[a-zA-Z0-9][a-zA-Z0-9#{Regexp.escape('!#$&-^_.+')}]{0,126}"
      DEFAULT_MIME_PARAMETER_VALUE = "#{Regexp.escape('"')}?#{DEFAULT_MIME_NAME}#{Regexp.escape('"')}?"
      DEFAULT_MIME_PARAMETER       = "\s*;\s*#{DEFAULT_MIME_NAME}(?:=#{DEFAULT_MIME_PARAMETER_VALUE})?"
      DEFAULT_MIME_REGEXP          = /\A(?:\*\/\*|#{DEFAULT_MIME_NAME}\/(?:\*|#{DEFAULT_MIME_NAME})(?>#{DEFAULT_MIME_PARAMETER})*\s*)\z/

      attr_accessor :allowlist_http_method, :allowlist_mime_type

      def initialize
        set_default
      end

      def clear_configuration
        set_default
      end

      def blocked_http_method?(http_method)
        !@allowlist_http_method.include?(http_method)
      end

      def blocked_content_type?(content_type)
        !content_type.downcase.split(";").any? do |type|
          @allowlist_mime_type.include?(type.strip) | !!DEFAULT_MIME_REGEXP.match?(type.strip)
        end
      end

      private

      def set_default
        @allowlist_http_method = DEFAULT_HTTP_METHOD_SET
        @allowlist_mime_type   = DEFAULT_MIME_TYPE_SET
      end
    end
  end
end
