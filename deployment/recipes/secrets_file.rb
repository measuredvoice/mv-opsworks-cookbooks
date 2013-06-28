include_recipe "deploy"

node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  template "#{deploy[:deploy_to]}/shared/config/too_many_secrets.rb" do
    source "too_many_secrets.rb"
    cookbook 'deployment'
    mode "0660"
    group deploy[:group]
    owner deploy[:user]
    
    variables(:database => deploy[:database], :environment => deploy[:rails_env])

    # notifies :run, resources(:execute => "restart Rails app #{application}")

    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/shared/config/")
    end
  end
end