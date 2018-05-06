require "test_helper"

SKJX4 = SortKanaJisx4061        # alias for module

class SortKanaJisx4061Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SortKanaJisx4061::VERSION
  end

  def test_base_kana
    assert SKJX4::compare('アア', 'アア') == 0, '"アア" == "アア"'
    assert SKJX4::compare('アア', 'アイ') < 0, '"アア" < "アイ"'
    assert SKJX4::compare('イ', 'ア') > 0, '"イ" > "ア"'
    assert SKJX4::compare('ア', 'アア') < 0, '"ア" < "アア"'
  end

  def test_dakuten_and_litter
    assert SKJX4::compare('ハ', 'バ') == 0, '"ハ" == "バ"'
    assert SKJX4::compare('ハ', 'パ') == 0, '"ハ" == "パ"'
    assert SKJX4::compare('ア', 'ァ') == 0, '"ア" == "ァ"'
  end

  def test_onbiki
    assert SKJX4::compare('アー', 'アア') == 0, '"アー" == "アア"'
    assert SKJX4::compare('カー', 'カア') == 0, '"カー" == "カア"'
  end

  def test_charclass
    assert SKJX4::compare('アア', 'ア。') > 0, '"アア" > "ア…"'
    assert SKJX4::compare('アアア', 'ア1ア') > 0, '"アアア" > "ア1ア"'
    assert SKJX4::compare('ア1ア', 'ア。ア') > 0, '"ア1ア" > "ア。ア"'
    assert SKJX4::compare('アアア', 'アaア') > 0, '"アアア" > "アaア"'
    assert SKJX4::compare('アaア', 'ア1ア') > 0, '"アaア" > "ア1ア"'
  end
end
