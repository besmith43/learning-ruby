module Dialog
  module Util

    # A more flexible variant of the popen3 call
    #
    # Other than Open3.popen3, this method allows the parent process
    # to share individual file descriptors with the child process. By
    # default, all three file descriptors (stdin, stdout, stderr) of
    # the child process are connected to pipes, which the parent process
    # can use to write to/read from the child process. However, if this
    # is not the desired behaviour, the parent process can pass IO objects
    # for each stream that should be shared by the child process. This
    # method does not fork twice (putting the burden to wait/waitpid on
    # the parent process) and thus gives the parent process a pid. Note,
    # that this introduces a small chance of receiving yet unitinialized
    # file descriptors.
    #
    # Note, that popen3 behaves like exec concerning its arguments. If popen3
    # is given a single argument, that argument is taken as a line that is subject
    # to shell expansion before being executed. If multiple arguments are given,
    # the second and subsequent arguments are passed as parameters to the command
    # without shell expansion taking place.
    #
    # Examples:
    #   
    #   # Share stdin/stdout, but connect stderr to a pipe
    #   # The * is subject to shell file globbing
    #   pid, stdin, stdout, stderr = popen3("echo *", :stdin => STDIN, :stdout => STDOUT)
    #
    #   # Share stdin/stdout, but connect stderr to a pipe
    #   # Echoes an asterisk
    #   pid, stdin, stdout, stderr = popen3("echo", "*", :stdin => STDIN, :stdout => STDOUT)
    #
    def self.popen3(*command)
      fds = command.pop if command.last.kind_of?(Hash)
      command.flatten!
      stdin = fds[:stdin] if fds
      stdout = fds[:stdout] if fds
      stderr = fds[:stderr] if fds

      # pipe[0] for read, pipe[1] for write
      pi = IO::pipe unless stdin
      po = IO::pipe unless stdout
      pe = IO::pipe unless stderr

      pid = fork

      if pid.nil?
	# child
        pi[1].close if pi
        STDIN.reopen(pi[0]) if pi
        pi[0].close if pi

        po[0].close if po
        STDOUT.reopen(po[1]) if po
        pi[1].close if po

        pe[0].close if pe
        STDERR.reopen(pe[1]) if pe
        pe[1].close if pe

	exec *command
      end

      # parent
      pi[0].close if pi
      po[1].close if po
      pe[1].close if pe
      pi[1].sync = true if pi
      return [pid, stdin || pi[1], stdout || po[0], stderr || pe[0]]
    end

  end
end
