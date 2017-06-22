# Как и в любом тесте, подключаем помощник rspec-rails
require 'rails_helper'

# Начинаем описывать функционал, связанный с созданием игры
RSpec.feature 'USER creates a game', type: :feature do
  let(:user) { FactoryGirl.create :user, name: 'Николай' }

  let!(:questions) do
    (0..14).to_a.map do |i|
      FactoryGirl.create(
        :question,
        level: i,
        text: "Когда была куликовская битва номер #{i}?",
        answer1: '1380', answer2: '1381', answer3: '1382', answer4: '1383'
      )
    end
  end

  let!(:users) do
    (1..3).to_a.map do |i|
      FactoryGirl.create(
                     :user,
                     balance: i * 1000,
                     name: "Объект#{i}"
      )
    end
  end

  # Перед началом любого сценария нам надо авторизовать пользователя
  before(:each) do
    login_as user
  end

  # Сценарий успешного создания игры
  scenario 'successfully' do
    # Заходим на главную
    visit '/'

    # Кликаем по ссылке "Новая игра"
    click_link 'Новая игра'

    # Ожидаем, что попадем на нужный url
    expect(page).to have_current_path '/games/1'

    expect(page).to have_content 'Когда была куликовская битва номер 0?'

    expect(page).to have_content '1380'
    expect(page).to have_content '1381'
    expect(page).to have_content '1382'
    expect(page).to have_content '1383'
  end

  scenario 'user looks at rating' do
    visit '/'

    expect(page).to have_content 'Объект3'
    expect(page).to have_content 'Объект2'
    expect(page).to have_content 'Объект1'
    expect(page).to have_content 'Николай'

    save_and_open_page
  end
end
