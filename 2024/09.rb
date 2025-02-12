def print_full_file(diskmap)
  arr = []
  blocks_by_id = diskmap.chars.each_slice(2).map{_1[0].to_i}
  space_after_id = diskmap.chars.each_slice(2).map{_1[1].to_i}
  orig_last_id = blocks_by_id.length - 1
  last_id = orig_last_id
  (0..orig_last_id).each do |id|
    break if id > last_id
    blocks_by_id[id].times {arr << id}
    remaining_space = space_after_id[id]
    break if id == last_id
    loop do
      last_id_blocks = blocks_by_id[last_id] 
      if last_id_blocks < remaining_space
        last_id_blocks.times{ arr << last_id}
        last_id = last_id - 1
        remaining_space -= last_id_blocks
      elsif last_id_blocks == remaining_space
        remaining_space.times{ arr << last_id }
        last_id = last_id - 1 
        break
      else
        remaining_space.times{ arr << last_id }
        blocks_by_id[last_id] -= remaining_space
        break
      end
    end
  end
  return arr
end

whole_str = File.open("09.txt").read.gsub("\n", "")
p1 = print_full_file(whole_str).map.with_index{|val, pos| val * pos}.sum
puts "Part 1: #{p1}"