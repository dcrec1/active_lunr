module ActiveLunr

  attr_accessor :highlight

  def self.included(base)
    base.extend ClassMethods
  end

  DOCUMENTS_URL = YAML::load_file("#{RAILS_ROOT}/config/lunr.yml")[RAILS_ENV] + '/documents'

  def after_create
    RestClient.post("#{DOCUMENTS_URL}.json", :document => @attributes.merge('_type' => self.class.to_s))
  end

  def after_update
    RestClient.put("#{DOCUMENTS_URL}/#{id}.json", :document => @attributes.delete_if {|key, value| value.nil? or key.eql?('id')})
  end

  module ClassMethods
    def search(params)
      query = URI.encode("_type:#{self} AND #{params}")
      Crack::JSON.parse(RestClient.get("#{DOCUMENTS_URL}/search?q=#{query}")).map do |document|
        attributes = document['attributes']
        attributes.delete '_type'
        returning new attributes do |doc|
          doc.highlight = document['highlight']
        end
      end
    end
  end
end
