# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'Bargeh'
set :repo_url, 'git@github.com:tectual/bargeh.git'
set :branch, 'master'
set :deploy_via, :remote_cache

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/bargehapp.com'
set :keep_releases, 5

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/defaults.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
  
  desc 'God will start jobs'
  after :restart, :god_rules do
    on roles(:app) do
      within File.join( deploy_to, 'current') do
        #execute :bundle, "exec god stop resque"
        #execute :bundle, "exec god load #{File.join deploy_to, 'current', 'config', 'resque.god'}"
        #execute :bundle, "exec god start resque"
      end
    end
  end

end
