class SocksController < ApplicationController
  def index
   if params[:query].present?
     @socks = Sock.search(params[:query])
   else
     @socks = Sock.all
   end
    skip_policy_scope
 end

  def show
    @sock = Sock.find(params[:id])
    @booking = Booking.new
    authorize @sock
  end

  def create
    @sock = Sock.new(sock_params)
    @sock.user = current_user
    authorize @sock
    if @sock.save
      redirect_to sock_path(@sock)
    else
      render :new
    end
  end

  def new
    @sock = Sock.new()
    authorize @sock
  end
  def edit
    @sock = Sock.find(params[:id])
    authorize @sock
  end
  def update
    @sock = Sock.new(sock_params)
    authorize @sock
    if @sock.save
      redirect_to sock_path(@sock)
    else
      render :edit
    end
  end

  def mysocks
    @socks = Sock.where(user: current_user)
    authorize @socks
  end

  def destroy
    @sock = Sock.find(params[:id])
    @sock.destroy
    authorize @sock
    redirect_to socks_path
  end

  private
  def sock_params
    params.require(:sock).permit(:color, :title, :description, :category,
    :price, :size, :photo, :search)
  end
end
