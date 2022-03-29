set :application, "adserver.topfunky.com"
set :deploy_to, "/var/www/sites/#{application}"
set :repository, "ssh://hg@hg.topfunky.com/adserver"
set :branch, "master"
set :user, "deploy"

set :scm, :mercurial
set :ssh_options, { :forward_agent => true }
set :deploy_via, :remote_cache
set :copy_strategy, :checkout
set :keep_releases, 3
set :use_sudo, false
set :copy_compression, :bz2

role :app, "#{application}"
role :web, "#{application}"
role :db,  "#{application}", :primary => true

namespace :deploy do
  task :restart, :roles => :app do
    # with Passenger there's no need to restart anything
    # just touch the tmp/restart.txt file
    run "mkdir -p #{release_path}/tmp && touch #{release_path}/tmp/restart.txt"
  end
end
