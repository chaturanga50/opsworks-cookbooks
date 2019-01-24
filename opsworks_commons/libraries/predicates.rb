def infrastructure_class?
  node[:opsworks][:instance][:infrastructure_class] == ec2
end

def rhel6?
  %w(redhat centos amazon).include?(node["platform"])
end

def rhel7?
  %w(redhat centos).include?(node["platform"]) && Chef::VersionConstraint.new("~> 7.0").include?(node["platform_version"])
end
