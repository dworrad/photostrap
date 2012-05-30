<h2>Photostrap</h2>
Create a "Twitter bootstraped" personal photo site with all your personal photos (you can also set individual folders and images as private). Check out the <a href="http://testing.worrad.me.s3-website-eu-west-1.amazonaws.com/" target="_blank">example</a> site. It "backs up" all your photos too.
I created photostrap because every other way of sharing and backing up that I trialled had issues. I wanted 3 things from a cloud photo solution - To still own the data, One click upload, Browsable and backed up, Reasonable cost. So I created Photostrap which uses Ruby, Twitter Bootstrap and Amazon S3.


<h3>Pre Reqs</h3>
<b>Gems</b> - The following gems need to be installed. AWS/S3, JSON, RMagick, exifr

<b>Rmagick</b>
 As I remember this caused a few issues when trying to install it. Please reference the following document to get it installed - http://rmagick.rubyforge.org/install-faq.html

<h3>Config</h3>
 To configure how the script runs then change the values in the Config.rb file. All config items must be present and cannot be deleted or left empty. If you are unsure then leave the default value in place.

<b>access_key</b> - Your AWS Access Key (You can find this when logging into the Amazon AWS Admin concole)

<b>secret_access</b> - Your AWS Secret (You can find this when logging into the Amazon AWS Admin concole)

<b>path</b> - This is the path to the pictures you want to backup/show. Generally this will be something like  "/home/myusername/Pictures". <b>**Don't trial it with your whole photo album</b>... test it out with 2 or 3 folders of 10/20 pics first.. this way you don't waste time/bandwith before you can evaluate if this is a good fit for your pics.

<b>bucket_name</b> - This is the name of the S3 bucket you have created to host your files e.g "My.Bucket.Name"

<b>thumb_pixels</b> - This is the size (in pixels) of the longest side when reduced for thumbnails. Default 128

<b>show_pixels</b> - This is the size (in pixels) of the longest side when reduced for show images. These show images are the images that the user sees when clicking on the image. Default 600

<b>private_delimiter</b> - The delimeter used to identify private images that won't be shown on the created site. All private photos get uploaded as non public. Default "_" e.g _myimage01.jpg is private where myimage01.jpg is public.

<b>landingpage_delimiter</b> - Use this to identify images that you want to be used on the sites home "splash" page. Default "lp_" e.g lp_myimage01.jpg will appear on the sites homepage.

<b>save_original</b> - If you want to back up the original image (in the original size) as well as the "thumbnail" and "show" resized images. Default true. To speed things up set this to false, and you can set to true at a later date.

<b>supported_extensions</b> - Array. File extensions to search for. Defualt ["jpg","png"]

<b>photo_gallery</b> - Set this to false if you want to backup your original images without creating a "twitter bootstrapped" site to view your pictures. Default true

<b>appfiles_path</b> = Where the "web front end" files are stored. These get transfered at the end of the process. Default "app_files"

<b>copyright_text</b> - Copyright text to display at the bottom of the site.

<b>site_title</b> - The title of your site.

<b>navigation_items</b> - Array. Items to add to the top navigation of your site. e.g [{name: "Nav Item 1", url: "http://MySitesUrl/somewhere1.html"},{name: "Nav Item 2", url: "http://MySitesUrl/somewhere2.html"}]

<h3>Usage</h3>
Once you have your config set... ./Load.rb

<h3>Finally</h3>
Once finished (yes you have to wait until fully completed as app files get copied last) you can visit your S3 Bucket and (on the Website tab from the properties window) set the index.html file to be the default document. now click the supplied url and test.

<h3>Roadmap</h3>
I'd like to add several bits including - basic auth layer, comments, geo data... and a few other bits.... If I can find some time.
Also might add support for github hosting