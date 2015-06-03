class SessionAPI < Grape::API

  resources :sessions do
    params do
      requires :username, type: String
      requires :password, type: String
    end	
    post do				
      status 200
      user = User.where(username: params[:username]).first
      if user && user.authenticate(params[:password])
         {token: JWT.encode({user_id: user.id}, 'key')}
      else
         {error: 'wrong username or password'}
      end
    end
   end
  end
