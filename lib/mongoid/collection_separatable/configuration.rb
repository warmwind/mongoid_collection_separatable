module Mongoid
	module CollectionSeparatable
		class Configuration
			attr_accessor :separate_key

			def	initialize separate_key
				@separate_key =  separate_key
			end
		end
	end
end
