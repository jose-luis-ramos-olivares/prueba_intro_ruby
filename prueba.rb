require "uri"
require "net/http"
require "json"
require 'openssl'

def request(address)
    url = URI(address)

    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_PEER

    request = Net::HTTP::Get.new(url)

    response = https.request(request)
    JSON.parse response.read_body
end