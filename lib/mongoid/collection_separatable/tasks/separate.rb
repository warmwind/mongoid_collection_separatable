module Mongoid
  module CollectionSeparatable
    module Tasks
      class Separate
        attr_accessor :origin_class, :condition_key, :condition_value

        def initialize origin_class, condition_key, condition_value
          @origin_class = origin_class.constantize
          @condition_key = condition_key
          @condition_value = condition_value
        end

        def run
          target_collection = "#{origin_class.collection_name}_#{condition_value}"

          origin_class.collection.aggregate([
                                              {'$match': {condition_key => condition_value}},
                                              {'$out': target_collection}
                                            ]).first

        end
      end
    end
  end
end
