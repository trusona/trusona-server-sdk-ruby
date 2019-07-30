require 'httparty'

class Buster
  def initialize
    @url = 'https://buster.staging.trusona.net'
  end

  def callback_url(id)
    "#{@url}/callbacks/#{id}"
  end

  def callback_result(id)
    HTTParty.get(callback_url(id))
  end
end