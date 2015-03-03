require 'bundler/capistrano'
require 'capistrano/ext/multistage'
#require "rvm/capistrano"

set :application, "divyanshu_blog_app"
set :repository,  "https://github.com/vermadivyanshu/divyanshu_blog.git"
set :scm, :git
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :server, :passenger
set :use_sudo, false
set :user, :redmine
set :stages, %w(production staging)
set :keep_releases, 5
#set :rvm_type, :user

default_run_options[:pty] = true

namespace :deploy do
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
 
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
   
  before "deploy:assets:precompile" do
    run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -s #{shared_path}/config/auth_base_pass.yml #{release_path}/config/auth_base_pass.yml"
    run "ln -s #{shared_path}/config/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end
    
  desc "Take db_backup"
  task :db_backup, :roles => :db do
    begin
      run "cd  #{latest_release}; bundle exec rake RAILS_ENV=#{rails_env} db2fog_backup:db_backup"
    rescue
      p 'file does not exist'
    end
  end  
  
    
  desc "Deploy with migrations"
  task :long do
    transaction do
      update_code
      web.disable
      symlink
      migrate
    end
    restart
    web.enable
    cleanup
  end

  desc "Run cleanup after long_deploy"
  task :after_deploy do
    cleanup
  end

  

end

require './config/boot'
#require 'airbrake/capistrano'
