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
    if calc_days_remaining(project.closing_date) < 0
      content_tag(:button, "Encerrado", class: "btn btn-lg btn-secondary w-100", disabled: true )
    else
      disabled = current_user.projects.include?(project) if user_signed_in?
      content_tag(:button, "Apoie!", class: "btn btn-lg btn-catarsinho-yellow w-100", disabled: disabled )
    end
  end

  def display_donators(project:)
    content_tag(:button, "Seja um apoiador!", class: "btn btn-catarsinho")
  end

  def display_order
    render partial: 'order'
  end
end
