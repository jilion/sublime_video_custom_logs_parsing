require "spec_helper"

describe LogReaderWorker do
  let(:fog_file) { double('fog_file', body: fixture_file('logs/voxcast/4076.voxcdn.com.log.1355880780-1355880840.gz').read) }
  let(:worker) { described_class.new }

  describe '#perform' do
    before do
      expect(worker).to receive(:_fog_file) { fog_file }
    end

    context 'without any record for this day' do
      it 'delays LogLineParserWorker for each line in the log file' do
        expect { worker.perform(Time.at(1355880780).to_s) }.to change(DailyViewsPerCountry, :count).by(1)

        expect(worker.send(:_log_filename)).to eq('voxcast/4076.voxcdn.com.log.1355880780-1355880840.gz')
      end
    end

    context 'with already a record for this day' do
      before do
        @views = DailyViewsPerCountry.create!(day: Time.at(1355880780).to_date, lines_parsed: 0, views_per_country: { 'it' => 12, 'fr' => 42 })
      end

      it 'does not create a new record' do
        expect { worker.perform(Time.at(1355880780).to_s) }.to_not change(DailyViewsPerCountry, :count)
      end

      it 'increments the views for the parsed country' do
        worker.perform(Time.at(1355880780).to_s)

        @views.reload.views_per_country['it'].should eq '13'
        @views.views_per_country['fr'].should eq '43'
      end
    end
  end

end
