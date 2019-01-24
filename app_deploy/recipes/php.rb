#
# Cookbook Name:: app_deploy
# Recipe:: php
#

app = search("aws_opsworks_app").first

template '/tmp/get_s3.sh' do
  source "get_s3.sh.erb"
  mode   "0755"
  variables({
    :url     => "#{app['app_source']['url']}",
    :document_root     => "#{app['attributes']['document_root']}" 
  })
  owner 'apache'
  group 'apache'
  notifies :run, "bash[start_download]", :immediately
end

bash "start_download" do
 cwd "/tmp"
 code <<-EOH
   ./get_s3.sh
 EOH
 action :nothing
end