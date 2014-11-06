require 'uri'

module Phase5
  class Params
    attr_accessor :params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
        @params = {}

        if req.query_string 
            parse_www_encoded_form(req.query_string).each do |param|
                @params[param.first] = param.last
            end
        end

        if req.body
            parse_www_encoded_form(req.body).each do |param|
                @params[param.first] = param.last
            end
        end
        
        @params = @params.merge(route_params)
    end

    def [](key)
        @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
        keysets = []
        values = []

        URI::decode_www_form(www_encoded_form).each do |k, v|
            keysets << parse_key(k)
            values << v
        end

        current = @Params
        build_hash(keysets, values)
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
        key.split(/\]\[|\[|\]/)
    end

    def build_hash(keysets, values)
        current = @params

        keysets.each_with_index do |keyset, idx|
            keyset.each_with_index do |key,inner_idx|
                if inner_idx + 1 == keyset.length
                    current[key] = values[idx]
                    break
                end
                current[key]||= {}
                current = current[key]
            end
        end
        @params        
    end
  end
end
