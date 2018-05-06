# SortKanaJisx4061

Sort Japanese Kana strings by JIS X 4061 (日本語文字列照合順番) order in Ruby.

## Usage

```
require 'sort_kana_jisx4061'

words = [
  { original: '春', yomi: 'ハル' },
  { original: '夏', yomi: 'ナツ' },
  { original: '秋', yomi: 'アキ' },
  { original: '冬', yomi: 'フユ' },
]

words_sorted = sort_kana_jisx4061_by(words) {|x| x[:yomi] }
# => [{:original=>"秋", :yomi=>"アキ"}, {:original=>"夏", :yomi=>"ナツ"}, {:original=>"春", :yomi=>"ハル"}, {:original=>"冬", :yomi=>"フユ"}]
```

## Note

* Sorting Kanji is not supported
* Hiragana is converted to Katakana internally

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/emasaka/sort_kana_jisx4061 .
