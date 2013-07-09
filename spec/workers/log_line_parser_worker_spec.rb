require "spec_helper"

describe LogLineParserWorker do

  let(:line) { '- 1 82.48.17.156 2012-12-18 2012-12-18 200 GET "GET /_.gif?t=suwutgs8&e=s&h=e&d=d&pm=h&vu=aids-is-going-to-lose-because&vuo=a&vsq=base&vd=171806&vp=http%3A%2F%2Fd2i8c0bgauwjpv.cloudfront.net%2Fimages%2F19723%2F1351249126_detail_preview.jpg%3F1351249126&vsr=448x252&vs=http%3A%2F%2Fdrwy05o8jkje2.cloudfront.net%2F93710.ogg&vc=7abc4ae5&vcs[]=7abc4ae5&vcs[]=8ed91a53&vsf=ogg&vn=AIDS%20is%20going%20to%20lose%20because...&vno=a&i=1355880780247 HTTP/1.1" 200 "http://zooppa.it/ads/chevron-aids-is-going-to-lose/videos/aids-is-going-to-lose-because" "/_.gif?t=suwutgs8&e=s&h=e&d=d&pm=h&vu=aids-is-going-to-lose-because&vuo=a&vsq=base&vd=171806&vp=http%3A%2F%2Fd2i8c0bgauwjpv.cloudfront.net%2Fimages%2F19723%2F1351249126_detail_preview.jpg%3F1351249126&vsr=448x252&vs=http%3A%2F%2Fdrwy05o8jkje2.cloudfront.net%2F93710.ogg&vc=7abc4ae5&vcs[]=7abc4ae5&vcs[]=8ed91a53&vsf=ogg&vn=AIDS%20is%20going%20to%20lose%20because...&vno=a&i=1355880780247" "?t=suwutgs8&e=s&h=e&d=d&pm=h&vu=aids-is-going-to-lose-because&vuo=a&vsq=base&vd=171806&vp=http%3A%2F%2Fd2i8c0bgauwjpv.cloudfront.net%2Fimages%2F19723%2F1351249126_detail_preview.jpg%3F1351249126&vsr=448x252&vs=http%3A%2F%2Fdrwy05o8jkje2.cloudfront.net%2F93710.ogg&vc=7abc4ae5&vcs[]=7abc4ae5&vcs[]=8ed91a53&vsf=ogg&vn=AIDS%20is%20going%20to%20lose%20because...&vno=a&i=1355880780247" "/_.gif" - 4076.voxcdn.com 815 471 20:33:00 20:33:00 228 "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97 Safari/537.11" - "Amsterdam"' }
  let(:worker) { described_class.new.perform(Time.at(1368605904), line) }

  describe '#perform' do
    context 'without any record for this day' do
      it 'creates a new record' do
        expect { worker }.to change(DailyViewsPerCountry, :count).by(1)
      end
    end

    context 'with already a record for this day' do
      before do
        @views = DailyViewsPerCountry.create!(day: Time.at(1368605904).to_date, lines_parsed: 42, views_per_country: { 'it' => 12, 'fr' => 42 })
      end

      it 'does not create a new record' do
        expect { worker }.to_not change(DailyViewsPerCountry, :count)
      end

      it 'increments the views for the parsed country ' do
        worker

        @views.reload.views_per_country['it'].should eq '13'
      end

      it 'increments the count of lines parsed ' do
        worker

        @views.reload.lines_parsed.should eq 43
      end
    end
  end

end
