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
      r1 = []                   # without collation properties
      r2 = []                   # with collation properties
      str.each_char do |c1|
        c1 = c1.tr('ぁ-ん', 'ァ-ン') # Hiragana -> Katakana
        if c1 == 'ー'
          c1 = process_onbiki(c1, r1.last[1])
        end
        c2 = c1
        c1 = c1.downcase
        c2 = c2.swapcase  # WORKAROUND: downcase should be smaller than updase
        c1 = base_char(c1)
        ccls = jisx4061_charclass(c1)
        r1 << [ccls, c1]; r2 << [ccls, c2]
      end
      [r1, r2]
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

    BASE_CHAR_TBL = {
      'ァ' => 'ア', 'ィ' => 'イ', 'ゥ' => 'ウ', 'ェ' => 'エ', 'ォ' => 'オ',
      'ガ' => 'カ', 'ギ' => 'キ', 'グ' => 'ク', 'ゲ' => 'ケ', 'ゴ' => 'コ',
      'ザ' => 'サ', 'ジ' => 'シ', 'ズ' => 'ス', 'ゼ' => 'セ', 'ゾ' => 'ソ',
      'ダ' => 'タ', 'ヂ' => 'チ', 'ヅ' => 'ツ', 'デ' => 'テ', 'ド' => 'ト',
      'バ' => 'ハ', 'ビ' => 'ヒ', 'ブ' => 'フ', 'ベ' => 'ヘ', 'ボ' => 'ホ',
      'パ' => 'ハ', 'ピ' => 'ヒ', 'プ' => 'フ', 'ペ' => 'ヘ', 'ポ' => 'ホ',
      'ャ' => 'ヤ', 'ュ' => 'ユ', 'ョ' => 'ヨ', 'ッ' => 'ツ', 'ヮ' => 'ワ',
    }

    def base_char(c)
      BASE_CHAR_TBL[c] || c
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
