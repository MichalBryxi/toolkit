class PagesController < ApplicationController
  def show
    template_name = "pages/" + File.basename(params[:page].to_s)
    if template_exists? template_name
      render template: template_name
    else
      render status: :not_found, text: "Page not found"
    end
  end
end
