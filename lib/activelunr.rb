module ActiveLunr
  
  URL = YAML::load_file("#{RAILS_ROOT}/config/lunr.yml")[RAILS_ENV]
  
  def after_create
    RestClient.post(URL, :document => @attributes.merge('_type' => self.class.to_s))
  end
end