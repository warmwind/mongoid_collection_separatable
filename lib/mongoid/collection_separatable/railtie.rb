module Mongoid
  module CollectionSeparatable
    class Railtie < ::Rails::Railtie
      rake_tasks do
        load 'mongoid/collection_separatable/tasks/separate.rake'
      end
    end
  end
end
