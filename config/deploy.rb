# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'cap_app'
set :repo_url, 'git@github.com:t-shida/cap_app.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, 'config/database.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'
set :linked_dirs, %w{bin log tmp}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 3

set :ssh_options, {
  keys: [File.expand_path('~/.ssh/id_rsa')]
}

set :rbenv_type, :user
set :rbenv_ruby, '2.1.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

set :migration_role, :app
set :whenever_roles, :batch
set :whenever_identifier, ->{"#{fetch(:application)}_#{fetch(:stage)}"}
# set :shoryuken_role, :job

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  desc 'Restart Application'
  task :restart do
    on roles(:app) do
      # passenger
      execute :touch, release_path.join('tmp/restart.txt')
    end
    on roles(:job) do
      # shoryuken
      execute %(ps ax | grep shoryuken | grep -v grep | awk '{print "kill -USR1",$1}' | sh)
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :shoryuken, "-d -R -C config/shoryuken.yml -L ./log/#{fetch(:rails_env)}.log"
        end
      end
    end
  end
end
