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
task :deploy  do 
  raise "APP_ENV not set!"          unless APP_ENV          =~ /\S/
  raise "AMI_SECURITY_KEY not set!" unless AMI_SECURITY_KEY =~ /\S/

  # push the content out to each of the hosts
  IO.popen("hosts -env #{APP_ENV}") do |io|
    io.each_line do |host|
      next unless host =~ /\S/
      host.gsub!(/\s/, "")

      scp "installer.tar.gz", "ubuntu@#{host}:"
      ssh host, "rm -rf installer ; tar -xzvf installer.tar.gz ; (cd installer ; /bin/bash install.sh 2>&1)"
    end
  end
end

desc "clean"
task :clean do
  exec "rm -rf #{DIST}"
end

def scp source, target
  exec "scp -i ~/.ssh/#{AMI_SECURITY_KEY}.pem -oStrictHostKeyChecking=no #{source} #{target}"
end

def ssh host, command
  exec "ssh -i ~/.ssh/#{AMI_SECURITY_KEY}.pem -oStrictHostKeyChecking=no ubuntu@#{host} '#{command}'"
end

