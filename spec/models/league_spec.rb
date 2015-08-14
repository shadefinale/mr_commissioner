require 'rails_helper'

RSpec.describe League, type: :model do
  let(:league){create(:league)}
  let(:team){create(:team)}

  context "associations"

    it "should respond to teams association" do
      expect(league).to respond_to(:teams)
    end
end

