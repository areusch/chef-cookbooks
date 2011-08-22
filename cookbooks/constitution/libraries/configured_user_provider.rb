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
require 'chef/provider/user/useradd'

class Chef
  class Provider
    class ConstitutionConfiguredUser < Chef::Provider::User::Useradd
#      include ::Chef::Mixin::ShellOut
      def initialize(new_resource, run_context)
        super
        puts "In Constructor: #{super.class}"
      end

      # def load_current_resource
      #   @current_resource = ::Chef::Resource::ConstitutionConfiguredUser.new(super.load_current_resource)

      #   if @current_resource.user_exists &&
      #       ::File.exists(managed_root)
      #     git_output = shell_out!('git remote', {'cwd' => managed_root}).stdout
      #     re_match = /^github[\w]*\([^\w]*\)[\w]*(fetch)$/.match(git_output)
      #     if !re_match.nil?
      #       @current_resource.configuration_git_url re_match[1]
      #     end
      #   end
      # end

      def managed_root
        ::File.join(@current_resource.home, '.managed')
      end

      def action_create(*args)
        puts "This class: #{self.class}"
        puts "Superclass: #{super.class}"
        instance_variables.each {|x| puts " * #{x}" }
        super.action_create(*args)

        puts "Create..."

        notifies :sync, self, :immediately
      end

      def action_sync(*args)
        unless !@new_resource.exists
          if !::File.exists(managed_root)
            shell_out!('git clone #{@new_resource.configuration_git_url} #{managed_root}')
          else
            shell_out!('git pull --rebase origin', {"cwd" => managed_root})
          end
          shell_out!('./sync', {'cwd' => managed_root})
          @new_resource.updated_by_last_action(true)
        end
      end
    end
  end
end
