#
# Cookbook Name:: cassandra
# Recipe:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe "java::sun"
include_recipe "hadoop_common::pre_run"
include_recipe "hadoop_common::mount_disks"
include_recipe "hadoop_cluster::update_attributes"

# Setup the repo file for installing Cassandra
template '/etc/yum.repos.d/datastax.repo' do
  source 'datastax.repo.erb'
  action :create
end

%w{dsc21 cassandra21-tools}.each do |pkg|
  package pkg do
    action :install
  end
end

execute 'Setup Cassandra Service' do
  command 'chkconfig cassandra on'
end

all_seeds_ip = cassandra_seeds_ip
all_nodes_ip = cassandra_nodes_ip

template '/etc/cassandra/conf/cassandra.yaml' do
  source 'cassandra.yaml.erb'
  action :create
  variables(
    seeds_list: all_seeds_ip,
    cluster_value: node[:cluster_name]
  )
  action :create
end

template '/etc/cassandra/default.conf/cassandra-env.sh' do
  source 'cassandra-env.sh.erb'
  action :create
end

clear_bootstrap_action
