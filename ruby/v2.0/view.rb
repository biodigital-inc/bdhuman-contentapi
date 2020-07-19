class View
  def initialize(page, data = {})
    @data = data
    @page = page
    file = File.join(File.dirname(__FILE__), "./templates/#{page}.html.erb")
    @template = File.read(file)
  end

  def access_token
    @data[:access_token]
  end
  def token_type
    @data[:token_type]
  end
  def expires_in
    @data[:expires_in]
  end
  def token_expiry
    @data[:token_expiry]
  end
  def timestamp
    @data[:timestamp]
  end


  def endpoint_path
    @data[:endpoint_path]
  end
  def results
    @data[:results]
  end
  def results_obj
    @data[:results_obj]
  end

  def collection_id
    @data[:collection_id]
  end


  def render
    ERB.new(@template).result(binding)
  end
end