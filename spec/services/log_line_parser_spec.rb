require 'spec_helper'

describe LogLineParser do

  context "old data request with start event" do
    let(:line) { '- 1 82.48.17.156 2012-12-18 2012-12-18 200 GET "GET /_.gif?t=suwutgs8&e=s&h=e&d=d&pm=h&vu=aids-is-going-to-lose-because&vuo=a&vsq=base&vd=171806&vp=http%3A%2F%2Fd2i8c0bgauwjpv.cloudfront.net%2Fimages%2F19723%2F1351249126_detail_preview.jpg%3F1351249126&vsr=448x252&vs=http%3A%2F%2Fdrwy05o8jkje2.cloudfront.net%2F93710.ogg&vc=7abc4ae5&vcs[]=7abc4ae5&vcs[]=8ed91a53&vsf=ogg&vn=AIDS%20is%20going%20to%20lose%20because...&vno=a&i=1355880780247 HTTP/1.1" 200 "http://zooppa.it/ads/chevron-aids-is-going-to-lose/videos/aids-is-going-to-lose-because" "/_.gif?t=suwutgs8&e=s&h=e&d=d&pm=h&vu=aids-is-going-to-lose-because&vuo=a&vsq=base&vd=171806&vp=http%3A%2F%2Fd2i8c0bgauwjpv.cloudfront.net%2Fimages%2F19723%2F1351249126_detail_preview.jpg%3F1351249126&vsr=448x252&vs=http%3A%2F%2Fdrwy05o8jkje2.cloudfront.net%2F93710.ogg&vc=7abc4ae5&vcs[]=7abc4ae5&vcs[]=8ed91a53&vsf=ogg&vn=AIDS%20is%20going%20to%20lose%20because...&vno=a&i=1355880780247" "?t=suwutgs8&e=s&h=e&d=d&pm=h&vu=aids-is-going-to-lose-because&vuo=a&vsq=base&vd=171806&vp=http%3A%2F%2Fd2i8c0bgauwjpv.cloudfront.net%2Fimages%2F19723%2F1351249126_detail_preview.jpg%3F1351249126&vsr=448x252&vs=http%3A%2F%2Fdrwy05o8jkje2.cloudfront.net%2F93710.ogg&vc=7abc4ae5&vcs[]=7abc4ae5&vcs[]=8ed91a53&vsf=ogg&vn=AIDS%20is%20going%20to%20lose%20because...&vno=a&i=1355880780247" "/_.gif" - 4076.voxcdn.com 815 471 20:33:00 20:33:00 228 "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97 Safari/537.11" - "Amsterdam"' }
    subject { LogLineParser.new(line) }

    its(:ip) { should eq '82.48.17.156' }
    its(:country_code) { should eq 'it' }
    it { should be_gif_request }
    it { should be_get_request }
    it { should be_valid_start_request }
  end

  context "old data request with load event" do
    let(:line) { '- 1 82.48.17.156 2012-12-18 2012-12-18 200 GET "GET /_.gif?t=suwutgs8&e=l&h=e&d=d&pm=h&vu=aids-is-going-to-lose-because&vuo=a&vsq=base&vd=171806&vp=http%3A%2F%2Fd2i8c0bgauwjpv.cloudfront.net%2Fimages%2F19723%2F1351249126_detail_preview.jpg%3F1351249126&vsr=448x252&vs=http%3A%2F%2Fdrwy05o8jkje2.cloudfront.net%2F93710.ogg&vc=7abc4ae5&vcs[]=7abc4ae5&vcs[]=8ed91a53&vsf=ogg&vn=AIDS%20is%20going%20to%20lose%20because...&vno=a&i=1355880780247 HTTP/1.1" 200 "http://zooppa.it/ads/chevron-aids-is-going-to-lose/videos/aids-is-going-to-lose-because" "/_.gif?t=suwutgs8&e=l&h=e&d=d&pm=h&vu=aids-is-going-to-lose-because&vuo=a&vsq=base&vd=171806&vp=http%3A%2F%2Fd2i8c0bgauwjpv.cloudfront.net%2Fimages%2F19723%2F1351249126_detail_preview.jpg%3F1351249126&vsr=448x252&vs=http%3A%2F%2Fdrwy05o8jkje2.cloudfront.net%2F93710.ogg&vc=7abc4ae5&vcs[]=7abc4ae5&vcs[]=8ed91a53&vsf=ogg&vn=AIDS%20is%20going%20to%20lose%20because...&vno=a&i=1355880780247" "?t=suwutgs8&e=l&h=e&d=d&pm=h&vu=aids-is-going-to-lose-because&vuo=a&vsq=base&vd=171806&vp=http%3A%2F%2Fd2i8c0bgauwjpv.cloudfront.net%2Fimages%2F19723%2F1351249126_detail_preview.jpg%3F1351249126&vsr=448x252&vs=http%3A%2F%2Fdrwy05o8jkje2.cloudfront.net%2F93710.ogg&vc=7abc4ae5&vcs[]=7abc4ae5&vcs[]=8ed91a53&vsf=ogg&vn=AIDS%20is%20going%20to%20lose%20because...&vno=a&i=1355880780247" "/_.gif" - 4076.voxcdn.com 815 471 20:33:00 20:33:00 228 "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97 Safari/537.11" - "Amsterdam"' }
    subject { LogLineParser.new(line) }

    it { should_not be_valid_start_request }
  end

  context "non data request" do
    let(:line) { '- 1 82.48.17.156 2012-12-18 2012-12-18 200 GET "GET http://cdn.sublimevideo.net/a/avo5qgqh/1/logo-custom-61x22-1355887767@2x.png HTTP/1.1" 200 "http://zooppa.it/ads/chevron-aids-is-going-to-lose/videos/aids-is-going-to-lose-because" "http://cdn.sublimevideo.net/a/avo5qgqh/1/logo-custom-61x22-1355887767@2x.png" "" "/a/avo5qgqh/1/logo-custom-61x22-1355887767@2x.png" - 4076.voxcdn.com 815 471 20:33:00 20:33:00 228 "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.97 Safari/537.11" - "Amsterdam"' }
    subject { LogLineParser.new(line) }

    it { should_not be_valid_start_request }
  end

  context "request with no filesize" do
    let(:line) { "1368605176 0 81.215.91.112 - 108.161.243.145 80 TCP_HIT/304 384 GET http://cdn.sublimevideo.net/s/avo5qgqh.js - 0 567 \"-\" \"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.21 (KHTML, like Gecko) Chrome/25.0.1359.3 Safari/537.21\" 33820" }
    subject { LogLineParser.new(line) }

    it { should_not be_valid_start_request }
  end
end
