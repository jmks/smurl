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
  def validate_smurl_params params, blacklisted=[]
    errors = []

    url = params[:url]
    errors << "Url cannot be empty" if url.nil? || url.gsub(/[[:space:]]/, '').empty?

    vanity = params[:vanity]

    if vanity
      # illegal characters
      if /[^a-zA-Z0-9]/.match(vanity)
        errors << "Custom url can only contain a-z, A-Z, and 0-9"
      end

      # blacklisted value
      if blacklisted and blacklisted.include?(vanity)
        errors << "That custom url cannot be used at this time"
      end
    end

    errors
  end

  def blacklisted_urls settings
    if settings.smurl_blacklist
      File.readlines(settings.smurl_blacklist).map(&:chomp).map(&:strip)
    else
      []
    end + settings.unusable_custom_urls
  end
end