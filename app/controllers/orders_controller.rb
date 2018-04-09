class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.cart
    @total = @orders.inject(0) {|total,order| total += order.product.price * order.quantity}
  end

  def create

    @previus_order = Order.find_by(user_id: current_user.id, product_id: params[:product_id], payed: false)

    if @previus_order.present?
      new_quantity = @previus_order.quantity + 1
      @previus_order.update(quantity: new_quantity)
    else
      @order = Order.new()
      @order.product = Product.find(params[:product_id])
      @order.user = current_user

      if @order.save
        redirect_to root_path, notice: 'Se ha a gregado el producto!'
      else
        redirect_to root_path, alert: 'No se ha podido agregar el producto :('
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])

    if @order.quantity == 1
      @order.destroy
      if @order.save
        redirect_to orders_path, notice: 'Carro actuaizado'
      else
        redirect_to orders_path, alert: 'No se ha podido actualizar el carro'
      end
    elsif @order.quantity > 1
      @order.quantity -= 1
      if @order.save
        redirect_to orders_path, notice: 'Carro actuaizado'
      else
        redirect_to orders_path, alert: 'No se ha podido actualizar el carro'
      end
    end
  end

  def destroy_all
    current_user.orders.destroy_all
    if current_user.orders.nil?
      redirect_to orders_path, alert: 'No se ha podido actualizar el carro'
    else
      redirect_to orders_path, notice: 'Carro actuaizado'
    end
  end

end
