class SimplyAuthemUser < ActiveYaml::Base
  
  set_root_path "#{RAILS_ROOT}/config"
  set_filename "simply_authem"
  
  def self.load_file
    YAML.load_file(full_path)["users"]
  end
  
  def self.authentication_fields
    YAML.load_file(full_path)["authentication_fields"]
  end
  
  def self.authenticate(authentication_field_value, password)
    # Hack - ActiveYaml Dynamic finders not working unless regular method call has come first - really strange
    first
    user = send("find_by_#{authentication_fields[0]}", authentication_field_value)
    user ||= send("find_by_#{authentication_fields[1]}", authentication_field_value) if authentication_fields.size > 1
    user && password == user.password ? user : nil
  end
  
end