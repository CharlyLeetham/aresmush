module AresMUSH
  class Character
    field :height, :type => String
    field :build, :type => String
    field :fullname, :type => String
    field :gender, :type => String
    field :hair, :type => String
    field :eyes, :type => String
    field :reputation, :type => String
    field :birthdate, :type => Date
    
    def age
      Demographics.calculate_age(self.birthdate)
    end
    
    # His/Her/Their
    def possessive_pronoun
      t("demographics.#{self.gender}_possessive")
    end

    # He/She/They
    def subjective_pronoun
      t("demographics.#{self.gender}_subjective")
    end

    # Him/Her/Them
    def objective_pronoun
      t("demographics.#{self.gender}_objective")
    end
    
  end
end