# frozen_string_literal: true

class TweetJob < ApplicationJob
  queue_as :default

  def perform(tweet)
    return if tweet.published?

    # Reschedule a tweet to the future
    return if tweet.published_at > Time.current

    tweet.publish_to_twitter!
  end
end
