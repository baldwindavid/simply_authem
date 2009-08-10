class SimplyAuthemUser < ActiveHash::Base
  
  self.data = SimplyAuthem.config["users"]
  
  def self.authenticate(authentication_field_value, password)
    # Hack - ActiveYaml Dynamic finders not working unless regular method call has come first - really strange
    all
    user = send("find_by_#{SimplyAuthem.config['authentication_fields'][0]}", authentication_field_value)
    user ||= send("find_by_#{SimplyAuthem.config['authentication_fields'][1]}", authentication_field_value) if SimplyAuthem.config['authentication_fields'].size > 1
    user && password == user.password ? user : nil
  end
  
end