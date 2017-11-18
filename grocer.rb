require 'pry'

def consolidate_cart(items)
	consolidated = {}
	items.each do |indiv_item| #{avocados=>{}
    indiv_item.each do |item_name, info_hash| #avocado, {price => 10, clearance => false}
      if consolidated.include?(item_name) #already has avocados
		    consolidated[item_name][:count] += 1 #then add one to the count for avocados
      else #does not have avocados
        consolidated[item_name] = info_hash  #put in avocadoes, with its has of attributes
        info_hash[:count] = 1 #add count and make it equal to 1, for this first one
      end
    end
  end
  consolidated
end


def apply_coupons(cart, coupons)
	new = {}
  coupons.each do |coupon| # {item => avocado, num=>2, cost => 3}...  checking through each coupon....
    cart.each do |item, info_hash| #avocado, {price => 2. clearance => false, count => 3}
      if coupon[:item] == item #we're on a round where the coupon item matches the cart item
				if coupon[:num] <= info_hash[:count] #only if the coupon applies to a subset of cart (e.g. N/A if coupon calls for 2, and cart has 1)
					info_hash[:count] -= coupon[:num]
					if new.include?("#{item} W/COUPON")
						new["#{item} W/COUPON"][:count] += 1
					else
						new["#{item} W/COUPON"] = {}
          	new["#{item} W/COUPON"][:price] = coupon[:cost]
          	new["#{item} W/COUPON"][:clearance] = info_hash[:clearance]
          	new["#{item} W/COUPON"][:count] = 1
					end
				end
			end
    end
  end
  cart.merge(new)
end


def apply_clearance(cart)
	cart.each do |item, info_hash|
		if info_hash[:clearance] == true  #try different ways of getting at same variable.  also what happens if directly operate?
			info_hash[:price] = ((info_hash[:price])*0.8).round(2)
		end
	end
end

def checkout(cart, coupons)
	cons = consolidate_cart(cart)
	new_cart = apply_coupons(cons, coupons)
	total = 0
	apply_clearance(new_cart).each do |item, info_hash|
		total += info_hash[:price]*info_hash[:count]
		end
	if total > 100
		total*0.9
	else
		total
	end
end
