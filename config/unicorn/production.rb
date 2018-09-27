# paths
app_path = "/home/deployer/qna"
working_directory "#{app_path}/current"  #current version of our app
pid     "#{app_path}/current/tmp/pids/unicorn.pid" #holds unicorn's process id

# listen
listen "#{app_path}/current/tmp/sockets/unicorn.qna.sock", backlog: 64 #what socket does unicorn listen to?, backlog - number of workers (upto)

# logging
stderr_path "log/unicorn.stderr.log"
stdout_path "log/unicorn.stdout.log"

# workers
worker_processes 2 #how many master-process, each master has some workers, amount of

# use correct Gemfile on restarts
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end

# preload
preload_app true # importand for zero-downtime deploy
# before creating a forker master load application code
# so that new worker doesn't read code from the disk but just copies it from the memory

before_fork do |server, worker|
  # the following is highly recommended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  # when a new worker is created db connection is lost and then worker a establishes a db connection.

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid  # old and new master process
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end