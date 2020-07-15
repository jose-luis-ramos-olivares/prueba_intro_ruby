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

def build_web_page(request)
    pics = request.map{|k, v| k['img_src']}
    html = "<html>\n<head>\n</head>\n\t<body>\n\t\t<ul>"
    pics.each do |pic|
        html += "\n\t\t\t<li><img src='#{pic}'></li>\n"
    end
    html += "\t\t</ul>\n\t</body>\n</html>"
    return html
end

photos = build_web_page(request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10&api_key=l8Ecjsg4vhUOYJBD8xT0I3PmeBao2xpccBQZadPg')["photos"])

File.write('output.html', photos.to_s)