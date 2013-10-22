require 'redis'
require 'sinatra/base'

require 'dirt/api'

module Dirt
  class Web < Sinatra::Base
    use API

    set :public_folder, File.join(File.dirname(__FILE__), 'public')

    def redis
      @redis ||= Redis.new
    end

    get '/' do
      liquid :index, locals: {
        tokens: redis.get('tokens:total'),
        samples: redis.get('samples:total'),
        languages: redis.hlen('samples')
      }
    end
  end
end