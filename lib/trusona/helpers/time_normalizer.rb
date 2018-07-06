# frozen_string_literal: true

module Trusona
  module Helpers
    ##
    # Normalizes Strings, Date, DateTime, and Time into a UTC Time object
    module TimeNormalizer
      def normalize_time(time)
        return nil if time.nil?
        return time.to_time.gmtime if time.is_a?(DateTime)
        return time.gmtime if time.is_a?(Time)
        return Time.parse(time).gmtime if time.is_a?(String)
        return nil if time.is_a?(Date)
      end
    end
  end
end
