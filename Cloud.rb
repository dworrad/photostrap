require 'RMagick'
require 'aws/s3'
include AWS::S3

class CloudS3Photo
	def connect(config)
		@config = config
		@current_files_array = Array.new
		Base.establish_connection!(
		  :access_key_id     => @config.access_key,
		  :secret_access_key => @config.secret_access
		)
	end

	def getbucket(bucket_name)
		return Bucket.find(bucket_name)
	end

	def upload_file(relative_path, file, timestamp, access_level)
		puts "uploading file "+relative_path+" access level is "+access_level.to_s
		S3Object.store(relative_path, open(file), @config.bucket_name,
			{:access => access_level, 'x-amz-meta-upload-date' => timestamp}
			)
	end

	def upload_blob(relative_path, blob, timestamp, access_level)
		puts "uploading blob "+relative_path+" access level is "+access_level.to_s
		S3Object.store(relative_path, blob, @config.bucket_name,
			{:access => access_level, 'x-amz-meta-upload-date' => timestamp}
			)
	end

	def update_timestamp(relative_path, bucket_name, timestamp, access_level)
		puts "updating timestamp/array for "+relative_path
		#ToDo - Find a way to update the metadata without downloading the Object!
		
		# #ToDo - Uncomment this when needed
		# image = S3Object.find relative_path, bucket_name
		# image.store({:access => access_level, 'x-amz-meta-upload-date' => timestamp})

		@current_files_array[@current_files_array.length] = relative_path
	end

	def remove_dated_images(timestamp)
		#delete_array = Array.new
		puts "Starting delete...."

		getbucket(@config.bucket_name).objects.each do |image|
		 	#ToDo - Need to find a way to check images metadata without bringing the whole object back.
		 	#       may have to write my own restful call to s3
			
			# if (image.metadata["x-amz-meta-upload-date"]) #only added images to be deleted
			# 	if image.metadata["x-amz-meta-upload-date"] != timestamp
			# 		delete_array[delete_array.length] = image.key()
			# 	end
			# end

			if !@current_files_array.include?(image.key())
				puts "Deleting file - "+image.key()
				S3Object.delete image.key(), @config.bucket_name
			end
		end

		# delete_array.each { |image|
		# 	puts "deleteing "+image+" from "+@config.bucket_name
		# 	S3Object.delete image, @config.bucket_name
		# }
	end

	def object_exist(file_path)
		return S3Object.exists? file_path, @config.bucket_name
	end

end