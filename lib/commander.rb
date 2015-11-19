# (c) 2015 Univision Communications Inc.  All rights reserved.

require 'pty'

module Commander

  class Commands

    def initialize(list, options)
      @list = list
      @options = options
      @full_list = make_command_list
    end

    def run
      @full_list.each{ |c|
        c.run
      }
    end

  private

    def make_command_list
      output = []
      @list.each{ |i|
        output << Command.new(i, @options)
      }
      output
    end

  end

  module SafePty
    def self.spawn command, options, &block

      PTY.spawn(command) do |r,w,p|
        begin
          r.each { |line|
            print "[#{options.host}][command output]   #{ line }" unless options.quiet
          }
          if block_given?
            yield r,w,p
          else
            return r,w,p
          end
        rescue Errno::EIO
        rescue PTY::ChildExited
        ensure
          Process.wait p
          raise "command exited with an error. EXIT #{$?.exitstatus}" unless $?.exitstatus == 0
        end
      end

      $?.exitstatus
    end
  end

  class Command
    attr_accessor :command

    def initialize(command, options)
      # binding.pry
      @command = command.gsub("'", Regexp.escape("\\'"))
      @options = options
      @options.quiet ||= false
      @options.local = @options.local?
    end

    #
    def remote_command
      output = "ssh -t #{@options.user}@#{@options.host} -i #{@options.ssh_key} \"bash -c -l '#{@command}'\""
      puts "[#{@options.host}][command running] #{output}" unless @options.quiet
      output
    end

    def local_command
      output = "bash -c -l '#{@command}'"
      puts "[#{@options.host}][command running] #{output}" unless @options.quiet
      output
    end

    def run
      if @options.local
        cmd = local_command
      else
        cmd = remote_command
      end
      _stdin, _stdout, _pid = SafePty.spawn(cmd, @options)
    end
  end
end
