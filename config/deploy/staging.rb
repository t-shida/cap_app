set :deploy_to, '/home/homepage/www/capistranos/staging/cap_app'
set :stage, 'staging'
set :rails_env, fetch(:stage)

role :app, 'homepage@localhost'
