require 'rubygems'
require 'active_support'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/object/misc'
require 'rails'

Rails.class_eval do
  def self.root
    File.expand_path(File.dirname(__FILE__) + "/rails")
  end

  def self.env
    'test'
  end
end

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
  mock(Object, :to_s => '[{"highlight":"","attributes":{"name":"Marilyn","lastname":"Monroe","_type":"Advertise"},"id":"1312"}, {"highlight":"","attributes":{"name":"Marilyn","lastname":"Manson","_type":"Advertise"},"id":"1313"}]')
end

def document_json
  mock(Object, :to_s => '{"highlight":"","attributes":{"name":"Marilyn","lastname":"Monroe","_type":"Advertise"},"id":"1312"}')
end

def search_json
  mock(Object, :to_s => '[{"highlight":"marilyn","attributes":{"name":"Marilyn","lastname":"Monroe","_type":"Advertise"},"id":"1312"},{"highlight":"adriana","attributes":{"name":"Adriana","lastname":"Lima","_type":"Advertise"},"id":"1212"}]')
end
