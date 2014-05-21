class Error
  
  def self.create(code, message='There was an error!', status=:internal_server_error)
    { json: Error.message(code, message), status: status }
  end

  def self.message(code, message)
    { status: code, error: message }
  end

  def self.unauthorized(message="You are not authorized!")
    { json: Error.message(401, message), status: :unauthorized }
  end

  def self.forbidden(message="You can't do it!")
    { json: Error.message(403, message), status: :forbidden }
  end

  def self.not_found(message='Not found!')
    { json: Error.message(404, message), status: :not_found }
  end

  def self.missed_param(param)
    Error.create 1001, "Parameter '#{param}' is missed!", :bad_request
  end

  def self.duplicate
    Error.create 1002, "Already exist!", :conflict
  end

  def self.failed(message='There was an error!')
    unless message.class == String
      message = message.full_messages[0]
    end
    Error.create 1003, message, :bad_request
  end

end
