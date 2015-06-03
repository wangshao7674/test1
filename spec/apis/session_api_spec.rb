require 'rails_helper'
 
describe SessionAPI, type: :request do
  before :each do
    @user = User.create!(username: 'test',password: '123456')
  end
  it 'should create session' do
    post '/api/sessions', username: @user.username, password: @user.password
    response.status.should be == 200
    token = JSON.parse(response.body)['token']
    payload, _ =JWT.decode(token, 'key')
    payload['user_id'].should be == @user.id
  end
  it 'should not create session if wrong password is given' do
    post '/api/sessions',username: @user.username,password: 'wrong one'
    response.status.should be == 200
    body = JSON.parse(response.body)
    body['error'].should_not be_nil
    body['token'].should be_nil
  end
end
