module ActiveLunr
  ROOT_URL = YAML::load_file("#{Rails.root}/config/lunr.yml")[Rails.env]
  DOCUMENTS_URL =  ROOT_URL + '/documents'

  attr_accessor :highlight, :id

  def self.included(base)
    base.extend ClassMethods
  end

  def initialize(params = {})
    @attributes = params.stringify_keys
  end
  
  def save
    create
    true
  end

  def save!
    @id.nil? ? create : update
  end
  
  def update_attributes(params)
    update_attributes! params
    true
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
    @id = Crack::JSON.parse(RestClient.post("#{DOCUMENTS_URL}.json", :document => @attributes.merge('_type' => self.class.to_s)).to_s)['id']
  end

  def update
    RestClient.put("#{DOCUMENTS_URL}/#{id}.json", :document => @attributes.delete_if { |key, value| value.nil? or key.eql?('id') })
  end

  module ClassMethods
    def create!(params = {})
      returning new(params) do |subject|
        subject.save!
      end
    end

    def search(params)
      query = URI.encode("_type:#{self} AND #{params}")
      Crack::JSON.parse(RestClient.get("#{ROOT_URL}/search/#{query}.json").to_s).map do |document|
        attributes = document['attributes']
        attributes.delete '_type'
        returning new attributes do |doc|
          doc.highlight = document['highlight']
        end
      end
    end

    def paginate(params)
      Crack::JSON.parse(RestClient.get("#{DOCUMENTS_URL}.json?page=#{params[:page]}").to_s).map do |document|
        attributes = document['attributes']
        attributes.delete '_type'
        returning new attributes do |doc|
          doc.id = document['id']
        end
      end
    end

    def quoted_table_name; end
  end
end
