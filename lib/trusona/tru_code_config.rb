# frozen_string_literal: true

module Trusona
  ##
  #
  class TruCodeConfig
    def relying_party_id
      jwt     = Trusona.config.token ||
                raise_token_error
      middle  = jwt_body(jwt)
      decoded = Base64.decode64(middle)
      parsed = parse_jwt(decoded)
      relying_party_id = extract_subject(parsed)

      relying_party_id
    end

    private

    def jwt_body(jwt)
      split_jwt = jwt.split('.')
      raise_token_error if split_jwt.empty? || split_jwt[1].nil?
      split_jwt[1]
    end

    def parse_jwt(decoded)
      JSON.parse(decoded)
    rescue JSON::ParserError
      raise_token_error('JWT Format is Invalid.')
    end

    def extract_subject(parsed)
      raise_token_error('Subject is Missing.') if parsed['sub'].nil?
      parsed['sub']
    end

    def raise_token_error(msg = 'API Token is missing.')
      raise(Trusona::ConfigurationError, msg)
    end
  end
end
