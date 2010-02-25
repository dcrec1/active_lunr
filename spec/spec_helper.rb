require 'rubygems'
require 'activerecord'

require 'ruby-debug'

RAILS_ROOT = File.expand_path(File.dirname(__FILE__) + "/rails")
RAILS_ENV = 'test'

require File.expand_path(File.dirname(__FILE__) + "/../init")

def stub_http(verb)
  RestClient.stub!(verb)
end

def expect_http(verb)
  RestClient.should_receive(verb)
end

def documents_url
  "http://host:1234/context/documents"
end

def documents_json
 '[{"highlight":"marilyn","attributes":{"name":"Marilyn","lastname":"Monroe","_type":"Advertise"},"id":"1312"},{"highlight":"adriana","attributes":{"name":"Adriana","lastname":"Lima","_type":"Advertise"},"id":"1212"}]'
end
