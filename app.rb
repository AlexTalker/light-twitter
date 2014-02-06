#!/usr/bin/env ruby
require 'rubygems'
require 'erb'
require 'sinatra'
require './posts'

enable :sessions

$msgs = Array.new

# added a explot guard

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

# class Stream
# 	def each
# #		$msgs.each_with_index { |item, index| yield "#{item[0]}<br/>#{item[1]}<br/>#{item[2]}<br/>---------------------------<br\>"}
# 		"<a href='/stream/1'>Go to first stream page!</a>"
# 	end
# end
get '/' do
	session[:name] = ""
	session[:msg] = ""
	redirect to('/stream')
end

post '/post' do
	session[:notification] = (erb :post, :locals => {:time => Time.now}, :layout => false).to_s
	redirect to('/stream/')
end
# Stream messages page
get '/stream/:page' do

	n = params[:page].to_i
	if (n.integer?) and (n>0) and (last_post_id >= ((n-1) * 10))
		erb :stream, :locals => {:n => n, :title => "Page #{n}"}
	else
		halt 404
	end
end

get('/stream/?') { redirect to('/stream/1') }

error 404 do
	erb :not_found, :layout => false
end