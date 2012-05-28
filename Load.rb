#!/usr/bin/env ruby
require 'rubygems'
require './Config'
require './S3Photo'


config = S3PhotoConfig.new
json_hash = Hash.new

s3photo = S3Photo.new(config)
json_hash = s3photo.add_images(config.path)
json_hash["files"] = s3photo.add_home_images()
s3photo.remove_images()

s3photo.create_json(json_hash)
s3photo.create_javascript_config()
s3photo.upload_app_files(config.appfiles_path)

#puts json_hash