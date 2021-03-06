# File reader
str_digits = []

File.open('q8input.txt', 'r') do |f|
  f.each_line do |line|
    line.chomp!
    str_digits << line.scan(/\w+/)
  end
end
# In this file, we will create two seperate methods

translator_hash = {}
segment_hash = {}
size5 = []
size6 = []

def hash_builder()
# Method 1: Decoder (to link each segment with a letter i.e. top = a / bottom = g)
str_digits.each do |str|
  str = str.chars.sort.join

  case str.size
  when 2
    translator_hash[1] = str
    segment_hash['complete-right'] = str
  when 3
    translator_hash[7] = str
  when 4
    translator_hash[4] = str
  when 7
    translator_hash[8] = str
  when 5
    size5 << str
  when 6
    size6 << str
  end
end

# Segment Step 1: Identify top segment
top = segment_hash['top'] = (translator_hash[7].split('') - translator_hash[1].split('')).join

four_plus_top_segment = (translator_hash[4] + top).chars.sort

# Translator Step 1: Create number 9 (number 4 + 'top')
size6.each do |digit|
  match = false
  four_plus_top_segment.each do |char|
    match = digit.include?(char)
    break if match == false
  end

  if match
    translator_hash[9] = digit

    # Segmenet Step 2: Identify bottom segment, AFTER identifying number 9
    segment_hash['bottom'] = (digit.chars - four_plus_top_segment)[0]
    size6.delete(digit)
    break
  end
end

# Segment Step 3: Identify bottom left segment, which is the only missing segment in number 9
segment_hash['bottom-left'] = (translator_hash[8].chars - translator_hash[9].chars).join

# Translator Step 2: Creating number 6 (only size 6 number without complete right segment)
size6.each do |digit|
  match = false
  missing_segment = ''

  segment_hash['complete-right'].chars.each do |char|
    match = digit.include?(char)
    if match == false
      missing_segment = char
      break
    end
  end

  if match == false
    translator_hash[6] = size6.delete(digit)

    # Segment Step 4 & 5: By identifying number 6, we can infer the top right segment by seeing which segment
    # is missing from the complete right segment, the other presemtn segment will be the bottom right segment
    segment_hash['top-right'] = missing_segment
    segment_hash['bottom-right'] = (segment_hash['complete-right'].chars - segment_hash['top-right'].chars).join
  end
end

# Translator Step 3: Last remaining size6 digit will be 0
translator_hash[0] = size6.delete_at(0)

# Segment Step 6: Missing segment from 0 is the middle segment
segment_hash['middle'] = (translator_hash[8].chars - translator_hash[0].chars).join

# Segment Step 7: Last missing segment from hash is the top left segment
segment_hash['top-left'] = (
  translator_hash[8].chars -
  (segment_hash['complete-right'] +
    segment_hash['top'] +
    segment_hash['bottom'] +
    segment_hash['middle'] +
    segment_hash['bottom-left'])
    .chars
).join

# Translator Step 4: Build out remaining numbers 2 / 3 / 5
translator_hash[2] = (translator_hash[8].chars - segment_hash['top-left'].chars - segment_hash['bottom-right'].chars).join
translator_hash[3] = (translator_hash[8].chars - segment_hash['top-left'].chars - segment_hash['bottom-left'].chars).join
translator_hash[5] = (translator_hash[8].chars - segment_hash['top-right'].chars - segment_hash['bottom-left'].chars).join

puts "Initial translator hash with 1 / 4 / 7 / 8: #{translator_hash}"
puts "Initial segment hash : #{segment_hash}"
puts "Size 5s: #{size5}"
puts "Size 6s: #{size6}"
