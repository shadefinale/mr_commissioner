require 'rails_helper'

RSpec.describe LeaguesUsersController, type: :controller do
  it 'should remove the association without deleting the league' do
    new_user = create(:user)
    allow(controller).to receive(:current_user) { new_user }

    new_league = create(:league)
    new_user.leagues << new_league

    expect do
      delete :destroy, id: new_league.id
    end.to change(League, :count).by(0)
    expect(new_user.leagues).to match_array([])
  end

  it 'should not remove association if user is not logged in' do
    new_user = create(:user)

    new_league = create(:league)
    new_user.leagues << new_league

    expect do
      delete :destroy, id: new_league.id
    end.to change(League, :count).by(0)
    expect(new_user.leagues).to match_array([new_league])
  end

  it 'should not remove association if other user spoofs id' do
    new_user = create(:user)
    malicious_user = create(:user)

    allow(controller).to receive(:current_user) { malicious_user }

    new_league = create(:league)
    new_user.leagues << new_league

    expect do
      delete :destroy, id: new_league.id
    end.to change(League, :count).by(0)
    expect(new_user.leagues).to match_array([new_league])
  end
end
