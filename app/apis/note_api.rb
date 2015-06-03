class NoteAPI < Grape::API
  include Grape::Kaminari
  resource :user do
    params do
      requires :token,type: String, desc: 'access token of current user'
    end
    resources :notes do
      before do
        authenticate_user!
      end
      params do
        requires :title,type: String
	requires :content,type: String
      end
      post do
        status 200
	note = current_user.notes.build(title: params[:title],content: params[:content])
	if note.save
	  {note_id: note.id}
	else
	{error: note.errors.full_messages}
	end
      end
      paginate per_page: 3, offset: false
      get do
        present paginate(current_user.notes), with: Entities::Note
      end
      params do
        requires :id, type: Integer, desc: 'id of the note'
      end
      group ':id' do
        helpers do
	  def set_note!
	    @current_note = current_user.notes.where(id: params[:id]).first
	    error!({error: 'not found'},404) if @current_note.nil?
	  end
	  def current_note
	    @current_note
	  end
	end
	before do
	  set_note!
	end
	params do
	  requires :title,type: String
	  requires :content,type: String
	end
	put do
   	  if current_note.update(title: params[:title],content: params[:content])
	    {success: true}
	  else
	    {error: current_note.error.full_messages}  
          end
        end
        delete do
          if current_note.destroy
	    {success: true}
	  else
	    {error: current_note.errors.full_messages}
	  end
        end
	desc 'get detail of a note' do
	  success Entities::Note
	  failure [[401,'unauthorized access'],[404,'note not found']]
	end
        get do
          present current_note, with: Entities::Note
        end
      end
    end
  end
end
#jiayihangzhushi
