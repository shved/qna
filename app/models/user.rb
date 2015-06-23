class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :answers
  has_many :questions
  has_many :authorizations

  def self.find_for_oauth(auth)
  	authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
  	return authorization.user if authorization

    return nil unless auth.info.try(:email)

    email = auth.info[:email]
    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
    user
  end

  def owner_of?(resource)
    resource.user_id == id
  end
end
