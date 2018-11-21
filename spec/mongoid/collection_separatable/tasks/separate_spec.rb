require 'spec_helper'

RSpec.describe Mongoid::CollectionSeparatable::Tasks::Separate do
  describe '.run' do
    let(:form) {Form.create}
    before do
      form.entries.create name: 'test1'
      form.entries.create name: 'test2'
      Entry.create form_id: Form.new.id, name: 'test3'
    end
    it 'separate records from one collection into another' do
      Mongoid::CollectionSeparatable::Tasks::Separate.new('Entry', 'form_id', form.id).run

      Entry.with(collection: "entries_#{form.id}") do
        expect(Entry.count).to eq(2)
      end
    end
  end
end
