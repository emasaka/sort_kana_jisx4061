lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sort_kana_jisx4061/version"

Gem::Specification.new do |spec|
  spec.name          = "sort_kana_jisx4061"
  spec.version       = SortKanaJisx4061::VERSION
  spec.license       = 'MIT'
  spec.authors       = ["emasaka (Masakazu Takahashi)"]
  spec.email         = ["emasaka@gmail.com"]

  spec.summary       = %q{sort Japanese Kana strings by JIS X 4061 order}
  spec.description   = %q{sort Japanese Kana strings by JIS X 4061 order in Ruby}
  spec.homepage      = "https://github.com/emasaka/sort_kana_jisx4061"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
