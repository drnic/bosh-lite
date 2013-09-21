include_recipe 'bosh-lite::rbenv'

%w(
  vim
  ack-grep
  maven2
  default-jdk
  libsqlite3-dev
).each do |package_name|
  package package_name
end

rbenv_gem 'bosh_cli' do
  version '~>1.5.0.pre.847'
  source 'https://s3.amazonaws.com/bosh-jenkins-gems/'
end

rbenv_gem 'cf'
