module ActiveLunr
  
  URL = YAML::load_file("#{RAILS_ROOT}/config/lunr.yml")[RAILS_ENV]
  
  def after_create
    RestClient.post("#{URL}/documents", :document => @attributes.merge('_type' => self.class.to_s))
  end
  
  def after_update
    RestClient.put("#{URL}/documents/#{id}", :document => @attributes.delete_if {|k, v| v.nil? or k.eql?('id')})
  end
end