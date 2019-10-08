require 'uri'
require 'net/http'
require 'json'

# small changes

class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token



  def deleteOrder(orderID)
    uri = URI.parse("https://sandbox.urb-it.com/v3/checkouts/#{orderID}")
    request = Net::HTTP::Delete.new(uri)
    request["Authorization"] = "Bearer <JWT Authorization Header>"
    request["X-Api-Key"] = "<Urb-it API Key>"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response.code
    answer = response.body
    jsonAnswer = JSON.parse(answer)
    end

  def setDateTimeRecipient(checkoutId, json)
    uri = URI.parse("https://sandbox.urb-it.com/v3/checkouts/#{checkoutId}/delivery")
    request = Net::HTTP::Put.new(uri)
    request["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMDE4NzAxNS02MjUxLTQ5NDYtOTJiZC04MDVkNDAxMGVkY2YiLCJpYXQiOjE1NjkzMTI0NzUsInJvbGVzIjpbInJldGFpbGVyIl0sInN1YiI6IjkyMDEyNDE5LWQ3M2EtNDJmNS1hMTJjLWNkY2MyMDc0MGRlMyIsImlzcyI6InVyYml0LmNvbSIsIm5hbWUiOiJHXHUwMGUydGVhdXggZCdcdTAwYzltb3Rpb25zIFBhcmlzIiwiZXhwIjoxODg0NjcyNDc1fQ.P3YVPLgkbjJxD-A5-4-e_Cvx3xDmFDJMJIHB7NS5cos"
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    request.body = json
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response.code
    answer = response.body
    jsonAnswer = JSON.parse(answer)
  end

  def checkout(checkoutId)
    uri = URI.parse("https://sandbox.urb-it.com/v2/checkouts/#{checkoutId}")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMDE4NzAxNS02MjUxLTQ5NDYtOTJiZC04MDVkNDAxMGVkY2YiLCJpYXQiOjE1NjkzMTI0NzUsInJvbGVzIjpbInJldGFpbGVyIl0sInN1YiI6IjkyMDEyNDE5LWQ3M2EtNDJmNS1hMTJjLWNkY2MyMDc0MGRlMyIsImlzcyI6InVyYml0LmNvbSIsIm5hbWUiOiJHXHUwMGUydGVhdXggZCdcdTAwYzltb3Rpb25zIFBhcmlzIiwiZXhwIjoxODg0NjcyNDc1fQ.P3YVPLgkbjJxD-A5-4-e_Cvx3xDmFDJMJIHB7NS5cos"
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    response.code
    answer = response.body
    jsonAnswer = JSON.parse(answer)

    render json: {answer: jsonAnswer}
  end

  def initiateCheckOut(cartId)
    uri = URI.parse("https://sandbox.urb-it.com/v3/checkouts/")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMDE4NzAxNS02MjUxLTQ5NDYtOTJiZC04MDVkNDAxMGVkY2YiLCJpYXQiOjE1NjkzMTI0NzUsInJvbGVzIjpbInJldGFpbGVyIl0sInN1YiI6IjkyMDEyNDE5LWQ3M2EtNDJmNS1hMTJjLWNkY2MyMDc0MGRlMyIsImlzcyI6InVyYml0LmNvbSIsIm5hbWUiOiJHXHUwMGUydGVhdXggZCdcdTAwYzltb3Rpb25zIFBhcmlzIiwiZXhwIjoxODg0NjcyNDc1fQ.P3YVPLgkbjJxD-A5-4-e_Cvx3xDmFDJMJIHB7NS5cos"
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    request.body =
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response.code
    answer = response.body
    jsonAnswer = JSON.parse(answer)
    @checkoutId =jsonAnswer["id"]
    checkout(@checkoutId)
  end

  def initiateCart
    uri = URI.parse("https://sandbox.urb-it.com/v2/carts")
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMDE4NzAxNS02MjUxLTQ5NDYtOTJiZC04MDVkNDAxMGVkY2YiLCJpYXQiOjE1NjkzMTI0NzUsInJvbGVzIjpbInJldGFpbGVyIl0sInN1YiI6IjkyMDEyNDE5LWQ3M2EtNDJmNS1hMTJjLWNkY2MyMDc0MGRlMyIsImlzcyI6InVyYml0LmNvbSIsIm5hbWUiOiJHXHUwMGUydGVhdXggZCdcdTAwYzltb3Rpb25zIFBhcmlzIiwiZXhwIjoxODg0NjcyNDc1fQ.P3YVPLgkbjJxD-A5-4-e_Cvx3xDmFDJMJIHB7NS5cos"
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    request.body = {items: JSON.parse(params['items'].to_s)}.to_json
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response.code
    answer = response.body

    jsonAnswer = JSON.parse(answer)
    p 'iiiiiii'
    p jsonAnswer["meta"]["fees"]["amount"]
    p 'iiiiiii'
    @cartId = jsonAnswer["id"]
    render json: {answer: jsonAnswer}
  end

  def deliveryValid
    #getting info on wether the area is inside delivery area
    uri = URI.parse("https://sandbox.urb-it.com/v2/postalcodes/#{params[:postcode]}")
    request = Net::HTTP::Get.new(uri)
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
     response.code
     answer = response.body
     jsonAnswer = JSON.parse(answer)
     @answer = jsonAnswer["inside_delivery_area"]
     # if it is, then we get the hash of all delivery slots available
      if @answer != "no"
       uri = URI.parse("https://sandbox.urb-it.com/v2/deliveryhours")
       request = Net::HTTP::Get.new(uri)
       request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
       req_options = {
         use_ssl: uri.scheme == "https",
       }

       response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
         http.request(request)
       end
       response.code
       deliverySlots = response.body
       jsonDeliverySlots = JSON.parse(deliverySlots)
       render json: {answer: jsonDeliverySlots}
      else
    # if not, then we put an error message
       render json: {answer: @answer}
      end
  end

  def shipping
    p params
  shipping = {
     "rates": [
         {
             "service_name": "canadapost-overnight",
             "service_code": "ON",
             "total_price": "1295",
             "description": "This is the fastest option by far",
             "currency": "CAD",
             "min_delivery_date": "2013-04-12 14:48:45 -0400",
             "max_delivery_date": "2013-04-12 14:48:45 -0400"
         },
         {
             "service_name": "fedex-2dayground",
             "service_code": "2D",
             "total_price": "2934",
             "currency": "USD",
             "min_delivery_date": "2013-04-12 14:48:45 -0400",
             "max_delivery_date": "2013-04-12 14:48:45 -0400"
         },
         {
             "service_name": "fedex-priorityovernight",
             "service_code": "1D",
             "total_price": "3587",
             "currency": "USD",
             "min_delivery_date": "2013-04-12 14:48:45 -0400",
             "max_delivery_date": "2013-04-12 14:48:45 -0400"
         }
     ]
  }
  render json: shipping
  end

  def connectApi
    shop_url = "https://5616671f7cf3182a8e046eb9e0705171:5616671f7cf3182a8e046eb9e0705171@thomas-test-theme.myshopify.com"
    ShopifyAPI::Base.site = shop_url
    ShopifyAPI::Base.api_version = '2019-07'
  end

  private

end
