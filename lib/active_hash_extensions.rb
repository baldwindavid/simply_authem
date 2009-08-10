# Adds simple has_many to active_hash 
# http://github.com/zilkey/active_hash

module ActiveHash
  class Base
    class << self
      
      def has_many(association_id, options = {})
      
        define_method(association_id) do       
          options = {
            :class_name => association_id.to_s.classify,
            :foreign_key => self.class.to_s.foreign_key
          }.merge(options)
          
          # all needs to be called prior to dynamic finders being available
          options[:class_name].constantize.all
          options[:class_name].constantize.send("find_all_by_#{options[:foreign_key]}", id)
        end
      
      end
    
      def belongs_to(association_id, options = {})
      
        define_method(association_id) do       
          options = {
            :class_name => association_id.to_s.classify,
            :foreign_key => association_id.to_s.foreign_key
          }.merge(options)
          
          options[:class_name].constantize.find(send(options[:foreign_key]))
        end
      
      end
      
    end
  end 
end