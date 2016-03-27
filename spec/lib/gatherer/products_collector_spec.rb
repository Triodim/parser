require 'rails_helper'

describe Gatherer::ProductsCollector do
  describe '#process' do
    let(:page) { double }
    let(:mechanize) { double }
    let(:url) { 'test.com' }
    let(:collector) { described_class.new([url]) }

    let(:products_data) do
      [
        {
          price: '1,990',
          title: 'ProFlex Isolate vanilla 5 LB. โปร',
          sku: '0111800202171',
          url: 'www.tvdirect.tv/dtm-proflex-isolate-vanilla-5-lb'
        },
        {
          price: '2,990',
          title: 'Ab Prince Pro เครื่องบริหารหน้าท้อง',
          sku: '0121700601493',
          url: 'www.tvdirect.tv/ab-prince-pro'
        }
      ]
    end

    let(:products_cards) do
      products_data.map do |data|
        card = double
        sku_node = double
        url_node = double
        allow(sku_node).to receive(:[]).
          with(:value).
          and_return(data[:sku])
        allow(url_node).to receive(:[]).
          with(:href).
          and_return(data[:url])

        allow(card).to receive(:at).exactly(4).times.
          and_return(
            double(text: data[:price]),
            double(text: data[:title]),
            sku_node,
            url_node
        )

        card
      end
    end

    before do
      allow_any_instance_of(Mechanize).to receive(:get).
        and_return(mechanize)

      allow(collector).to receive(:setup_page).and_return(page)

      allow(page).to receive(:search).
        with('li.item').
        and_return(products_cards)

      allow(page).to receive(:at).with('a.next')
    end

    subject { collector.process }

    it 'returns expected data' do
      is_expected.to eq(
        'test.com' => [
          {
            price: 1990.0,
            title: 'ProFlex Isolate vanilla 5 LB. โปร',
            sku: '0111800202171',
            url: 'www.tvdirect.tv/dtm-proflex-isolate-vanilla-5-lb'
          },
          {
            price: 2990.0,
            title: 'Ab Prince Pro เครื่องบริหารหน้าท้อง',
            sku: '0121700601493',
            url: 'www.tvdirect.tv/ab-prince-pro'
          }
        ]
      )
    end
  end
end
