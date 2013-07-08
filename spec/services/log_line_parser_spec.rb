require 'spec_helper'

describe LogLineParser do

  context "old data request with start event" do
    let(:line) { "1368605904 0 66.249.74.142 35 108.161.246.64 80 TCP_HIT/200 398 GET http://cdn.sublimevideo.net/_.gif?t=2xrynuh2&e=s&du=http%3A%2F%2Fwww.arhsinflight.com%2F2010%2F10%2F14%2F&em=1&eu=http%3A%2F%2Fwww.schooltube.com%2Fembed%2Fc327d6b4f2442587514a%2F&sr=1024x1024&bl=en&fv=10.1.53&pt%5B%5D=n&pm%5B%5D=f&pff%5B%5D=&pz%5B%5D=298x225&vu%5B%5D=c327d6b4f2442587514a&h=m&i=1340064000000&d=d&em=1 - 0 588 \"-\" \"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)\" 33820" }
    subject { LogLineParser.new(line) }

    its(:timestamp) { should eq Time.at(1368605904) }
    its(:ip) { should eq '66.249.74.142' }
    its(:country_code) { should eq 'us' }
    its(:status) { should eq 200 }
    its(:method) { should eq 'GET' }
    its(:uri_stem) { should include 'http://cdn.sublimevideo.net/_.gif?' }
    its(:user_agent) { should eq 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)' }
    it { should be_start_request }
  end

  context "old data request with load event" do
    let(:line) { "1368605904 0 66.249.74.142 35 108.161.246.64 80 TCP_HIT/200 398 GET http://cdn.sublimevideo.net/_.gif?t=2xrynuh2&e=l&du=http%3A%2F%2Fwww.arhsinflight.com%2F2010%2F10%2F14%2F&em=1&eu=http%3A%2F%2Fwww.schooltube.com%2Fembed%2Fc327d6b4f2442587514a%2F&sr=1024x1024&bl=en&fv=10.1.53&pt%5B%5D=n&pm%5B%5D=f&pff%5B%5D=&pz%5B%5D=298x225&vu%5B%5D=c327d6b4f2442587514a&h=m&i=1340064000000&d=d&em=1 - 0 588 \"-\" \"Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)\" 33820" }
    subject { LogLineParser.new(line) }

    its(:timestamp) { should eq Time.at(1368605904) }
    it { should_not be_start_request }
  end

  context "non data request" do
    let(:line) { "1368605419 0 94.250.35.142 2474 46.22.75.231 80 TCP_EXPIRED_HIT/200 2868 GET http://cdn.sublimevideo.net/a/avo5qgqh/1/logo-custom-61x22-1355887767@2x.png - 90 785 \"-\" \"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31\" 33820" }
    subject { LogLineParser.new(line) }

    its(:timestamp) { should eq Time.at(1368605419) }
    its(:uri_stem) { should include 'http://cdn.sublimevideo.net/a' }
    its(:user_agent) { should eq 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.64 Safari/537.31' }
    it { should_not be_start_request }
  end

  context "request with no filesize" do
    let(:line) { "1368605176 0 81.215.91.112 - 108.161.243.145 80 TCP_HIT/304 384 GET http://cdn.sublimevideo.net/s/avo5qgqh.js - 0 567 \"-\" \"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.21 (KHTML, like Gecko) Chrome/25.0.1359.3 Safari/537.21\" 33820" }
    subject { LogLineParser.new(line) }

    its(:timestamp) { should eq Time.at(1368605176) }
    its(:ip) { should eq '81.215.91.112' }
    its(:status) { should eq 304 }
    its(:method) { should eq 'GET' }
    it { should_not be_start_request }
  end
end
