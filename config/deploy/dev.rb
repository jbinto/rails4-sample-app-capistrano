set :stage, :dev
set :branch, "master"
server 'dev.416.bike', user: fetch(:deploy_user), roles: %w{web app db}, primary: true

# used in case we're deploying multiple versions of the same
# app side by side. Also provides quick sanity checks when looking
# at filepaths

# XXX: the way the server is set up, it expects 'foo_production'
# even if it is a staging/dev server
set :full_app_name, "#{fetch(:application)}_production"

set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"

# dont try and infer something as important as environment from
# stage name.
set :rails_env, :production

# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, false
