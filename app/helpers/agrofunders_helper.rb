module AgrofundersHelper

	def translate_number(i)
		I18n.with_locale(:en){ (i+1).to_words}.capitalize
	end
end
