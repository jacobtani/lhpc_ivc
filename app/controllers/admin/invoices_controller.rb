class Admin::InvoicesController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_member
  before_action :set_invoice, only: %i[ show edit update destroy ]

  def index
    @invoices = @member.invoices
  end

  def new
    @invoice = @member.invoices.new
  end

  def create
    @invoice = @member.invoices.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to admin_member_invoices_url(@member), notice: "Member was successfully created." }
        format.json { render json: @invoice.to_json, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end
   
  def edit
  end

  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to admin_member_invoices_url(@member), notice: "Invoice was successfully updated." }
        format.json { render json: @invoice.to_json, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to admin_member_invoices_url(@member), notice: "Invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def term_invoicing
    CreateMembersTermInvoicesCommand.new(term_number: params[:term_number], year: params[:year]).call
  end

  private

  def set_member
    @member = Member.find(params[:member_id])
  end

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:id, :invoice_number, :invoice_date, :member_id, :due_date, :payment_date, :member_donation, :cleaning_donation, :payment_received).to_h
  end
end
