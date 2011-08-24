require 'chef/provider/user'

include ConstitutionConfiguredUserProvider

attr_accessor :provider

def load_current_resource(*args)
  @provider = Chef::Provider::User::Useradd.new(@new_resource, @run_context)
  @current_resource = ::Chef::Resource::ConstitutionConfiguredUser.new(provider.load_current_resource(*args))

  if provider.user_exists &&::File.exists?(managed_root)
    git_output = shell_out!('git remote', {'cwd' => managed_root}).stdout
    re_match = /^github[\w]*\([^\w]*\)[\w]*(fetch)$/.match(git_output)
    if !re_match.nil?
      @current_resource.configuration_git_url re_match[1]
    end
  end
end

action :create do
  notifies :sync, self, :immediately
end

# action :sync do
#   ConfiguredUserProvider.action_sync
# end
