class S3PhotoConfig
  attr_accessor :default_host, :access_key, :secret_access, :path, :bucket_name, :original_pixels, 
  :thumb_pixels, :show_pixels, :private_delimiter, :save_original, :supported_extensions,
  :photo_gallery, :landingpage_delimiter, :appfiles_path, :copyright_text, :site_title, :navigation_items

  def initialize
  	@default_host = "s3-eu-west-1.amazonaws.com"
  	AWS::S3::DEFAULT_HOST.replace default_host
  	
    
  	@access_key = "MyAwsAccessKey"
  	@secret_access = "MyAwsSecret"
  	@path = "/home/mrsUser/Pictures"
    @bucket_name = "My.Bucket.Name"
    @thumb_pixels = 128
  	@show_pixels = 600
  	@private_delimiter = "_"
  	@landingpage_delimiter = "lp_"
  	@save_original = true
    @supported_extensions = ["jpg","png"]
  	@photo_gallery = true
  	@appfiles_path = "app_files"
  	@copyright_text = "Great Pics Ltd 2012"
  	@site_title = "My Great Pics!"
  	@navigation_items = [{name: "Home", url: "http://MySitesUrl"},{name: "Blog", url: "http://MySitesUrl/blog.html"},{name: "About", url: "http://MySitesUrl/about.html"},{name: "Contact", url: "http://MySitesUrl/contact.html"}]
  end

end