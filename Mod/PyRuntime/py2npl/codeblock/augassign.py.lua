local a = 1
assert((a == 1))
a = (a + 2)
assert((a == 3))
a = (a - 4)
assert((a == (-1)))
a = (a * 5)
assert((a == (-5)))
a = (a / (-2))
assert((a == 2.5))
local b = 2
assert((b == 2))
b = (math.pow(b, 10))
assert((b == 1024))
b = (mod_operator(b, 3))
assert((b == 1))