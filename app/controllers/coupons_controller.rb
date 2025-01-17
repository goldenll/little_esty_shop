class CouponsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @sorted_coupons = @merchant.sort_coupons_by_popularity
    @upcoming_holidays = HolidayService.new.get_holidays.take(3)
  end

  def new 
  end

  def create
    # require 'pry'; binding.pry
    @merchant = Merchant.find(params[:id]) 
    @coupon = Coupon.new(coupon_params)
    @coupon.merchant_id = @merchant.id
    if @merchant.coupon_count? == true
      redirect_to "/merchants/#{@merchant.id}/coupons/new"
      flash[:alert] = "Error: Too many active coupons"
    elsif @merchant.coupon_valid?(@coupon.code) == true && @coupon.save
      redirect_to "/merchants/#{@merchant.id}/coupons"
    else
      redirect_to "/merchants/#{@merchant.id}/coupons/new"
      flash[:alert] = "Error: Valid data must be entered"
    end
  end

  def show 
    @merchant = Merchant.find(params[:merchant_id]) 
    @coupon = Coupon.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant]) 
    @coupon = Coupon.find(params[:id])
    if params[:deactivate] == "true" && @merchant.check_invoice_status? == true
      @coupon.update(status: "inactive")
    elsif params[:activate] == "true" && @merchant.coupon_count? == false
      @coupon.update(status: "active")
    elsif params[:activate] == "true" && @merchant.coupon_count? == true
      flash[:alert] = "Error: Too many active coupons"
    elsif params[:deactivate] == "true" && @merchant.check_invoice_status? == false
      flash[:alert] = "Error: Cannot deactive coupons with invoices in progress"
    end
    @coupon.save
    redirect_to "/merchants/#{@merchant.id}/coupons/#{@coupon.id}"
  end
  
  private
  def coupon_params
    params.permit(:name, :discount, :code, :percent_dollar)
  end
end
