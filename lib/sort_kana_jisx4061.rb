# frozen_string_literal: true

require "sort_kana_jisx4061/version"

module SortKanaJisx4061         # :nodoc:
  # JIS X 4061 character classes
  CC_SPACE = 1
  CC_PUNCTUATION = 2
  CC_PAREN = 3
  CC_OPRATOR = 4                # unused
  CC_SYMBOL = 5
  CC_UNIT = 6                   # unused
  CC_NUMBER = 7
  CC_GREEK = 8                  # unused
  CC_LATIN = 9
  CC_KANA = 10
  CC_KANJI = 11                 # unused
  CC_GETA = 12                  # unused

  class << self
    def process_yomi(str)
      r = []
      str.each_char do |c|
        c = c.downcase
        c = c.tr('ぁ-ん', 'ァ-ン') # Hiragana -> Katakana
        c = base_char(c)
        if c == 'ー'
          c = process_onbiki(c, r.last[1])
        end
        r << [jisx4061_charclass(c), c]
      end
      r
    end

    # for test
    def compare(str1, str2)
      process_yomi(str1) <=> process_yomi(str2)
    end

    private

    def jisx4061_charclass(c)
      case c
      when /[[:space:]]/ then CC_SPACE
      when %r{[?？、。,.，．・…‥:;：；/／-]} then CC_PUNCTUATION
      when /[(){}\[\]（）［ｌ］“”「」『』{}｛｝【】"']/ then CC_PAREN
      when /\d/ then CC_NUMBER
      when /[[:alpha:]]/ then CC_LATIN
      when /\p{KataKana}/ then CC_KANA
      else CC_SYMBOL
      end
    end

    def base_char(c)
      c.tr('ァィゥェォガギグゲゴザジズゼゾダヂヅデドバビブベボパピプペポャュョッヮ',
           'アイウエオカキクケコサシスセソタチツテトハヒフヘホハヒフヘホヤユヨツワ' )
    end

    def process_onbiki(c, pre)
      case pre
      when /[アカサタナハマヤラワ]/ then 'ア'
      when /[イキシチニヒミリ]/ then 'イ'
      when /[ウクスツヌフムユル]/ then 'ウ'
      when /[エケセテネヘメレ]/ then 'エ'
      when /[オコソトノホモヨロヲ]/ then 'オ'
      when 'ン' then 'ン'
      else c
      end
    end
  end
end

# sort Japanese Kana strings by JIS X 4061 order
#
# == Usage
#  require 'sort_kana_jisx4061'
#
#  words = [
#    { original: '春', yomi: 'ハル' },
#    { original: '夏', yomi: 'ナツ' },
#    { original: '秋', yomi: 'アキ' },
#    { original: '冬', yomi: 'フユ' },
#  ]
#
#  words_sorted = sort_kana_jisx4061_by(words) {|x| x[:yomi] }
def sort_kana_jisx4061_by(enum)
  enum.sort_by {|x| SortKanaJisx4061::process_yomi(yield(x)) }
end
