#!/usr/bin/env rake
require "bundler/gem_tasks"

namespace :test do
  desc "Test Task"

   desc "Load stuff in IRB."
   task :console do
     exec "irb -r rubygems -r pp -r ./lib/ntee"
   end
end
