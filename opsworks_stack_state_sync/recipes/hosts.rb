require 'resolv'

template '/etc/hosts' do
  source "hosts.erb"
  mode "0644"
  variables(
    :localhost_name => node['hostname'],
    :nodes => search(:node, "name:*")
  )
end
