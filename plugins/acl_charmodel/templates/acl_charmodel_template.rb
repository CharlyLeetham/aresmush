module AresMUSH
  module ACL_CharModel
    class ACL_CharModelTemplate < ErbTemplateRenderer
             
      attr_accessor :char
                     
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/acl_charmodel_template.erb"		
	  end
	  
	  def niceview(model)
		model.to_yaml
      end

	  def swadestats(model)
		ss = model.swade_stats
		ss.to_yaml
      end
	end
  end
end

