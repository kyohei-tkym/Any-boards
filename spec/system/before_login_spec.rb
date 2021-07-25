# frozen_string_literal: true

require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'log inリンクが表示される: 左上から3番目のリンクが「log in」である' do
        log_in_link = find_all('a')[3].native.inner_text
        expect(log_in_link).to match(/log in/i)
      end
      it 'Log inリンクの内容が正しい' do
        log_in_link = find_all('a')[3].native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
      it 'sign upリンクが表示される: 左上から4番目のリンクが「sign up」である' do
        sign_up_link = find_all('a')[5].native.inner_text
        expect(sign_up_link).to match(/sign up/i)
      end
      it 'sign upリンクの内容が正しい' do
        sign_up_link = find_all('a')[5].native.inner_text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'タイトルが表示される' do
        expect(page).to have_content 'Any boards'
      end
			it 'log inリンクが表示される: 左上から3番目のリンクが「log in」である' do
        login_link = find_all('a')[3].native.inner_text
        expect(login_link).to match(/log in/i)
      end
      it 'sign upリンクが表示される: 左上から5番目のリンクが「sign up」である' do
        signup_link = find_all('a')[5].native.inner_text
        expect(signup_link).to match(/sign up/i)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

			it 'log inを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[3].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link
        is_expected.to eq '/users/sign_in'
      end
      it 'sign upを押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[5].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link
        is_expected.to eq '/users/sign_up'
      end

    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「Sign up」と表示される' do
        expect(page).to have_content 'sign up'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'genderフォームが表示される' do
        expect(page).to have_field 'user[gender]'
      end
      it 'profile_imageフォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it 'tall_weightフォームが表示される' do
        expect(page).to have_field 'user[tall_weight]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '登録ボタンが表示される' do
        expect(page).to have_button '登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[tall_weight]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、トップページになっている' do
        click_button '登録'
        expect(current_path).to eq '/'
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、トップページになっている' do
        expect(current_path).to eq '/users/sign_in'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示を確認' do
      it 'タイトルが表示される' do
        expect(page).to have_content 'Any boards'
      end
      it 'my pageリンクが表示される: 左上から3番目のリンクが「my page」である' do
        users_link = find_all('a')[3].native.inner_text
        expect(users_link).to match(/my page/i)
      end
      it 'Postsリンクが表示される: 左上から5番目のリンクが「boards」である' do
        books_link = find_all('a')[5].native.inner_text
        expect(books_link).to match(/boards/i)
      end
      it 'log outリンクが表示される: 左上から7番目のリンクが「log out」である' do
        logout_link = find_all('a')[7].native.inner_text
        expect(logout_link).to match(/log out/i)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.name
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[3].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている' do
        expect(page).to have_link ''
      end
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end
end