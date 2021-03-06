class LibrariesController < ApplicationController
  def show
    @items = Library::ItemDecorator.decorate(Library::Item.by_most_recent.page(params[:page]))
  end

  def search
    items = Library::Item.find_with_index(params[:query])
    @items = Library::ItemDecorator.decorate(items)
    respond_to do |format|
      format.json { render json: @items }
    end
  end

  def recent
    items = Library::Item.by_most_recent.limit(params[:limit] || 5)
    items = Library::ItemDecorator.decorate(items)
    render json: items
  end
end
