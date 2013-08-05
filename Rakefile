require File.expand_path(File.dirname(__FILE__) + '/tasks/env')
require File.expand_path(File.dirname(__FILE__) + '/tasks/debian')

task :default do
end

desc "prepare debian package"
task :prepare do 
  prepare_debian_package
end

desc "upload bundle to S3"
task :upload => :prepare do
  upload_to_s3
end

desc "deploy project to hosts"
task :deploy => :copy_to_s3 do 
end

desc "clean"
task :clean do
  exec "rm -rf #{DIST}"
end
