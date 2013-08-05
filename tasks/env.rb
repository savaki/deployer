# allow for easy assignment of environment variables
#
def env default, *names
  value = nil
  names.each do |name|
    if ENV[name] =~ /\S/
      value = ENV[name]
      break
    end
  end

  value = default unless value =~ /\S/
  value
end

AWS_ACCESS_KEY_ID     = ENV["AWS_ACCESS_KEY_ID"]
AWS_SECRET_ACCESS_KEY = ENV["AWS_SECRET_ACCESS_KEY"] 

APP_NAME              = ENV["APP_NAME"]

VERSION               = env("SNAPSHOT-#{Time.now.to_i}", "GO_PIPELINE_C OUNTER")

DIST                  = "dist"

BUNDLE                = "installer-#{APP_NAME}-#{VERSION}.tar.gz"

PACKAGES              = env("", "PACKAGES").gsub(/\s/, "").split(/,/)

raise "AWS_ACCESS_KEY_ID not set!"     unless AWS_ACCESS_KEY_ID      =~ /\S/
raise "AWS_SECRET_ACCESS_KEY not set!" unless AWS_SECRET_ACCESS_KEY  =~ /\S/
raise "PACKAGES not set!"              unless PACKAGES[0]            =~ /\S/

raise "APP_NAME not set!"              unless APP_NAME =~ /\S/
