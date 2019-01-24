#
# Cookbook Name:: app_deploy
# Recipe:: php
#

s3_bucket_name = node['app']['deploy']['s3_bucket_name']
doc_root = node['app']['deploy']['doc_root']
environment = node['app']['deploy']['environment']
file_name = node['app']['deploy']['file_name']

dir = "#{doc_root}"
[].tap{|x| Pathname(dir).each_filename{|d| x << (x.empty? ? [d] : x.last + [d])}}.each do |dir|
  directory File.join(dir) do
    owner 'apache'
    group 'apache'
    mode '0644'
  end
end

s3_file "/tmp/#{file_name}" do
    remote_path "/#{environment}/#{file_name}"
    bucket "#{s3_bucket_name}"
    owner "apache"
    group "apache"
    mode "0644"
    action :create
end