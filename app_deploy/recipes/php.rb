#
# Cookbook Name:: app_deploy
# Recipe:: php
#

s3_bucket_name = node['app']['deploy']['s3_bucket_name']
doc_root = node['app']['deploy']['doc_root']
environment = node['app']['deploy']['environment']
file_name = node['app']['deploy']['file_name']


directory "#{doc_root}" do
  owner 'apache'
  group 'apache'
  mode '0644'
  recursive true
end

s3_file "#{doc_root}/#{file_name}" do
    remote_path "/#{environment}/#{file_name}"
    bucket "#{s3_bucket_name}"
    owner "apache"
    group "apache"
    mode "0644"
    action :create
end

execute 'extract_package' do
  command "tar -xf #{file_name}"
  cwd "#{doc_root}"
end

file "#{doc_root}/#{file_name}" do
  action :delete
  only_if { File.exist? "#{doc_root}/#{file_name}" }
end