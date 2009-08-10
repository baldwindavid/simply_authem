class SimplyAuthem
  
  def self.config
    YAML.load_file("#{RAILS_ROOT}/config/simply_authem.yml")
  end
  
end