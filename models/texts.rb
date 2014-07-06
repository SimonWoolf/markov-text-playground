require 'aws/s3'

class Texts
  def initialize
    AWS::S3::Base.establish_connection!({
      access_key_id: ENV['MARKOV_S3_ID'],
      secret_access_key: ENV['MARKOV_S3_SECRET']
    })
    AWS::S3::DEFAULT_HOST.replace "s3-eu-west-1.amazonaws.com"
    @bucket = AWS::S3::Bucket.find('semw-markov-playgen')
  end

  def list(refresh = false)
    param = :reload if refresh
    @bucket.objects(param).map(&:path).map do |path|
      path[21..-1] # strip the bucket name off the path
    end
  end

  def add(name, data)
    AWS::S3::S3Object.store "#{name}.txt", data, @bucket.name
  end

  def get(name)
    AWS::S3::S3Object.value "#{name}.txt", @bucket.name
  end

  def delete(name)
    AWS::S3::S3Object.delete "#{name}.txt", @bucket.name
  end
end
