class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: %i[create]
  before_action :set_line_item, only: %i[show edit update destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_line_item

  def index
    @line_items = LineItem.all
  end

  def show
  end

  def new
    @line_item = LineItem.new
  end

  def edit
  end

  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product)

    respond_to do |format|
      if @line_item.save
        format.turbo_stream { @current_item = @line_item }
        format.html { redirect_to store_index_url }
        format.json { render :show, status: :created, location: @line_item }
        #Reset the counter to zero whenever the user adds something to the cart.
        session[:counter] = 0
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to line_item_url(@line_item), notice: "Line item was successfully updated." }
        format.json { render :show, status: :ok, location: @line_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to line_items_url, notice: "Line item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def decrement
    @line_item = LineItem.find(params[:id])
    if @line_item.quantity > 1
      @line_item.quantity -= 1
      @line_item.save
    else
      @line_item.destroy
    end

    #respond_to do |format|
      #if @line_item.save
        #format.turbo_stream { @current_item = @line_item }
        #format.html { redirect_to store_index_url }
      #else
        #format.html { render :new, status: :unprocessable_entity }
      #end
    #end
    redirect_to store_index_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end

    def invalid_line_item
      logger.error "Attempt to access invalid line item #{params[:id]}"
      redirect_to store_index_url, notice: 'Invalid Line Item'
    end
end
