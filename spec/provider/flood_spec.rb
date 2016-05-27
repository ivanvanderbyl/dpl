require 'spec_helper'
require 'dpl/provider/flood'

describe DPL::Provider::Flood do
  subject :provider do
    described_class.new DummyContext.new, {}
  end

  describe "#deploy" do
    it 'should make a POST to webhook endpoint' do
      provider.options.update(:flood_id => '12345')
      expect(provider.context).to receive(:shell).with("curl -X POST https://api.flood.io/floods/12345/webhook")
      provider.deploy
    end

    it 'should not make a request without :flood_id' do
      provider.options.update(:flood_id => nil)
      expect{ provider.deploy }.to raise_error("must supply flood_id option or FLOOD_ID environment variable")
    end

    it 'should encode params for :grid' do
      provider.options.update(:flood_id => '12345', grid: '66')
      expect(provider.context).to receive(:shell).with("curl -X POST https://api.flood.io/floods/12345/webhook?grid=66")
      provider.deploy
    end

    it 'should encode params for regions' do
      provider.options.update(:flood_id => '12345', region: 'us-west-2')
      expect(provider.context).to receive(:shell).with("curl -X POST https://api.flood.io/floods/12345/webhook?region=us-west-2")
      provider.deploy
    end
  end
end
