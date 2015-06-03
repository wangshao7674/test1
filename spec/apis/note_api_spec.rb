require 'rails_helper'

describe NoteAPI, type: :request do
  before :each do
    @user = User.create!(username: 'test',password: '123456')
    post '/api/sessions',username: @user.username,password: @user.password
    @token = JSON.parse(response.body)['token']
  end
  describe 'create note' do
    it 'should create note' do
      post '/api/user/notes',token: @token,title: 'title',content: 'content'
      response.status.should be == 200
      @user.notes.count.should be == 1
      JSON.parse(response.body)['note_id'].should be == @user.notes.first.id
    end
  end
  context 'with existing note' do
    before :each do
      @note = @user.notes.create!(title: 'title',content: 'content')
    end
    describe 'update note' do
      it 'should not update note if note does not exist' do
        put '/api/user/notes/9999',token: @token,title: 'new_title',content: 'new_content'
	response.status.should be == 404
      end
      it 'should update note' do
        put "/api/user/notes/#{@note.id}",token: @token, title: 'new_title',content: 'new_content'
	response.status.should be == 200
	@note.reload
	@note.title.should be == 'new_title'
	@note.content.should be == 'new_content'
      end
    end
    describe 'delete note' do
      it 'should delete note' do
        delete "/api/user/notes/#{@note.id}",token: @token
	response.status.should be == 200
	@user.notes.count.should be ==0
      end
    end
    describe 'get note' do
      it 'should get note' do
        get "/api/user/notes/#{@note.id}",token: @token
	response.status.should be == 200
	body = JSON.parse(response.body)
	body['title'].should be == @note.title
	body['content'].should be == @note.content
      end
    end
    describe 'list note' do
      it 'should list note' do
        get '/api/user/notes',token: @token
	response.status.should be == 200
	body = JSON.parse(response.body)
	body['notes'].size.should be == 1
	body['notes'][0]['title'].should be == @note.title
	body['notes'][0]['content'].should be == @note.content
      end
    end
  end
end
