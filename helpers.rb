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
  
end