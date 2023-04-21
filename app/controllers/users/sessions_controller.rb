class Users::SessionsController < Devise::SessionsController
  include Recaptcha
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  private

    def check_captcha
      return if verify_recaptcha(params[:'cf-turnstile-response'])

      self.resource = resource_class.new sign_in_params

      respond_with_navigational(resource) do
        flash.discard(:recaptcha_error) # We need to discard flash to avoid showing it on the next page reload
        render :new
      end
    end
end
