class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def update_resource(resource, params)
    if params.key?("default_avatar") && params.keys.length == 1
      # For avatar-only updates, bypass password requirement
      resource.assign_attributes({ default_avatar: params["default_avatar"] })
      resource.save(validate: false)
    else
      # For all other updates, require password
      resource.update_with_password(params)
    end
  end
end
