module Helpers

  def shrinkage(original, short)
    if [original, short].map {|obj| obj.respond_to? :length }.all?
      percent = 100.0 * (original.length - short.length) / original.length
      "#{ percent.round(2) }%"
    else
      "unknown"
    end
  end

  def format_date date
    date.strftime("%b %-d, %Y @ %-l:%M%P")
  end

  # move to model validations
  def validate_smurl_params params
    errors = []

    url = params[:url]
    errors << "Url cannot be empty" if url.nil? || url.gsub(/[[:space:]]/, '').empty?

    vanity = params[:vanity]

    if vanity && /[^a-zA-Z0-9]/.match(vanity)
      errors << "Custom url can only contain a-z, A-Z, and 0-9"
    end

    errors
  end
  
end