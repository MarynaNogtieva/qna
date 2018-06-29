require 'rails_helper'

RSpec.describe Search do
  describe '.find' do
    %w[Question Answer Comment User].each do |search_category|
      it "receives param #{search_category}" do
        expect(search_category.classify.constantize).to receive(:search).with('test')
        Search.search('test', search_category)
      end
    end

    %w[Something ''].each do |search_category|
      it "gets param: #{search_category}" do
        expect(ThinkingSphinx).to receive(:search).with('test')
        Search.search('test', search_category)
      end
    end
  end
end
