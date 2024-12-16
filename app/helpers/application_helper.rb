module ApplicationHelper
  def user_avatar(user, size: 80, css_class: "avatar")
    image_tag user.gravatar_url(size: size),
              class: css_class,
              alt: "#{user.email}'s avatar"
  end
end
