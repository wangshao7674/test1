class MyNoteAPI < Grape::API
  format :json
  helpers do
  def authenticate_user!
     begin
       payload, _ = JWT.decode(params[:token],'key')
       @current_user = User.find(payload['user_id'])#User.where(username: payload['user_id']).first
     rescue StandardError
     end
     error!({error: 'unauthorized access'}, 401) if @current_user.nil?
    end

    def current_user
      @current_user
    end
  end
  mount UserAPI
  mount SessionAPI
  mount NoteAPI
  add_swagger_documentation base_path:'api', hide_format: true
end
