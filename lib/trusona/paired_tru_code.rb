# frozen_string_literal: true

module Trusona
  class PairedTruCode
    def self.find(trucode_id)
      Trusona::Workers::PairedTruCodeFinder.new.find(trucode_id)
    end
  end
end
