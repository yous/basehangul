# encoding: utf-8

require 'basehangul/version'
require 'basehangul/utils'

# Binary encoder using hangul.
module BaseHangul
  # Character for padding on encoding.
  PADDING = '흐'.freeze
  private_constant :PADDING
end
