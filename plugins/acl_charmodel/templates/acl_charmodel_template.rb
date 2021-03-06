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
        model.swrifts_stats.to_a.sort_by { |a| a.name }
          .each_with_index
            .map do |a, i| 
              linebreak = i % 2 == 0 ? "\n" : ""
              title = left("#{ a.name }:", 10)
              step = left(a.rating, 15)
              "%xh#{title}%xn #{step}"
			end
	   end
    end
  end
end