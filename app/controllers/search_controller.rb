class SearchController < ApplicationController
  def search
    @model = params["search"]["model"]
    @value = params["search"]["value"]
    @datas = search_for(@model, @value)
  end

  private

  def search_for(model, value)
    #-------------------ユーザー名部分一致検索----------------------
    if model == 'user'
      User.where("name LIKE ?", "%#{value}%")
    #-------------------投稿タイトル部分一致検索--------------------
    elsif model == 'post'
      Post.where("title LIKE ?", "%#{value}%").page(params[:page]).reverse_order
    #-------------------ジャンル完全一致検索------------------------
    else
      Post.where(genre: value).page(params[:page]).reverse_order
    end
  end

end
