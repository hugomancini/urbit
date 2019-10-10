require 'uri'
require 'net/http'
require 'json'

# small changes

class PagesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def deliveryValid
    puts "________ DELIVERY VALID ________"
    #getting info on wether the area is inside delivery area
    puts "________ ADDRESS? ________"

    uri = URI.parse("https://sandbox.urb-it.com/v2/postalcodes/#{params['postcode']}")
    request = Net::HTTP::Get.new(uri)
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    puts "________ Response ________"
    puts answer = response.body

    jsonAnswer = JSON.parse(answer)
    p @answer = jsonAnswer["inside_delivery_area"]
     # if it is, then we get the hash of all delivery slots available
    if @answer == "yes"
      puts "________ HOURS? ________"

      uri = URI.parse("https://sandbox.urb-it.com/v2/deliveryhours")
      request = Net::HTTP::Get.new(uri)
      request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
      req_options = {
        use_ssl: uri.scheme == "https",
      }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      c_o = CheckOut.find_by({cart_token: params['cart_token'] })
      if c_o.nil?
        c_o = CheckOut.new
        c_o.cart_token = params['cart_token']
      end
      c_o.valid_address = jsonAnswer['address']
      c_o.address_2 = params['address_2']
      c_o.address_1 = params['address']
      c_o.email = params['email']
      c_o.message = params['message']
      c_o.first_name = params['name'].split(' ')[0]
      c_o.last_name = params['name'].split(' ').drop(1).join(' ')
      c_o.city = params['city']
      c_o.postcode = params['postcode']
      c_o.phone_number = params['phone']
      c_o.save

      puts "________ response ________"
      deliverySlots = response.body
      jsonDeliverySlots = JSON.parse(deliverySlots)
      render json: {answer: jsonDeliverySlots}
    else
    # if not, then we put an error message
       render json: {answer: "no"}
    end
  end

  def initiateCart
    puts "________ INITIATE CART ________"
    items_from_cart = JSON.parse(params['cartJS'])
    items = []
    items_from_cart['items'].each do |item|
      new_item = {
                    sku: item['sku'],
                    name: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                    vat: 2000
                  }
      items << new_item
    end

    p items[0]

    uri = URI.parse("https://sandbox.urb-it.com/v2/carts")
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMDE4NzAxNS02MjUxLTQ5NDYtOTJiZC04MDVkNDAxMGVkY2YiLCJpYXQiOjE1NjkzMTI0NzUsInJvbGVzIjpbInJldGFpbGVyIl0sInN1YiI6IjkyMDEyNDE5LWQ3M2EtNDJmNS1hMTJjLWNkY2MyMDc0MGRlMyIsImlzcyI6InVyYml0LmNvbSIsIm5hbWUiOiJHXHUwMGUydGVhdXggZCdcdTAwYzltb3Rpb25zIFBhcmlzIiwiZXhwIjoxODg0NjcyNDc1fQ.P3YVPLgkbjJxD-A5-4-e_Cvx3xDmFDJMJIHB7NS5cos"
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    request.body = {items: items}.to_json
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    response.code
    urbit_free = items_from_cart['items_subtotal_price'] > 6000

    puts "________ Response ________"
    answer = response.body

    puts jsonAnswer = JSON.parse(answer)
    c_o = CheckOut.find_by({cart_token: items_from_cart['token']})

    tmp_dattim = params['delivery_time'].in_time_zone('Paris')
    c_o.delivery_time = tmp_dattim.to_json
    c_o.u_cart_id = jsonAnswer["id"]
    c_o.free_urbit = urbit_free
    c_o.fees = urbit_free ? 0 : jsonAnswer["meta"]['fees'][0]["amount"]
    c_o.save

    initiateCheckOut(c_o)
    if urbit_free
      jsonAnswer["meta"]['fees'][0]["amount"] = 0
      render json: {answer: jsonAnswer}
    else
      render json: {answer: jsonAnswer}
    end

  end

  def initiateCheckOut(checkout)
    puts "________ INITIATE CHECKOUT ________"
    uri = URI.parse("https://sandbox.urb-it.com/v3/checkouts/")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMDE4NzAxNS02MjUxLTQ5NDYtOTJiZC04MDVkNDAxMGVkY2YiLCJpYXQiOjE1NjkzMTI0NzUsInJvbGVzIjpbInJldGFpbGVyIl0sInN1YiI6IjkyMDEyNDE5LWQ3M2EtNDJmNS1hMTJjLWNkY2MyMDc0MGRlMyIsImlzcyI6InVyYml0LmNvbSIsIm5hbWUiOiJHXHUwMGUydGVhdXggZCdcdTAwYzltb3Rpb25zIFBhcmlzIiwiZXhwIjoxODg0NjcyNDc1fQ.P3YVPLgkbjJxD-A5-4-e_Cvx3xDmFDJMJIHB7NS5cos"
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    request.body = {cart_reference: checkout.u_cart_id.to_s}.to_json
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    puts "________ Response ________"
    p response.code
    p answer = response.body

    jsonAnswer = JSON.parse(answer)
    checkout.u_checkout_id = jsonAnswer["id"]
    checkout.save

  end

  def setDateTimeRecipient
    puts "____________ setDateTimeRecipient __________"
    checkout = CheckOut.find_by({cart_token: params['cart_token']})
    json = {
      "delivery_time": DateTime.parse(checkout.delivery_time),
              "message": checkout.message,
              "recipient": {
                "first_name": checkout.first_name,
                "last_name": checkout.last_name,
                "address_1": checkout.address_1,
                "address_2": checkout.address_2,
                "city": checkout.city,
                "postcode": checkout.postcode,
                "phone_number": checkout.phone_number,
                "email": checkout.email
              }
    }
    uri = URI.parse("https://sandbox.urb-it.com/v3/checkouts/#{checkout.u_checkout_id}/delivery")
    request = Net::HTTP::Put.new(uri)
    request["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzMDE4NzAxNS02MjUxLTQ5NDYtOTJiZC04MDVkNDAxMGVkY2YiLCJpYXQiOjE1NjkzMTI0NzUsInJvbGVzIjpbInJldGFpbGVyIl0sInN1YiI6IjkyMDEyNDE5LWQ3M2EtNDJmNS1hMTJjLWNkY2MyMDc0MGRlMyIsImlzcyI6InVyYml0LmNvbSIsIm5hbWUiOiJHXHUwMGUydGVhdXggZCdcdTAwYzltb3Rpb25zIFBhcmlzIiwiZXhwIjoxODg0NjcyNDc1fQ.P3YVPLgkbjJxD-A5-4-e_Cvx3xDmFDJMJIHB7NS5cos"
    request["X-Api-Key"] = "92012419-d73a-42f5-a12c-cdcc20740de3"
    request.body = json.to_json
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    puts "____________ Response ______________"
    puts response.code
    answer = response.body
    render json: answer
  end


###################### [ START ]CARRIER SERVICES [ START ]########################

  def create_carrier_service
    puts " ____________ CREATE CARRIER SERVICE  ______"
    connectApi
    ShopifyAPI::CarrierService.create({
      "carrier_service": {
        "name": "Livraison à vélo avec Urbit",
        "callback_url": "https://077c99fd.ngrok.io/shipping",
        "service_discovery": true
      }
    })
  end



  def shipping
    puts " ____________ SHIPPING  ______"

    cart_token = params["rate"]["items"][0]["properties"]["urbit_token"]
    c_o = CheckOut.find_by(cart_token: cart_token)


    shipping = {
       "rates": [
           {
               "service_name": "Livraison à domicile Urbit",
               "service_code": "ON",
               "total_price": c_o.fees,
               "description": c_o.delivery_time.to_datetime.strftime("Livraison prévue le %d/%m/%Y à %H:%M"),
               "currency": "EUR",
               "min_delivery_date": "2013-04-12 14:48:45 -0400",
               "max_delivery_date": "2013-04-12 14:48:45 -0400"
           }
       ]
    }
  p json: shipping
  render json: shipping
  end


###################### [  END  ]CARRIER SERVICES [  END  ] ########################







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


  def create_checkout

  end


  private

  def connectApi
    shop_url = "https://5616671f7cf3182a8e046eb9e0705171:3d7821e24c16e04f5a65c44971f7c5e1@thomas-test-theme.myshopify.com"
    ShopifyAPI::Base.site = shop_url
    ShopifyAPI::Base.api_version = '2019-10'
  end
end
