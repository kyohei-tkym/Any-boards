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
      Post.where("title LIKE ?", "%#{value}%")
    else
      Post.where(genre: value)
    end
  end

end
