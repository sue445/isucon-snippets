require "sidekiq"

require_relative "../config/sentry_methods"
# require_relative "../lib/isucon_helper"

class DummyWorker
  include Sidekiq::Worker
  include SentryMethods
  # include IsuconHelper

  sidekiq_options queue: "default"

  def perform(*args)
    with_sentry do
      # do something
    end
  end
end
