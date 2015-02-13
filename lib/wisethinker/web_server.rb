require 'sinatra/base'
require "slim"
require 'wisethinker/config/config.rb'
require_relative 'helpers.rb'

#White list document types that are [view|search]able
ACCEPTABLE_LISTING_TYPES = ['book-review', 'article']

module Wisethinker
  class WebServer < ::Sinatra::Base

    set :static, true
    set :docs, Wisethinker::Config::DOCUMENT_ACCESSOR
    helpers Wisethinker::Helpers

    get '/' do
      redirect '/listings'
    end

    get '/listings/?' do
      documents = settings.docs.listing(ACCEPTABLE_LISTING_TYPES)
      slim :listing, layout: :layout_listing, locals: {documents: documents}
    end

    get '/listings/:type' do
      halt(404) unless ACCEPTABLE_LISTING_TYPES.include?(params[:type])
      documents = settings.docs.listing(params[:type])
      slim :listing, layout: :layout_listing, locals: {documents: documents}
    end

    get '/:type/:url_name' do
      document = settings.docs.document(type: params[:type], url_name: params[:url_name])
      halt(404) unless document
      documents = settings.docs.listing(ACCEPTABLE_LISTING_TYPES)
      slim :document, layout: :document_layout, locals: {document: document, documents: documents}
    end

    get '/error' do
      raise 'problem'
    end

    not_found do
      status 404
      slim :"404"
    end

    error do
      status 500
      slim :"500"
    end
  end

end
