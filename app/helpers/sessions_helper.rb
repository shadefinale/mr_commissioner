module SessionsHelper

  def sign_in_or_out
    if current_user
      link_to "Sign out", session_path, method: :delete, class: "logout"
    else
      link_to "Sign in", new_session_path, class: "logout"
    end
  end
end
