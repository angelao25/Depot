class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  def decrease_quantity(product)
    current_item = line_items.find_by(product_id: product.id)
    if current_item && current_item.quantity > 0
      current_item.quantity -= 1
      current_item
    else
      current_item.destroy
    end
  end

  def total_price
    product.price * quantity
  end
end
