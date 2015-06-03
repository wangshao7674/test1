module Entities
  class Note < Grape::Entity
    root 'notes'
    expose :id, documentation: {type: Integer, desc: 'id of a note'}
    expose :created_at,documentation: {type: String, desc: 'date when the note was created'}
    expose :title,documentation: {type: String, desc: 'title of the note'}
    expose :content, documentation: {type: String, desc: 'content of the note'}
  end
end
