class BookingsController < ApplicationController
  def index
    @bookings = Booking.where(user: current_user)
    skip_policy_scope
  end

  def show
    @booking = Booking.find(params[:id])
    if params["approved"] == "accepted"
      @booking.approved = "accepted"
    else
      @booking.approved = "rejected"
    end
    @booking.save
    authorize @booking
    redirect_to bookings_myrents_path
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    authorize @booking
    @sock = Sock.find(params[:sock_id])
    @booking.sock = @sock
    @booking.user = current_user
    if @booking.save
      redirect_to bookings_path(@booking)
    else
      render 'socks/show'
    end
  end

  def myrents
    @bookings = []
    socks = Sock.select(:id).where(user: current_user)
    unless socks == []
      @bookings = Booking.where('sock_id IN (?)', socks)
    else
      booking = Booking.new
      @bookings << booking
    end
    authorize @bookings
  end

  def accept
  end

  private

  def booking_params
    params.require(:booking).permit(:start_at, :end_at, :user_id, :sock_id)
  end
end
