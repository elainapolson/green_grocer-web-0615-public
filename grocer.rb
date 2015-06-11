require 'pry'
def consolidate_cart(cart:[])
  counts = Hash.new(0)
  cart_hash = {}
  
  cart.each do |item_hash|
    item_hash.each do |item, detail_hash|
      counts[item] += 1
      cart_hash[item] = detail_hash
        counts.each do |item, count|
          cart_hash[item][:count] = count
        end
    end
  end
  cart_hash
end

def apply_coupons(cart:[], coupons:[])
new_cart = cart
  coupons.each do |coupon|
    if new_cart.has_key?(coupon[:item]) #checking if cart has coupon item
      count = 0
      while new_cart[coupon[:item]][:count] >= coupon[:num]
        count += 1
        new_cart[coupon[:item] + ' W/COUPON'] = {:price => coupon[:cost], :clearance => new_cart[coupon[:item]][:clearance], :count => count}
        new_cart[coupon[:item]][:count] -= coupon[:num]
      end
    end
  end
  new_cart
end

def apply_clearance(cart:[])
  new_cart = cart
  cart.each do |item, item_details|
    if cart[item][:clearance] == true
      new_cart[item][:price] = (cart[item][:price]).to_f - (cart[item][:price] * 0.20).to_f
    end
  end
  new_cart
end



# {:cart=>[{"BEETS"=>{:price=>2.5, :clearance=>false, :count=>1}}]}
# [{"BEETS"=>{:price=>2.5, :clearance=>false, :count=>1}}]

def checkout(cart: [], coupons: [])
  consolidated_cart = consolidate_cart(cart: cart)
  discount_cart = apply_coupons(cart: consolidated_cart, coupons: coupons)
  checkout_cart = apply_clearance(cart: discount_cart)

  total = 0
  checkout_cart.each do |item, item_hash|
    total += item_hash[:price] * item_hash[:count]
  end


  if total.to_f > 100
    total = (total.to_f) * 0.9
  end

  total

end