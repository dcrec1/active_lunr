require 'rest_client'
require 'crack'
require 'uri'

module ActiveLunr

  def self.included(base)
    base.extend ClassMethods
  end

  DOCUMENTS_URL = YAML::load_file("#{RAILS_ROOT}/config/lunr.yml")[RAILS_ENV] + '/documents.json'

  def after_create
    RestClient.post(DOCUMENTS_URL, :document => @attributes.merge('_type' => self.class.to_s))
  end

  def after_update
    RestClient.put("#{DOCUMENTS_URL}/#{id}", :document => @attributes.delete_if {|key, value| value.nil? or key.eql?('id')})
  end

  module ClassMethods
    def search(params)
      query = URI.encode("_type:#{self} AND #{params}")
      Crack::JSON.parse(RestClient.get("#{DOCUMENTS_URL}/search?q=#{query}")).map do |document|
        attributes = document['attributes']
        attributes.delete '_type'
        new attributes
      end
    end
  end
end
