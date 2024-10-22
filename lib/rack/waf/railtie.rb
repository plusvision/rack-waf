module Rack
  class WAF
    class Railtie < ::Rails::Railtie
      initializer "rack-waf.middleware" do |app|
        app.middleware.insert_after(ActionDispatch::HostAuthorization, Rack::WAF)
      end
    end
  end
end
