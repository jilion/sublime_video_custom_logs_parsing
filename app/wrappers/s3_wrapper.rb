require 'active_support/core_ext'

module S3Wrapper

  class << self

    def bucket
      @@_bucket ||= case Rails.env
                    when 'development', 'test'
                      'dev.sublimevideo.logs'
                    else
                      'sublimevideo.logs'
                    end
    end

    def bucket_url(bucket)
      "https://s3.amazonaws.com/#{bucket}/"
    end

    def fog_connection
      @fog_connection ||= Fog::Storage.new(
        provider:              'AWS',
        aws_access_key_id:     ENV['S3_ACCESS_KEY_ID'],
        aws_secret_access_key: ENV['S3_SECRET_ACCESS_KEY'],
        region:                'us-east-1'
      )
    end

  end
end
