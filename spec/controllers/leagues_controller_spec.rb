require 'rails_helper'

RSpec.describe LeaguesController, type: :controller do
  context 'index of leagues access' do
    it 'should redirect to login path if no current user' do
      get :index, id: 1
      expect(response).to redirect_to(signin_path)
    end

    it 'should not redirect & assign leagues if current user' do
      new_user = create(:user)
      allow(controller).to receive(:current_user) { new_user }

      new_league = create(:league)
      new_user.leagues << new_league

      get :index
      expect(assigns(:leagues)).to match_array([new_league])
    end

    it 'should not assign a league to a user more than once' do
      new_user = create(:user)
      allow(controller).to receive(:current_user) { new_user }

      new_league = create(:league)
      new_user.leagues << new_league

      post :create, id: new_league.id

      get :index
      expect(assigns(:leagues)).to match_array([new_league])
    end
  end

  context '#create' do
    it 'should not create a league if it already has been scraped' do
      new_league = create(:league)
      expect do
        post :create, id: new_league.id
      end.to change(League, :count).by(0)
    end
  end
end

