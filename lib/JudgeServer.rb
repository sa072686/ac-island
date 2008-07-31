#!/usr/bin/env ruby
# ACIsland Judge Server
require File.dirname(__FILE__) + '/../config/boot'               
require File.dirname(__FILE__) + "/../config/environment.rb"
require 'drb'      
require 'drb/acl'
         
mode = ENV['RAILS_ENV'] || RAILS_ENV

# DEBUG
JUDGEHELPER_LOCATION = "/Users/Zero/Dropbox/Sites/ACIsland/lib/JudgeHelper"
BINARY_FILE_DIRECTORY = "/tmp/"

class JudgeServer
    def run(problem, input)
        print "JudgeServer: run #{problem}"
        result = nil
        IO.popen("#{JUDGEHELPER_LOCATION} #{BINARY_FILE_DIRECTORY}/#{problem}", "r+") do |io|
            io.write input
            io.close_write
            result = io.gets
        end
        return result
    end
end

print "Starting JudgeServer..."
STDOUT.flush
acl = ACL.new(%w(deny all
                 allow 127.0.0.1))
DRb.install_acl(acl)
DRb.start_service("druby://:10000", JudgeServer.new)
print "[OK]\nAwaiting connection..."
STDOUT.flush
DRb.thread.join

