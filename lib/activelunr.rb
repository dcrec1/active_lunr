module ActiveLunr
  ROOT_URL = YAML::load_file("#{RAILS_ROOT}/config/lunr.yml")[RAILS_ENV]
  DOCUMENTS_URL =  ROOT_URL + '/documents'

  attr_accessor :highlight

  def self.included(base)
    base.extend ClassMethods
  end

  def initialize(params)
    @attributes = params.stringify_keys
  end

  def save!
    @id.nil? ? create : update
  end

  def update_attributes!(params)
    @attributes.merge! params.stringify_keys
    save!
  end

  def method_missing(method_name, *args)
    @attributes[method_name.to_s]
  end

  private

  def create
    @id = RestClient.post("#{DOCUMENTS_URL}.json", :document => @attributes.merge('_type' => self.class.to_s))['id']
  end

  def update
    RestClient.put("#{DOCUMENTS_URL}/#{id}.json", :document => @attributes.delete_if { |key, value| value.nil? or key.eql?('id') })
  end

  module ClassMethods
    def create!(params)
      returning new(params) do |subject|
        subject.save!
      end
    end

    def search(params)
      query = URI.encode("_type:#{self} AND #{params}")
      Crack::JSON.parse(RestClient.get("#{ROOT_URL}/search/#{query}.json")).map do |document|
        attributes = document['attributes']
        attributes.delete '_type'
        returning new attributes do |doc|
          doc.highlight = document['highlight']
        end
      end
    end
  end
end
