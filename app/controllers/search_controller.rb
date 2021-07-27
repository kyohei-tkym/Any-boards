class SearchController < ApplicationController
  def search
    @model = params["search"]["model"]
    @value = params["search"]["value"]
    @datas = search_for(@model, @value)
  end

  private

  def search_for(model, value)
    if model == 'user'
      User.where("name LIKE ?", "%#{value}%")
    elsif model == 'post'
      Post.where("title LIKE ?", "%#{value}%").page(params[:page]).reverse_order
    else
      Post.where(genre: value).page(params[:page]).reverse_order
    end
  end

end
