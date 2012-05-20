require 'net/http'
class PagesController < ApplicationController
  def home
    @keyword = params[:q]
  end

  def refresh
    source = 1275314749
    keyword = params[:q]
    #uri = URI.parse("http://api.t.sina.com.cn/search.json?source=1275314749&q=#{keyword}")
    uri = URI("http://api.t.sina.com.cn/search.json")
    parameters = { :source => source, :q => keyword }
    uri.query = URI.encode_www_form(parameters)
    res = Net::HTTP.get_response(uri)
    puts res.body
    @temp = ActiveSupport::JSON.decode(res.body) #handle BUG with html entities encode error
    respond_to do |format|
      format.html # receive.html.erb
      format.json { render :json => @temp }
    end
  end

  def create
  end

  def destroy
  end

  def about
  end
end
