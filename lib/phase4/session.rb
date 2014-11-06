require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
        @cookies = {}
        req.cookies.each do |cookie|
            if cookie.name == '_rails_lite_app'
               hash = JSON.parse cookie.value
               @cookies[hash.keys.first] = hash.values.first
            end
        end

        @cookies
    end

    def [](key)
        @cookies[key]
    end

    def []=(key, val)
        @cookies[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
        hash = @cookies.to_json
        res.cookies << WEBrick::Cookie.new('_rails_lite_app', hash) 
    end
  end
end
