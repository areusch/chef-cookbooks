#
# Author:: Andrew Reusch (<areusch@gmail.com>)
# Cookbook Name:: boxee
# Attributes:: default
#
# Copyright 2011 Andrew Reusch
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

case kernel[:machine]
when "x86_64"
  node[:boxee_dpkg_url] = "http://www.boxee.tv/download/ubuntu64?early=0"
    node[:boxee_dpkg_checksum] = "06f3482df763d0c56c4e9a6cc26724e657efd1e078661c75b08bd3f7dade3992"
when "x86"
  node[:boxee_dpkg_url] = "http://www.boxee.tv/download/ubuntu?early=0"
  node[:boxee_dpkg_checksum] = "5370c6a11eea1955174f5ce6622ccdff440764574c1871f11c5ea96ea29e6cb3"
else
  raise "Machine architecture #{node[:kernel][:machine]} not supported!"
end
