require "spec_helper"

describe LogReaderWorker do
  let(:fog_file) { double('fog_file', body: fixture_file('logs/voxcast/4076.voxcdn.com.log.1355880780-1355880840.gz').read) }
  let(:worker) { described_class.new }

  describe '#perform' do
    before do
      expect(worker).to receive(:_fog_file) { fog_file }
    end

    it 'delays LogLineParserWorker for each line in the log file' do
      expect(LogLineParserWorker).to receive(:perform_async).at_least(140).times

      worker.perform(Time.at(1355880780).to_s)

      expect(worker.send(:_log_filename)).to eq('voxcast/4076.voxcdn.com.log.1355880780-1355880840.gz')
    end
  end

end
