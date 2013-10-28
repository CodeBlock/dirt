require 'redis'
require 'sinatra/base'

require 'dirt/api'
require 'dirt/api/meta'
require 'dirt/api/classify'

module Dirt
  class Web < Sinatra::Base
    use API::Meta
    use API::Classify

    set :public_folder, File.join(File.dirname(__FILE__), 'public')

    def redis
      @redis ||= Redis.new
    end

    get '/' do
      liquid :index
    end

    get '/demo' do
      liquid :demo, locals: {
        title: 'Demo',
        demo: 'active',
        js: ['demo']
      }
    end

    get '/api/doc' do
      liquid :api_doc, locals: {
        title: 'API Documentation',
        doc: 'active',
        version: API::VERSION[:string]
      }
    end

    get '/api' do
      redirect to('/api/doc')
    end

    get '/api/:method' do |method|
      redirect to("/api/doc##{method}")
    end

    get '/api/:m1/:m2' do |m1, m2|
      redirect to("/api/doc##{m1}/#{m2}")
    end
  end
end
