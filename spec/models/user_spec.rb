require 'rails_helper'
describe User do
  it 'should validate password' do
    user = User.create!(username: 'test', password: 'right')
    expect(user.authenticate('right')).to be_truthy
    expect(user.authenticate('wrong')).to be false
  end
end
