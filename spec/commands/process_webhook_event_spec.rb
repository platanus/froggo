require 'rails_helper'

describe ProcessWebhookEvent do
  def perform(*_args)
    described_class.for(*_args)
  end

  pending "describe what perform does here"
end