class SimplyAuthemGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file 'config/simply_authem.yml', 'config/simply_authem.yml'
    end
  end
end
