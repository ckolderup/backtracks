module UsersHelper
  def user_form_submit_button_text
    if current_user
      "Update"
    else
      "Sign up"
    end
  end
end
