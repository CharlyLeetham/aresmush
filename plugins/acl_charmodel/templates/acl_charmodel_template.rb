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
		model.swade_stats
      end
	end
  end
end

