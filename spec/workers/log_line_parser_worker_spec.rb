require "spec_helper"

describe LogLineParserWorker do

  let(:line) { "1368605904 0 66.249.74.142 35 108.161.246.64 80 TCP_HIT/200 398 GET http://cdn.sublimevideo.net/_.gif?t=2xrynuh2&e=s&du=http%3A%2F%2Fwww.arhsinflight.com%2F2010%2F10%2F14%2F&em=1&eu=http%3A%2F%2Fwww.schooltube.com%2Fembed%2Fc327d6b4f2442587514a%2F&sr=1024x1024&bl=en&fv=10.1.53&pt%5B%5D=n&pm%5B%5D=f&pff%5B%5D=&pz%5B%5D=298x225&vu%5B%5D=c327d6b4f2442587514a&h=m&i=1340064000000&d=d&em=1 - 0 588 \"-\" \"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)\" 33820" }
  let(:parsed_line) { LogLineParser.new(line) }

  describe '#perform' do
    context 'without any record for this day' do
      it 'creates a new record' do
        expect { described_class.new.perform(line) }.to change(DailyViewsPerCountry, :count).by(1)
      end
    end

    context 'with already a record for this day' do
      before do
        @views = DailyViewsPerCountry.create!(day: parsed_line.timestamp.to_date, lines_parsed: 42, views_per_country: { 'us' => 12, 'fr' => 42 })
      end

      it 'does not create a new record' do
        expect { described_class.new.perform(line) }.to_not change(DailyViewsPerCountry, :count)
      end

      it 'increments the views for the parsed country ' do
        described_class.new.perform(line)

        @views.reload.views_per_country['us'].should eq '13'
      end

      it 'increments the count of lines parsed ' do
        described_class.new.perform(line)

        @views.reload.lines_parsed.should eq 43
      end
    end
  end

end
