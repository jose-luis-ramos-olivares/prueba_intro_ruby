require "uri"
require "net/http"
require "json"
require 'openssl'

def request(address, api_key="l8Ecjsg4vhUOYJBD8xT0I3PmeBao2xpccBQZadPg")
  url = URI("#{address}&api_key=#{api_key}")
  
  https = Net::HTTP.new(url.host, url.port);
  https.use_ssl = true
  https.verify_mode = OpenSSL::SSL::VERIFY_PEER
  
  request = Net::HTTP::Get.new(url)
  request['app_id'] = '1efc46b5-f672-4501-a4d2-5296edd0fe00'
  request['app_key'] = 'l8Ecjsg4vhUOYJBD8xT0I3PmeBao2xpccBQZadPg'
  
  response = https.request(request)
  JSON.parse response.read_body
end

def build_web_page(request)
  pics = request.map{ |filter| filter['img_src'] }
  html = "<html>\n<head>\n</head>\n\t<body>\n\t\t<ul>"
  pics.each do |pic|
    html += "\n\t\t\t<li><img src='#{pic}'></li>\n"
  end
  html += "\t\t</ul>\n\t</body>\n</html>"
  return html
end

photos = build_web_page(request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10')["photos"])
File.write('mars_photos.html', photos.to_s)

def photos_count(request)
  camera_name = request.map{ |filter| filter['camera']['name'] }
  grouped = camera_name.group_by{ |cam_name| cam_name }
  num_photo = grouped.each do |cam_grouped, photo_qty|
    grouped[cam_grouped] = photo_qty.count 
  end
  return num_photo
end

pp photos_count(request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10')["photos"])