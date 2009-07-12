set :application, 	    "cookbook"
set :repository,  	    "git://github.com/rspinder/cookbook.git"
set :deploy_to,   	    "/var/www/vhosts/majrekar.co.uk/subdomains/cookbook"
set :scm,	  	    "git"
set :user, 	  	    "dmajrekar"
set :deploy_via,  	    "remote_cache"
set :current_dir, 	    "httpdocs"
set :git_enable_submodules, 1
set :branch,		    "master"
set :use_sudo,		    false

# If you have previously been relying upon the code to start, stop 
# and restart your mongrel application, or if you rely on the database
# migration code, please uncomment the lines you require below

# If you are deploying a rails app you probably need these:

# load 'ext/rails-database-migrations.rb'
# load 'ext/rails-shared-directories.rb'

# There are also new utility libaries shipped with the core these 
# include the following, please see individual files for more
# documentation, or run `cap -vT` with the following lines commented
# out to see what they make available.

# load 'ext/spinner.rb'              # Designed for use with script/spin
# load 'ext/passenger-mod-rails.rb'  # Restart task for use with mod_rails
# load 'ext/web-disable-enable.rb'   # Gives you web:disable and web:enable

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
# see a full list by running "gem contents capistrano | grep 'scm/'"

role :app, "cookbook.majrekar.co.uk"
role :web, "cookbook.majrekar.co.uk"
role :db,  "cookbook.majrekar.co.uk", :primary => true

before 'deploy:start' do
  deploy.migrate
end

after 'deploy:update_code',  'deploy:symlink_shared_files'

namespace :deploy do
desc 'Symlinks files which are not deployed to static versions'

  task :symlink_shared_files, :roles => :web do

    # list of files / dirs to be symlinked.
    # In same order as for 'ln -s ...' where key of hash is existing file (src) and value is target.
    # Without a leading '/' src is assumed to reside under 'shared' deployment dir, and target is assumed
    # to be under 'current' within app directory.
    #
    #               shared                          current
    links = {  
               	'config/database.yml'           => 'config/database.yml',
		'db/production.sqlite3' 	=> 'db/production.sqlite3'
             }

    links.each do |src, tgt|
      src = "#{shared_path}/" + src unless src =~ /^\//
      tgt = "#{current_release}/" + tgt unless tgt =~ /^\//
      run "ln -s #{src} #{tgt}"
    end
  end
end


#############################################################

#	Passenger

#############################################################

namespace :passenger do

desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after :deploy, "passenger:restart"
