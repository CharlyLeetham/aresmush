module AresMUSH
  module Swrifts
    class AttributeListRequestHandler
      def handle(request)
        {
		  edges: build_list(Swrifts.swrifts_edges),
		  hinderances: build_list(Swrifts.swrifts_hinderances)
        } 
      end
      
      def build_list(hash)
        nh = hash.sort_by { |a| a['name'] }
		return nh
      end

      def return_hw()
		return "Hellow World"
      end
    end
  end
end


