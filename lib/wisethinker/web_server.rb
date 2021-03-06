require 'sinatra/base'
require "slim"
require 'wisethinker/config/config.rb'
require_relative 'helpers.rb'
require 'active_support/core_ext/string/inflections'

module Wisethinker

  #White list document types that will show in listings
  ACCEPTABLE_LISTING_TYPES = ['news', 'book-review', 'article']

  class WebServer < ::Sinatra::Base

    set :static, true
    set :docs, Wisethinker::Config::DOCUMENT_ACCESSOR
    helpers Wisethinker::Helpers

    get '/' do
      redirect '/listings', 303
    end

    get '/listings/?' do
      documents = settings.docs.listing(ACCEPTABLE_LISTING_TYPES)
      slim :listing, layout: :layout_listing, locals: {documents: documents, documents_all: documents, listing_type: 'All'}
    end

    get '/listings/:type' do
      halt(404) unless ACCEPTABLE_LISTING_TYPES.include?(params[:type])
      documents_all = settings.docs.listing(ACCEPTABLE_LISTING_TYPES)
      documents = settings.docs.listing(params[:type])
      slim :listing, layout: :layout_listing, locals: {documents: documents, documents_all: documents_all, listing_type: params[:type]}
    end

    get '/:type/:url_name' do
      document = settings.docs.document(type: params[:type], url_name: params[:url_name])
      halt(404) unless document
      documents_all = settings.docs.listing(ACCEPTABLE_LISTING_TYPES)
      slim :document, layout: :document_layout, locals: {document: document, documents_all: documents_all}
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
