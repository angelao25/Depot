class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  def index
    #Check if the session counter variable is nil
    if session[:counter].nil?
      session[:counter] = 1 # Initialize the counter
    else
      session[:counter] += 1
    end
    @products = Product.order(:title)
  end
end
