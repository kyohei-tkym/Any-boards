# frozen_string_literal: true

require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※Logoutはテスト済み。' do
      subject { current_path }

      it 'My pageを押すと、自分のユーザ詳細画面に遷移する' do
        Mypage_link = find_all('a')[2].native.inner_text
        Mypage_link = Mypage_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link Mypage_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it 'Boardsを押すと、post一覧画面に遷移する' do
        posts_link = find_all('a')[4].native.inner_text
        posts_link = posts_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link posts_link
        is_expected.to eq '/posts'
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '自分と他人のユーザーネームのリンク先が正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
        expect(page).to have_link other_post.user.name, href: user_path(other_post.user)
      end
      it '自分の投稿と他人の投稿画像のリンク先がそれぞれ正しい' do
        expect(page).to have_link '', href: post_path(post)
        expect(page).to have_link '', href: post_path(other_post)
      end
      it '自分の投稿と他人の投稿のタイトルが表示される' do
        expect(page).to have_content post.title
        expect(page).to have_content other_post.title
      end
      it '自分の投稿と他人の投稿のジャンルが表示される' do
        expect(page).to have_content post.genre
        expect(page).to have_content other_post.genre
      end
    end

    context '投稿成功のテスト' do
      before do
        visit new_post_path
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 10)
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 20)
        fill_in 'post[size]', with: Faker::Lorem.characters(number: 10)
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button 'POST' }.to change(user.post, :count).by(1)
      end
      it 'リダイレクト先が、保存できた投稿の一覧画面になっている' do
        click_button 'POST'
        expect(current_path).to eq '/posts'
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it 'ユーザネームのリンク先が正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
      end
      it '投稿の名前が表示される' do
        expect(page).to have_content post.title
      end
      it '投稿のボードの説明が表示される' do
        expect(page).to have_content post.body
      end
      it '投稿のボードのサイズが表示される' do
        expect(page).to have_content post.size
      end
       it 'ユーザーの身長・体重が表示される' do
        expect(page).to have_content post.user.tall_weight
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link 'Edit', href: edit_post_path(post)
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link 'Destroy', href: post_path(post)
      end
    end

    context '投稿成功のテスト' do
      before do
        visit new_post_path
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 9)
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 19)
        fill_in 'post[size]', with: Faker::Lorem.characters(number: 9)
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button 'POST' }.to change(user.post, :count).by(1)
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link 'Edit'
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link 'Destroy'
      end

      it '正しく削除される' do
        expect(Post.where(id: post.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/posts'
      end
    end
  end

  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_post_path(post)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
      it '「POST編集」と表示される' do
        expect(page).to have_content 'POST編集'
      end
      it 'ボードの名前編集フォームが表示される' do
        expect(page).to have_field 'post[title]', with: post.title
      end
      it 'ボードの説明編集フォームが表示される' do
        expect(page).to have_field 'post[body]', with: post.body
      end
      it '投稿のボードのサイズが表示される' do
        expect(page).to have_field 'post[size]', with: post.size
      end
      it 'POSTボタンが表示される' do
        expect(page).to have_button 'POST'
      end
    end

    context '編集成功のテスト' do
      before do
        @post_old_title = post.title
        @post_old_body = post.body
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 4)
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 19)
        click_button 'POST'
      end

      it 'titleが正しく更新される' do
        expect(post.reload.title).not_to eq @post_old_title
      end
      it 'bodyが正しく更新される' do
        expect(post.reload.body).not_to eq @post_old_body
      end
      it 'リダイレクト先が、投稿一覧になっている' do
        expect(current_path).to eq '/posts'
      end
    end
  end

  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '投稿一覧のユーザ画像のリンク先が正しい' do
        expect(page).to have_link '', href: post_path(post)
      end
      it '投稿一覧に自分の名前が表示され、リンクが正しい' do
        expect(page).to have_link post.user.name, href: user_path(user)
      end
      it '投稿一覧に自分の投稿のボードの名前が表示される' do
        expect(page).to have_content post.title
      end
      it '投稿一覧に自分の投稿のジャンルが表示される' do
        expect(page).to have_content post.genre
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_post.title
        expect(page).not_to have_content other_post.body
      end
      it '自分のプロフィールが表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
        expect(page).to have_content user.tall_weight
        expect(page).to have_content user.gender
      end

      it '自分のユーザ編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_user_path(user)
      end

    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it 'Update Userボタンが表示される' do
        expect(page).to have_button '変更を保存'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_intrpduction = user.introduction
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
        click_button '変更を保存'
      end

      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'introductionが正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_intrpduction
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
end