module Admin
    class CapFiguresController < ApplicationController
      before_action :admin_only
      # before_action :set_cap_figures
  
      def index
        @cap_figures = CapFigure.all
        render json: @cap_figures
      end

      def show
        @cap_figures = CapFigure.all
        @cap_figures
      end

      def create
        @cap_figures = CapFigure.new(cap_params)
        @cap_figures.year = @cap_figures.year.strip
        @cap_figures.salary_cap = @cap_figures.salary_cap.strip.to_int
        @cap_figures.luxury_tax = @cap_figures.luxury_tax.strip.to_int
        @cap_figures.apron = @cap_figures.apron.strip.to_int
        @cap_figures.second_apron = @cap_figures.second_apron.strip.to_int
        @cap_figures.min_payroll = @cap_figures.min_payroll.strip.to_int
        @cap_figures.cap_hold = @cap_figures.cap_hold.strip.to_int
        @cap_figures.nontaxpayermle = @cap_figures.nontaxpayermle.strip.to_int
        @cap_figures.roommle = @cap_figures.roommle.strip.to_int
        @cap_figures.taxpayermle = @cap_figures.taxpayermle.strip.to_int
        @cap_figures.bae = @cap_figures.bae.strip.to_int

  
        respond_to do |format|
          if @cap_figures.save
            format.json { render json: { status: 'success', cap_figures: @cap_figures }, status: :created }
            format.html { redirect_to @cap_figures }
          else
            format.json { render json: { status: 'error', errors: @cap_figures.errors }, status: :unprocessable_entity }
            format.html { render :new, status: :unprocessable_entity }
          end
        end
      end

      def edit
        @cap_figures = CapFigure.find(params[:id])
      end

      def update
        @cap_figures = CapFigure.find(params[:id])
        respond_to do |format|
          if @cap_figures.update(cap_params)
            format.json { render json: { status: 'success', cap_figure: @cap_figures }, status: :ok } 
            format.html { redirect_to @cap_figures }
          else
            format.json { render json: { status: 'error', errors: @cap_figures.errors }, status: :unprocessable_entity }
            format.html { render :edit, status: :unprocessable_entity }
          end
        end
      end


      private

      def set_cap_figures
        @cap_figures = CapFigure.find_by(params[:year])
      end

      def cap_params
        params.require(:cap_figure).permit(:salary_cap, :luxury_tax, :apron, :second_apron, :min_payroll, :cap_hold, :year,
                                           :nontaxpayermle, :roommle, :bae, :taxpayermle)
      end
    end
  end