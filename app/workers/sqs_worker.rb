class SqsWorker
  include Shoryuken::Worker

  shoryuken_options queue: 'default', auto_delete: true, body_parser: :json

  def perform(message, body)
    Rails.logger.info "==== start SqsWorker"
    Rails.logger.info "==== message: #{message}"
    Rails.logger.info "==== body: #{body}"
    Rails.logger.info "==== end SqsWorker"
  end
end
