require 'rubygems'
require 'activerecord'

require 'ruby-debug'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3", "database" => File.join(File.dirname(__FILE__), 'test.sqlite3')
)

load(File.dirname(__FILE__) + '/schema.rb')

RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + "/rails")
RAILS_ENV = 'test'

require File.expand_path(File.dirname(__FILE__) + "/../init")