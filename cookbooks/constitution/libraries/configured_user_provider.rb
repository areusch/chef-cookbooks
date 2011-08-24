#
# Author:: Andrew Reusch (<areusch@gmail.com>)
# Copyright:: Copyright (c) 2011 Andrew Reusch
# License:: Apache License, Version 2.0
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
#

require 'chef/mixin/shell_out'

module ConstitutionConfiguredUserProvider
  include ::Chef::Mixin::ShellOut

  def managed_root
    ::File.join(@current_resource.home, '.managed')
  end

  def action_create(*args)
    @provider.action_create(*args)
  end

  def action_sync(*args)
    package "git" do
      action :install
    end

    action_list = @new_resource.action
    unless action_list.rindex(:remove) && action_list.rindex(:remove) > action_list.rindex(:create)
      if !::File.exists?(managed_root)
        shell_out!("git clone #{@new_resource.configuration_git_url} #{managed_root}")
      else
        shell_out!('git pull --rebase origin', {"cwd" => managed_root})
      end
      shell_out!('./sync', {'cwd' => managed_root})
      @new_resource.updated_by_last_action(true)
    end
  end
end
