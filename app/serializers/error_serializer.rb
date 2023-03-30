class ErrorSerializer
  def initialize(error)
    @error = error
  end

  def serialized_error
    {
      "message": "your query could not be completed",
      "errors": @error.message
    }
  end
end