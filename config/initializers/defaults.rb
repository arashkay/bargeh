module APP
  
  yaml = File.join(Rails.root, 'config', 'defaults.yml')
  if File.exist?(yaml) then
    hash = YAML.load_file(yaml)
    configs = (hash.has_key?('general') && !hash['general'].blank?) ? hash['general'] : {}
    configs = configs.merge(hash[Rails.env]) unless hash[Rails.env].blank?
  else
    puts "Please create #{yaml} file in your /config folder"
    raise "Missing file"
  end
  
  CONFIGS = configs

  module SEARCH
    DISTANCE = APP::CONFIGS['search']['distance']
    LIMIT = APP::CONFIGS['search']['limit']
  end

  module LISTING
    LIMIT = APP::CONFIGS['listing']['limit']
    BULK  = APP::CONFIGS['listing']['bulk_limit']
  end

  module RESQUE
    NOTIFICATIONS = "#{APP::CONFIGS['prefix']}_#{APP::CONFIGS['resque']['queues']['notifications']}"
  end

  module NOTIFICATIONS
  end

  module PHOTO
    STYLE = { large580: '580x580#', small180: '180x180#', thumb: '100x100#' }
    TYPES = ["image/jpg", "image/jpeg", "image/png"]
  end

  module DEVICE
    IOS = 'ios'
    ANDROID = 'android'
  end
  
  module ROLES
    WIZARD   = 'wizard'
    HOBBIT   = 'hobbit'
    CREATURE = 'creature'
  end

end
 
# IMAGE
Paperclip::Attachment.default_options[:styles] = { thumb: '100x100#' }
Paperclip::Attachment.default_options[:default_url] = "/assets/:class.png"

# JSON
Rabl.configure do |config|
  config.include_json_root = false
  config.include_child_root = false
end

# GEO
# Geocoder.configure lookup: :google, api_key: "AIzaSyCBSzBDmJekpUpguBOTcUTL_6s6f3zKNiA"

# NOTIFICATION
APNS.host = 'gateway.push.apple.com'
APNS.pem  = APP::CONFIGS['notification']['pem_path']
GCM.key = APP::CONFIGS['notification']['gcm_key']
