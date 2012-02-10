
class NumberMap
  attr_reader :roman, :arabic

  def initialize(roman, arabic)
    @roman = roman
    @arabic = arabic
  end
end

class RomanToArabic
  TranslationTable = [
    NumberMap.new("IV", 4),
    NumberMap.new("I", 1),
    NumberMap.new("V", 5),
    NumberMap.new("IX", 9)
  ]
  def self.convert roman
    arabic = 0
    roman_remainder = roman
    remainder_size = roman_remainder.size
    while roman_remainder.size > 0 do
      TranslationTable.each do |map|
        if roman_remainder.match /#{map.roman}$/
          arabic += map.arabic
          roman_remainder.gsub!(/#{map.roman}$/, "")
        end
      end
      raise "Illegal Roman Character" if roman_remainder.size == remainder_size
      remainder_size = roman_remainder.size
    end
    arabic
  end
  def convert roman
    RomanToArabic.convert roman
  end
end

RSpec::Matchers.define :convert do |numeral|
  match do |converter|
    converter.convert(numeral) == @arabic
  end
  chain :to do |arabic|
    @arabic = arabic
  end

  description do
    "convert #{numeral} to #{@arabic}"
  end
end
describe RomanToArabic do
  it "fails for illegal roman characters" do
    lambda{ RomanToArabic.convert("P") }.should raise_error("Illegal Roman Character")
  end
  it { should convert("I").to(1)}
  it { should convert("II").to(2)}
  it { should convert("IV").to(4)}
  it { should convert("V").to(5)}
  it { should convert("VI").to(6)}
  it { should convert("VII").to(7) }
  it { should convert("VIII").to(8) }
  it { should convert("IX").to(9)}
end


