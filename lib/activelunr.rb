module ActiveLunr
  
  DOCUMENTS_URL = YAML::load_file("#{RAILS_ROOT}/config/lunr.yml")[RAILS_ENV] + '/documents'
  
  def after_create
    RestClient.post(DOCUMENTS_URL, :document => @attributes.merge('_type' => self.class.to_s))
  end
  
  def after_update
    RestClient.put("#{DOCUMENTS_URL}/#{id}", :document => @attributes.delete_if {|key, value| value.nil? or key.eql?('id')})
  end
end