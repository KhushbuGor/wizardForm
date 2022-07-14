class WizardsController < ApplicationController
    before_action :load_user_wizard, except: %i(validate_step)
  
    def validate_step
      current_step = params[:current_step]
      prev = params[:prev_step]
      print("prev step is: ")
      print(prev)
      if prev == "step1"
        prev = Wizard::User::STEPS.first
      elsif prev == "step2"
        prev = Wizard::User::STEPS.second
      else
        prev = Wizard::User::STEPS.third
      end

      @user_wizard = wizard_user_for_step(current_step)
     
      if params[:user_wizard].present?
        @user_wizard.user.attributes = user_wizard_params || {}
        session[:user_attributes] = @user_wizard.user.attributes
    
        if @user_wizard.valid?
          
          next_step = wizard_user_next_step(current_step)
          create and return unless next_step
          redirect_to action: next_step
        else
          render current_step
        end
      else
        redirect_to({ action: prev }, alert: 'Fill Empty Data first')
      end
    end

    def create
  
      if @user_wizard.user.save
        session[:user_attributes] = nil
        redirect_to root_path, notice: 'User succesfully created!'
      else
        redirect_to({ action: Wizard::User::STEPS.first }, alert: 'There were a problem when creating the user.')
      end
    end
    def show
      @user = current_user
      render_wizard
    end
  
    def update 
      @user = current_user
      @user.update_attributes(params[:user])
      render_wizard @user
    end
    private
  
    def load_user_wizard
      @user_wizard = wizard_user_for_step(action_name)
    end
  
    def wizard_user_next_step(step)
      Wizard::User::STEPS[Wizard::User::STEPS.index(step) + 1]
    end
  
    def wizard_user_for_step(step)
      raise InvalidStep unless step.in?(Wizard::User::STEPS)
  
      "Wizard::User::#{step.camelize}".constantize.new(session[:user_attributes])
    end
    
    
    def user_wizard_params
      params.permit(:current_step)
      params.require(:user_wizard).permit(:email, :first_name, :last_name, :address_1, :address_2, :zip_code, :city, :phone_number)
    end
  
    class InvalidStep < StandardError; end
  end