#
# Cookbook Name:: app_deploy
# Recipe:: php
#

time = Time.now.strftime("%F-%T").gsub(':','')
app = search("aws_opsworks_app").first

directory "#{app['attributes']['document_root']}" do
  owner 'apache'
  group 'apache'
  mode '0644'
  recursive true
  action :create
end

template '/tmp/get_s3.sh' do
  source "get_s3.sh.erb"
  mode   "0755"
  variables({
    :url     => "#{app['app_source']['url']}",
    :document_root     => "#{app['attributes']['document_root']}",
    :short_name => "#{app['shortname']}"
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