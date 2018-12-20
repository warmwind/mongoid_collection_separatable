module Mongoid
  module CollectionSeparatable
    module Tasks
      class Separate
        attr_accessor :origin_class, :condition_key, :condition_value

        def initialize opts={}
          @origin_class = opts[:origin_class].constantize
          @condition_key = opts[:condition_key]
          @condition_value = opts[:condition_value] = BSON::ObjectId.legal?(opts[:condition_value]) ? BSON::ObjectId.from_string(opts[:condition_value]) : opts[:condition_value]
        end

        def run
          target_collection = "#{origin_class.collection_name}_#{condition_value}"

          origin_class.with(collection: target_collection) {Entry.create_indexes}
          origin_class.collection.aggregate([
                                              {'$match': {condition_key => condition_value}},
                                              {'$out': target_collection}
                                            ]).first

        end
      end
    end
  end
end
