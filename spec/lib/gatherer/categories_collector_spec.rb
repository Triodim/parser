require 'rails_helper'

describe Gatherer::CategoriesCollector do
  describe '#process' do
    let(:page) { double }

    let(:links_data) do
      [
        {title: 'link1', url: 'href1'},
        {title: 'link2', url: 'href2'},
        {title: 'link3', url: 'href3'}
      ]
    end

    let(:links) do
      links_data.map do |link_data|
        link = double(text: link_data[:title])
        allow(link).to receive(:[]).with(:href).and_return(link_data[:url])

        link
      end
    end

    before do
      allow_any_instance_of(Mechanize).to receive(:get).
        with(described_class::HOME_PAGE).
        and_return(page)

      allow(page).to receive(:search).and_return(links)
    end

    subject { described_class.new.process }

    it { is_expected.to eq(links_data) }
  end
end
