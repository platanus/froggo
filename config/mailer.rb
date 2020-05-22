Rails.application.config.action_mailer.raise_delivery_errors = false
Rails.application.config.action_mailer.delivery_method = :aws_sdk

Rails.application.config.action_mailer.default_url_options = {
  host: ENV.fetch('APPLICATION_HOST'),
  protocol: 'https'
}

Rails.application.config.action_mailer.default_options = { from: ENV['DEFAULT_EMAIL_ADDRESS'] }
ASSET_HOST = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))
Rails.application.config.action_mailer.asset_host = ASSET_HOST

if ENV["EMAIL_RECIPIENTS"].present?
  Mail.register_interceptor RecipientInterceptor.new(
    ENV["EMAIL_RECIPIENTS"],
    subject_prefix: "[#{Rails.env}]"
  )
end
creds = Aws::Credentials.new(
  ENV['AWS_ACCESS_KEY_ID'],
  ENV['AWS_SECRET_ACCESS_KEY']
)

Aws::Rails.add_action_mailer_delivery_method(
  :aws_sdk, credentials: creds, region: ENV.fetch('AWS_REGION', 'us-east-1')
)
