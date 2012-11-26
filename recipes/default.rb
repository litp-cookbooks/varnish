#
# Cookbook Name:: varnish
# Recipe:: default
#
# Copyright 2012, Living in the Past
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package node["varnish"]["packages"]

backends = node["varnish"]["backends"]

recv = fetch = deliver = {}
recv = data_bag_item("varnish", "recv") rescue nil
fetch = data_bag_item("varnish", "fetch") rescue nil
deliver = data_bag_item("varnish", "deliver") rescue nil

template node["varnish"]["vcl"] do
  source "default.vcl.erb"
  cookbook "varnish"
  owner "root"
  group "root"
  mode 0644
  variables(
      "backends" => backends,
      "recv" => recv,
      "fetch" => fetch,
      "deliver" => deliver
  )
  notifies :reload, "service[varnish]"
end

template node["varnish"]["secret"] do
  source "secret.erb"
  cookbook "varnish"
  owner "root"
  group "root"
  mode 0600
  variables "secret" => node["varnish"]["management_interface"]["secret"]
end

execute "verify varnish configuration" do
  command "varnishd -C -f #{node["varnish"]["vcl"]} | grep -v 'exit 1'"
end

service "varnish" do
  supports :enable => true, :reload => true
  action [:enable, :start]
end
