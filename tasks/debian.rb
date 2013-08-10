require File.expand_path(File.dirname(__FILE__) + '/env')

def create_debian_package
end

def prepare_debian_package
  # create the installer directory
  #
  exec "mkdir -p #{DIST}/installer"

  # find the specific packages to be copied, ensuring that we have exactly 1 of each
  #
  packages = []
  PACKAGES.each do |package|
    files = find_files(package)
    raise "no packages found with prefix, #{package}" unless files.length == 1
    exec "cp #{files[0]} #{DIST}/installer"
    packages << files[0]
  end

  # write out the installation file
  #
  File.open("#{DIST}/installer/install.sh", "w") do |io|
    io.puts <<EOF
#!/bin/bash

set -u
set -e

for package in #{packages.join(' ')}
do
  echo installing package, ${package}
  sudo dpkg -i `dirname $0`/${package}
done

EOF
  end

  # ensure the installation file is executable
  #
  exec "chmod 755 #{DIST}/installer/install.sh"

  # package up the installer into the distribution file
  #
  exec "(cd #{DIST} ; tar -czvf ../installer.tar.gz installer)"
end

def upload_to_s3
  exec "s3cp installer.tar.gz s3:#{BUNDLE}"
end

def find_files prefix
  Dir.entries(".").select { |f| f =~ /#{prefix}_.*.deb/ }
end

def exec command
  puts command
  raise "unable to execute command, #{command}" unless system command
end
