module Helpers

  def shrinkage(original, short)
    if [original, short].map {|obj| obj.respond_to? :length }.all?
      percent = 100.0 * (original.length - short.length) / original.length
      "#{ percent.round(2) }%"
    else
      "unknown"
    end
  end
  
end