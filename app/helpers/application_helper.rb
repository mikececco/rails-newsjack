module ApplicationHelper
  def flash_icon(type)
    case type
    when "success"
      "🎉"
    when "warning"
      "🤔"
    when "danger"
      "😱"
    else
      ""
    end
  end
end
