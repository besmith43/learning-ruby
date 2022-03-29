# Daemons in Ruby

we will use gem 'process-daemon' (https://github.com/ioquatix/process-daemon)


# Process::Daemon

* install gem

```
gem install process-daemon
```


# Simple daemon

```
# /../myapp/my_daemon.rb

require 'process/daemon'
require 'process/daemon/process_file'
require 'process/daemon/privileges'


class MyDaemon < Process::Daemon
    def startup
        # Called when the daemon is initialized in it's own process. Should return quickly.
    end

    def run
        # Do the actual work. Does not need to be implemented, e.g. if using threads or other background processing mechanisms which were kicked off in #startup.
    end

    def shutdown
        # Stop everything that was setup in startup. Called as part of main daemon thread/process, not in trap context (e.g. SIGINT).
        # Asynchronous code can call self.request_shutdown from a trap context to interrupt the main process, provided you aren't doing work in #run.
    end
end

# Make this file executable and have a command line interface:
MyDaemon.daemonize

```

* run

```
ruby my_daemon.rb start
```

* stop

```
ruby my_daemon.rb stop
```



## Settings

* by default it stores files here:
```
working_directory = "."
log_directory = #{working_directory}/log
log_file_path = #{log_directory}/#{name}.log
runtime_directory = #{working_directory}/run
process_file_path = #{runtime_directory}/#{name}.pid
```


### change pid file

```
# /../myapp/my_daemon.rb

class MyDaemon < Process::Daemon
    def name
       "mydaemon"
    end
    
    working_directory = "."
      
  def process_file_path
    "#{working_directory}/tmp/pids/#{name}.pid"
  end
  
  ...
  
end  
```

* run
```
ruby my_daemon.rb
```

* check that file /myapp/tmp/pids/mydaemon.rb contains ID of the running process
* check process ID:
```
ps -efL | grep mydaemon
```



## Options from command line

* pass options from command line

```
# /../myapp/my_daemon.rb

require 'optparse'

require 'process/daemon'
require 'process/daemon/process_file'
require 'process/daemon/privileges'


# set options from command line


# options
options = {}
opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage: example.rb [options]"

  opt.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opt.on("-e","--environment ENVIRONMENT","which environment you want server run") do |v|
    options[:environment] = v
  end


  # pid_file
  opt.on("-p","--pid PIDFILE","pid file") do |v|
    options[:pid_file] = v
  end
end

opt_parser.parse!

# use options

env = options[:environment] || 'development'
pid_file = options[:pid_file]



class MyDaemon < Process::Daemon
...
end


```




