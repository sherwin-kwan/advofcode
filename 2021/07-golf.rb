d=$<.read.split(",").map(&:to_i)
p d.sum{(d.sort[d.count/2]-_1).abs}
p [*0..999].map{|a|d.sum{(f=_1-a)*(f+1)/2.abs}}.min