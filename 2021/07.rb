data = open("./07.txt").read.split(",").map(&:to_i)

def triangular(num) = num * (num + 1) / 2
def fuel1(crabs, pos) = crabs.map{(_1 - pos).abs}.sum
def fuel2(crabs, pos) = crabs.map{triangular (_1 - pos).abs}.sum

p fuel1(data, data.sort[data.count / 2])
p [*0..999].map{fuel2(data, _1)}.min