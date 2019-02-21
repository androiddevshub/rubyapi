class User < ApplicationRecord
  #Validations
   validates_presence_of :name, :email, :contact, :password_digest
   validates :email, uniqueness: true
   validates :contact, uniqueness: true

   #encrypt password
   has_secure_password
end
