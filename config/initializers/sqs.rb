sqs_client = Aws::SQS::Client.new(
  endpoint: 'http://localhost:4568',
  secret_access_key: 'secret access key',
  access_key_id: 'access key id',
  region: 'region'
)
sqs_client.create_queue(queue_name: 'default')
