require 'radix'
BASE = ('0'..'9').to_a + ('a'..'z').to_a + ('A'..'Z').to_a

module Helpers
  def shrinkage(original, short)
    if [original, short].map {|obj| obj.respond_to? :length }.all?
      percent = 100.0 * short.length / original.length
      "#{ percent.round(2) }%"
    else
      "unknown"
    end
  end

  # encodes integers into base 62 strings
  def encode62 integer
    integer.b(BASE.length).to_a.map { |i| BASE[i] }.join
  end

  # decodes base 62 strings into integers
  def decode62 string
    string.split('').map { |c| BASE.index(c) }.b(BASE.length).to_s(10).to_i
  end
end