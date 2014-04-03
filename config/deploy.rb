# Adapted from:
#
# http://www.talkingquickly.co.uk/2014/01/deploying-rails-apps-to-a-vps-with-capistrano-v3/
# https://github.com/TalkingQuickly/capistrano-3-rails-template

lock '3.1.0'

set :application, 'sampleapp'
set :deploy_user, 'deploy'

set :scm, :git
set :repo_url, 'git@github.com:jbinto/sample_app_4_0_upgrade.git'


# See https://github.com/capistrano/rbenv#usage for details
# on rbenv boilerplate.

# I believe this should be 'user', since it's installed as ~deploy
set :rbenv_type, :user
set :rbenv_ruby, '2.1.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :keep_releases, 5

# These are symlinks, so redeploys don't "overwrite" important files.
# Not sure why app/database not updated. I get logs, sockets, pids, etc.

set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Run Rspec tests before deploying. Nifty.
# Depends on lib/capistrano/tasks/run_tests.cap
set :tests, ["spec"]


## Config files to be copied by deploy:setup_config
## Depends on lib/capistrano/tasks/setup_config.cap
set(:config_files, %w(
  nginx.conf
  application.yml
  database.example.yml
))

set(:executable_config_files, [])

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc.

# BUG: fetch(:full_app_name) is not available here.
# It's defined in production.rb, which isn't loaded yet.
# Could have an env clash here.
set(:symlinks, [
  {
    source: "nginx.conf",
    link: "/etc/nginx/sites-enabled/#{fetch(:application)}"
  }
])


set :keep_releases, 5

namespace :deploy do
  before :deploy, "deploy:check_revision"
  before :deploy, "deploy:run_tests"
  after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  after :finishing, 'deploy:cleanup'

  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

end
