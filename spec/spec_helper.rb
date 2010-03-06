require 'rubygems'
require 'activesupport'
require 'active_support'

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

def root_url
  "http://host:1234/context"
end

def documents_url
  "#{root_url}/documents"
end

def documents_json
 '[{"highlight":"","attributes":{"name":"Marilyn","lastname":"Monroe","_type":"Advertise"},"id":"1312"}, {"highlight":"","attributes":{"name":"Marilyn","lastname":"Manson","_type":"Advertise"},"id":"1313"}]'
end

def document_json
  '{"highlight":"","attributes":{"name":"Marilyn","lastname":"Monroe","_type":"Advertise"},"id":"1312"}'
end

def search_json
 '[{"highlight":"marilyn","attributes":{"name":"Marilyn","lastname":"Monroe","_type":"Advertise"},"id":"1312"},{"highlight":"adriana","attributes":{"name":"Adriana","lastname":"Lima","_type":"Advertise"},"id":"1212"}]'
end
