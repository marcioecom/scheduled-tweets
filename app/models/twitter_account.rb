# frozen_string_literal: true

class TwitterAccount < ApplicationRecord
  has_many :tweets, dependent: :destroy
  belongs_to :user

  validates :username, uniqueness: true

  def client
    X::Client.new(
      api_key: Rails.application.credentials.dig(:twitter, :api_key),
      api_key_secret: Rails.application.credentials.dig(:twitter, :api_secret),
      access_token: token,
      access_token_secret: secret
    )
  end
end
