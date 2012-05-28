require 'json'
require './Config'
require './Cloud'
require 'RMagick'
require 'exifr'

class S3Photo

	def initialize(config)
		@config = config
		@timestamp = DateTime.now.to_s()
		@landingpage_array = []

		@cloud = CloudS3Photo.new
		@cloud.connect(config)
		
		
	end

	def add_images(the_path)
		dir_hash = Hash.new

		if(the_path === @config.path)
			dir_hash["name"] = "Home"
		else
			dir_hash["name"] = the_path.split("/").last
		end

		dir_hash["path"] = the_path.sub(@config.path, "")
		
		# private_directory = is_private(dir_hash["path"])

		# puts private_directory

		file_array = Array.new
		dir_array = Array.new
		
		arrDir = Dir[File.join(the_path, "*")].sort_by {|a| File.stat(a).mtime}

		arrDir.select{|file|
			
			if File.ftype(file) == "file" then
				puts "File Name - "+file
				full_path = file
				name = file.split("/").last	
				extension = name.split(".").last

				if(@config.supported_extensions.include?(extension.downcase))
					relative_path = file.sub(@config.path + "/", "")

					if(@config.save_original != false)
						
						if !@cloud.object_exist(relative_path) then
						
							image = get_image(file)
								
							if(@config.original_pixels)
								image = image.resize_to_fit(@config.original_pixels, @config.original_pixels)
							end
						
							@cloud.upload_blob(relative_path, image.to_blob, @timestamp, :private)
							@cloud.update_timestamp(relative_path, @config.bucket_name, @timestamp, :private)
						else
							#ToDo - Find a way to bring back metadata (and not the image).
							#Uncomment this line when you need to...
							
							@cloud.update_timestamp(relative_path, @config.bucket_name, @timestamp, :private)
						end
					end

					if(@config.photo_gallery != false)

						if !is_private(file) then
							#Only add to json if image is not private!!
							file_hash = Hash.new
							file_hash = name
							file_array[file_array.length] = file_hash

							image_path = relative_path.sub(name, "thumb_"+name)
							if !@cloud.object_exist(image_path) then
								image = get_image(file)

								image_resized = image.resize_to_fit(@config.thumb_pixels, @config.thumb_pixels)
								@cloud.upload_blob(image_path, image_resized.to_blob, @timestamp, :public_read)
								@cloud.update_timestamp(image_path, @config.bucket_name, @timestamp, :public_read)
							else
								@cloud.update_timestamp(image_path, @config.bucket_name, @timestamp, :public_read)
							end

							image_path = relative_path.sub(name, "show_" + name)
							if !@cloud.object_exist(image_path) then
								image = get_image(file)

								image_resized = image.resize_to_fit(@config.show_pixels, @config.show_pixels)
								@cloud.upload_blob(image_path, image_resized.to_blob, @timestamp, :public_read)
								@cloud.update_timestamp(image_path, @config.bucket_name, @timestamp, :public_read)
							else
								@cloud.update_timestamp(image_path, @config.bucket_name, @timestamp, :public_read)
							end
						end

					end

					if(name[0, @config.landingpage_delimiter.length] == @config.landingpage_delimiter)
						@landingpage_array[@landingpage_array.length] = relative_path
					end

				else
					puts "Ignoring file with extension - "+extension.downcase
				end
			end
		}

		dir_hash["files"] = file_array

		Dir[File.join(the_path, "*")].select{|file|
			next if file == '.' or file == '..' or file == '...'

			folder_name = file.split("/").last
			if File.ftype(file) == "directory" then
					folder_hash = add_images(file)

					if !is_private(file) then
						dir_array[dir_array.length] = folder_hash
					end
					
			end
		}

		dir_hash["folders"] = dir_array

		return dir_hash
	end

	def add_home_images()
		return @landingpage_array
	end

	def remove_images()
		@cloud.remove_dated_images(@timestamp)
	end

	def is_private(full_file_path)
		if (full_file_path.index('/'+@config.private_delimiter))
			return true
		end

		return false
	end

	def get_image(file)
		image = Magick::Image.read(file).first

		exif = EXIFR::JPEG.new(file).exif

		if(exif)
			image_orientation = exif.orientation
			if(image_orientation.to_i > 0)
				image = image_orientation.transform_rmagick(image)
			end
		end

		return image
	end

	def create_json(this_hash)
		aFile = File.new(@config.appfiles_path+"/images.json", "w")
		if aFile
		   aFile.syswrite(this_hash.to_json)
		else
		   puts "Error - Unable to open json file!"
		end
		aFile.close
	end

	def create_javascript_config()
		content = "var config = {"
		content << "landingpage_delimiter: '"+@config.landingpage_delimiter+"',"
		content << "copyright_text: '"+@config.copyright_text+"',"
		content << "site_title: '"+@config.site_title+"',"
		content << "url: 'http://"+@config.bucket_name+"."+@config.default_host+"',"
		content << "navigation_items: "+@config.navigation_items.to_json
		content << "}"

		File.open(@config.appfiles_path+"/config.js", 'w') {|f| f.write(content) }
	end

	def upload_app_files(path)

		arrDir = Dir[path+"/*"]
		arrDir.select{|obj|
			next if obj == '.' or obj == '..' or obj == '...'

			if File.ftype(obj) == "file" then
				file_name = obj.sub(@config.appfiles_path+"/","")
				@cloud.upload_file(file_name, obj, @timestamp, :public_read)
			elsif File.ftype(obj) == "directory" then
				upload_app_files(obj)
			end
		}

	end

	
end