require 'uri'

class ValidationController < ApplicationController
  slimmer_template :csvlint

  def index
  end

  def redirect
    if !params["url"].blank? 
      redirect_to validate_path(url: params["url"], schema: params[:schema_url])
    elsif !params["file"].blank? 
      validate_csv(File.new(params[:file].tempfile))
      @file = File.new(params[:file].tempfile)
      respond_to do |wants|
        wants.html { render "validation/validate"  }
        wants.png { send_file File.join(Rails.root, 'app', 'views', 'validation', "#{@state}.png"), disposition: 'inline' }
        wants.svg { send_file File.join(Rails.root, 'app', 'views', 'validation', "#{@state}.svg"), disposition: 'inline' }
      end
    else
      redirect_to root_path and return 
    end
  end

  def validate
    # Check we have a URL
    @url = params[:url]
    redirect_to root_path and return if @url.nil? && @file.nil?
    # Check it's valid
    @url = begin
      URI.parse(@url)
    rescue URI::InvalidURIError
      redirect_to root_path and return
    end
    # Check scheme
    redirect_to root_path and return unless ['http', 'https'].include?(@url.scheme)
    validate_csv(@url.to_s, params[:schema])
    # Responses
    respond_to do |wants|
      wants.html
      wants.png { send_file File.join(Rails.root, 'app', 'views', 'validation', "#{@state}.png"), disposition: 'inline' }
      wants.svg { send_file File.join(Rails.root, 'app', 'views', 'validation', "#{@state}.svg"), disposition: 'inline' }
    end

  end
  
  private
  
    def validate_csv(io, schema)
      # Load schema if set
      if schema
        @schema = Csvlint::Schema.load_from_json_table(schema)
      end
      # Validate
      @validator = Csvlint::Validator.new( io, nil, @schema )
      @warnings = @validator.warnings
      @errors = @validator.errors
      @state = "valid"
      @state = "warnings" unless @warnings.empty?
      @state = "invalid" unless @errors.empty?
    end

end
