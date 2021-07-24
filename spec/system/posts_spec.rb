# frozen_string_literal: true

require 'rails_helper'

describe '投稿のテスト' do
  let!(:book) { create(:book,title:'hoge',body:'body') }
  describe 'トップ画面(root_path)のテスト' do
    before do 
      visit root_path
    end
    context '表示の確認' do
      it 'トップ画面(root_path)に一覧ページへのリンクが表示されているか' do
        expect(page).to have_link "", href: posts_path
      end
      it 'root_pathが"/"であるか' do
        expect(current_path).to eq('/')
      end
    end
  end
  describe "一覧画面のテスト" do
	    before do
	      visit posts_path
	    end
	    context '一覧の表示とリンクの確認' do
	      it "postの一覧が表示されているか" do
	        expect(page).to have_field 'post[title]'
	        expect(page).to have_field 'post[genre]'
	        expect(page).to have_field 'post.user[name]'
	        expect(page).to have_field 'post.post_images[image]'
	      end
	      it "postの画像とボード名とジャンルとユーザーネームを表示し、詳細が表示されているか" do
	          (1..5).each do |i|
	            Post.create(title:'hoge'+i.to_s,body:'body'+i.to_s,genre:'genre'+i.to_s,introduction:'hoge'+i.to_s)
	          end
	          visit posts_path
	          Post.all.each_with_index do |post,i|
	            j = i
	            expect(page).to have_content post.title
	            expect(page).to have_content post.genre
	            expect(page).to have_content post.user.name
	            expect(page).to have_field post.post_images.image
	            # Showリンク
	            show_link = find_all('a')[j]
	            expect(show_link.native.inner_text).to match(/show/i)
	            expect(show_link[:href]).to eq post_path(post)
	          end
49	    end