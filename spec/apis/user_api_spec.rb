require 'rails_helper'

describe UserAPI,type: :request do
  it 'should creat user' do
    post '/api/users',username: 'test',password: 'righ'
    response.status.should be ==200
    body = JSON.parse(response.body)
    body['success'].should be_truthy
    User.count.should be == 1
   end

   it 'should not create user if username is taken' do
     user = User.create!(username: 'test', password: '1234')
     post '/api/users',username: user.username,password: '5678'
     response.status.should be == 200
     body = JSON.parse(response.body)
     body['error'].should_not be_nil
     User.count.should be == 1
   end
   it 'should not create user if password is not given' do
     post '/api/users',username: 'test'
     response.status.should be == 400
     User.count.should be == 0
   end
   describe 'update user bio' do
     before :each do
       @user = User.create!(username: 'test', password: '123456') 
     end
     it 'should not update user if token is invalid' do
       put '/api/user', user_bio: 'testbio',token: 'invalid one'
       response.status.should be == 401
       @user.reload
       @user.user_bio.should be_nil
     end
     it 'should update user bio' do
       post '/api/sessions',username: @user.username, password: @user.password
       expect(response.status).to eq 200
       body = JSON.parse(response.body)
       expect(body['error']).to be_nil
       token = body['token']
       put '/api/user', token: token, :user_bio => 'testbio'
       response.status.should be == 200
       JSON.parse(response.body)['success'].should be_truthy
       @user.reload
       @user.user_bio.should be == 'testbio'
     end
   end
end
