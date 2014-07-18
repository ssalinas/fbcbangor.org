class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, only: []
  before_filter :authenticate_user!

  def new
    @users = User.all.where('email <> ?' , current_user.email)
    build_resource({})
    respond_with self.resource
  end

  def create
    build_resource(sign_up_params)
    if resource.save
      redirect_to new_user_registration_path, notice: 'User added successfully'
    else
      clean_up_passwords(resource)
      redirect_to new_user_registration_path, alert: 'Passwords must match! User not saved!'
    end
  end

  def destroy
    User.destroy(params[:id])
    redirect_to new_user_registration_path, notice: 'User successfully deleted'
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
        :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: admin_home_path
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
end
