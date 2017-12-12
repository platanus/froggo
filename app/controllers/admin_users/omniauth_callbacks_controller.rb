class AdminUsers::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = link_github(request.env["omniauth.auth"], current_admin_user)
    if user
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: :github
      session["devise.#github_data"] = request.env["omniauth.auth"]
      redirect_to admin_root_path
    end
  end

  private

  def link_github(auth, resource)
    info = {
      uid: auth.uid,
      token: auth.credentials.token
    }
    resource.update! info
    resource
  end
end
