You can use this script to create a "Twitter bootstraped" photo site with all your personal photos in.

Gems  
 The following gems need to be installed.
aws/s3, json, RMagick, exifr

Rmagick
 As I remember this caused a few issues when trying to install it. Please refernce the following document to get it installed - http://rmagick.rubyforge.org/install-faq.html

Config
 The config is set in Config.rb. The config items must be present and cannot be deleted or left empty. If you are unsure then leave the default value in place.

@access_key - Your AWS Access Key

@secret_access - Your AWS Secret 

@path - This is the path to the pictures you want to backup/show. Generally this will be something like  "/home/myusername/Pictures"

@bucket_name - This is the name of the S3 bucket you have created to host your files e.g "My.Bucket.Name"

@thumb_pixels - This is the size (in pixels) of the longest side when reduced for thumbnails. Default 128

@show_pixels - This is the size (in pixels) of the longest side when reduced for show images. 
These show images are the images that the user sees when clicking on the image. Default 600

@private_delimiter - The delimeter used to identify private (only original backed up with private permissions) images that won't be shown on the
created web site. Default "_" e.g _myimage01.jpg is private where myimage01.jpg is public.

@landingpage_delimiter - Use this to identify images that you want to be used on the sites home "splash" page. Default "lp_" e.g lp_myimage01.jpg will appear on the sites homepage.

@save_original - If you want to back up the original image (in the original size) as well as the thumbnail and show resized images. Default true. To speed things up set this to false, and you can set to true at a later date.

@supported_extensions - Array. File extensions to search for. Defualt ["jpg","png"]

@photo_gallery - Set this to false if you want to backup your original images without creating a "web front end" to view pictures. Default true

@appfiles_path = Where the "web front end" files are stored. These get transfered at the end of the process. Default "app_files"

@copyright_text - Copyright text to display at the bottom of the site.

@site_title - The title of your site.

@navigation_items - Array. Items to add to the top navigation of your site. e.g [{name: "Nav Item 1", url: "http://MySitesUrl/somewhere1.html"},{name: "Nav Item 2", url: "http://MySitesUrl/somewhere2.html"}]

Usage

Open terminal/cmd prompt to the cloned/downloaded repository and type - ./Load.rb
Keep an eye on the console for any errors.

Finally
Once finished (yes you have to wait until fully completed as app files get copied last) you can visit your S3 Bucket and (on the Website tab from the properties window) set the index.html file to be the default document. now click the supplied url and test.


Amazon AWS and S3 links
and finish the blog post explaining what it's about.