set :branch, "master"
set :rails_env, 'production'
set :deploy_to, "/var/www/divyanshu_blog_app"
set :ssh_options, { :forward_agent => true }
role :web, "10.100.66.198"       
role :app, "10.100.66.198"                          
role :db,  "10.100.66.198", :primary => true 

before "deploy:migrate", "deploy:db_backup"