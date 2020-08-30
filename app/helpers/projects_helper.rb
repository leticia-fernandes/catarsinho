module ProjectsHelper
  def display_project_actions?(project:)
    current_user.projects.include?(project) if user_signed_in?
  end

  def display_edit_project_action(id:)
    link_to fa_icon("pencil"), edit_project_path(id), title: "Editar", data: {toggle: "tooltip"}
  end

  def display_delete_project_action(id:)
    link_to fa_icon("trash"), project_path(id) , method: :delete, data: {confirm: "Você tem certeza disso?", toggle: "tooltip"}, title: "Excluir"
  end

  def display_days_remaining(closing_date:)
    days = calc_days_remaining(closing_date)
    days_remaining_msg =
      case
      when days < 0
        "<span class='text-muted'>Esta campanha está encerrada.</span>"
      when days == 0
        "Esta campanha encerra <span class='days'>hoje</span>"
      when days == 1
        "Falta <span class='days'>#{days}</span> dia para o encerramento desta campanha."
      when days > 1
        "Faltam <span class='days'>#{days}</span> dias para o encerramento desta campanha."
      end
      .html_safe
  end

  def calc_days_remaining(closing_date)
    (closing_date - Date.today).to_i
  end

  def convert_money(value)
    number_to_currency(value, precision: 2, unit: "R$ ", separator: ",", delimiter: "")
  end

  def display_donation_button(project:)
    if project.is_open?
      content_tag :a, href: new_project_donation_path(project_id: project.id) do
        content_tag(:button, "Apoie!", class: "btn btn-lg btn-catarsinho-yellow w-100", disabled: false )
      end
    else
      content_tag(:button, "Encerrado", class: "btn btn-lg btn-secondary w-100", disabled: true )
    end
  end

  def display_donators(project:)
    if project.donators.empty?
      if project.is_open?
        content_tag :a, href: new_project_donation_path(project_id: project.id) do
          content_tag(:button, "Seja um apoiador!", class: "btn btn-catarsinho")
        end
      else
        content_tag(:p, "Nenhum apoiador.", class: "text-muted")
      end
    else
      content_tag(:p, project.donators.uniq.map(&:name).join(", "), class: "donators")
    end
  end

  def display_order
    render partial: 'order'
  end

  def display_image_preview(project:)
    image_tag(project.image.variant(resize: "150")) if project.image.attached?
  end

  def display_image(project:, class_img: "w-100")
    image_tag(project.image, class: class_img) if project.image.attached?
  end
end
