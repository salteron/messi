Result = Struct.new(:payload, :errors) do
  def success?
    !failure?
  end

  def failure?
    errors.present?
  end
end
