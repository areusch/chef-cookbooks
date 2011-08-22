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

require 'chef/resource'
require 'chef/resource/user'

class Chef
  class Resource
    class ConstitutionConfiguredUser < ::Chef::Resource::User
      def initialize(*args)
        if args.length == 1 && args[0].class == ::Chef::Resource::User
          super(args[0].name)
          args[0].instance_variables.each {|x| instance_variable_set(x, args[0].x) }
        else
          super(*args)
        end

        @resource_name = :constitution_configured_user
        @allowed_actions.push(:sync)
        configuration_git_url nil
      end

      def configuration_git_url(arg=nil)
        set_or_return(
                      :configuration_git_url,
                      arg,
                      :kind_of => [ String ]
                      )
      end
    end
  end
end
