default_run_options[:pty] = true
set :application, "codejenzi"
set :repository,  "git@github.com:hackersapien/codejenzi.git"
set :deploy_to, "/home/codejenzi/#{application}"
set :scm, :git
set :branch,"master"
set :git_enable_submodules, 1
set :user,                  "codejenzi"
set :deploy_via,            :remote_cache
set :ssh_options,           :forward_agent => true
#set :keep_releases,         3
set :use_sudo,              false


# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false

role :app, "ec2-174-129-168-6.compute-1.amazonaws.com"
role :web, "ec2-174-129-168-6.compute-1.amazonaws.com"
role :db,  "ec2-174-129-168-6.compute-1.amazonaws.com", :primary => true

#
# ==== Merb variables
#

set :merb_adapter,     "mongrel"
set :merb_environment, ENV["MERB_ENV"] || "production"
set :merb_port,        4000
set :merb_servers,     1

#
# --- Nginx variables
#


set :nginx_bin, 'user/local/sbin'
set :nginx_pid, '/usr/local/nginx/logs/nginx.pid'


after "deploy:update_code", "deploy:native_gems", "deploy:symlink_database"

namespace :nginx do
desc "Reload nginx config files without restarting"    
  task :reload, :roles => :web do
    sudo "kill -HUP `cat #{nginx_pid}`" 
  end

  desc "Start"    
  task :start, :roles => :web do
    sudo "#{nginx_bin}/nginx" 
  end

  desc "Kill nginx"    
  task :stop, :roles => :web do
    sudo "kill `cat #{nginx_pid}`" 
  end

  desc "Restart nginx"    
  task :restart, :roles => :web do
    nginx.stop
    nginx.start
  end

end

namespace :deploy do
  
  

  desc "Symlink database on each release."
 task :symlink_database do
  run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"  
 end
  
  # replace above task by the following (not namespaced) if you are using DM
  namespace :dm do
    task :migrate, :roles => :db, :only => { :primary => true } do
      run "cd #{latest_release}; rake MERB_ENV=#{merb_env} #{migrate_env} dm:db:migrate"
    end
  end
  
  
  
  desc "starts merb cluster"
  task :start do
    run "cd #{latest_release}; bin/merb -a #{merb_adapter} -p #{merb_port} -c #{merb_servers} -d -e #{merb_environment}"
    # Mutex of: -X off
  end

 desc "stops application server"
  task :stop do
    run "cd #{latest_release}; bin/merb -K all"
  end

  
  desc "recompile native gems"
  task :native_gems do
    run "cd #{latest_release};bin/thor merb:gem:redeploy"
  end
  
  desc "restarts application server(s)"
  task :restart do
    deploy.stop
    deploy.start
  end
  
  
end
