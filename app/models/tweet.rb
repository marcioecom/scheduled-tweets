# frozen_string_literal: true

class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :twitter_account

  validates :body, length: { minimum: 1, maximum: 280 }
  validates :published_at, presence: true

  after_initialize do
    self.published_at ||= 24.hours.from_now
  end

  after_save_commit do
    TweetJob.set(wait_until: published_at).perform_later(self) if published_at_previously_changed?
  end

  def published?
    tweet_id?
  end

  def publish_to_twitter!
    tweet = twitter_account.client.post('tweets', "{\"text\": \"#{body}\"}")
    update(tweet_id: tweet['data']['id'])
  end
end
