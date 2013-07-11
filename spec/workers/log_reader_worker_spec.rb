require "spec_helper"

describe LogReaderWorker do
  let(:fog_file) { double('fog_file', body: fixture_file('logs/voxcast/4076.voxcdn.com.log.1355880780-1355880840.gz').read) }
  let(:worker) { described_class.new }

  before do
    Sidekiq::Worker.clear_all
  end

  describe '#perform' do
    before do
      expect(worker).to receive(:_fog_file) { fog_file }
    end

    context 'without any record for this day' do
      it 'delays LogLineParserWorker for each line in the log file' do
        expect(DatabaseUpdaterWorker).to receive(:perform_async).with(Time.at(1355880780), {"it"=>1, "us"=>93, "kr"=>14, "pa"=>1, "uk"=>2, "au"=>4, "ca"=>7, "do"=>1, "id"=>1, "tr"=>2, "mx"=>1, "nz"=>1, "kw"=>2, "fr"=>1, "pt"=>1, "za"=>2, "at"=>1, "bs"=>1, "th"=>1, "co"=>1, "be"=>1, "tw"=>1})

        worker.perform(Time.at(1355880780).to_s)

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

        Sidekiq::Worker.drain_all

        @views.reload.views_per_country['it'].should eq '13'
        @views.views_per_country['fr'].should eq '43'
      end
    end
  end

end
