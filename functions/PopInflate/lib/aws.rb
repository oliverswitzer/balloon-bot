require 'aws-sdk-secretsmanager'
require 'yake/logger'

class Aws::SecretsManager::Client
  include Yake::Logger

  ##
  # Helper to export SecretsManager secret JSON to ENV
  def export(secret_id)
    params = { secret_id: secret_id }
    logger.info "SecretsManager:GetSecretValue #{params.to_json}"
    exports = JSON.parse get_secret_value(**params).secret_string

    ENV.update exports
  end
end
