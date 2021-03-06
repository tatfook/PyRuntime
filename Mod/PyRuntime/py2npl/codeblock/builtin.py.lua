assert((abs(10) == 10))
assert((abs(0) == 0))
assert((abs((-10)) == 10))
assert((abs(1.07) == 1.07))
assert((abs((-0.52)) == 0.52))
assert((all(list {_to_null()}) == true))
assert((all(list {_to_null(1, 2)}) == true))
assert((all(list {_to_null(0, 1, 2)}) == false))
assert((all(list {_to_null(0, 0)}) == false))
assert((any(list {_to_null()}) == false))
assert((any(list {_to_null(1, 2)}) == true))
assert((any(list {_to_null(0, 1, 2)}) == true))
assert((any(list {_to_null(0, 0)}) == false))
assert((bin(0) == "0b0"))
assert((bin(10) == "0b1010"))
assert((bin(100) == "0b1100100"))
assert((bin(1000) == "0b1111101000"))
assert(bool(true))
assert(bool(1))
assert(bool("abc"))
assert(bool(list {_to_null(1, 2)}))
assert(not bool(false))
assert(not bool(list {_to_null()}))
assert(not bool(""))
assert(not bool(0))
assert(callable(abs))
assert(callable(function(x) return x end))
assert(not callable(0))
assert(not callable("abc"))
assert(not callable(list {_to_null()}))
local d = dict()
assert((len(d) == 0))
d[_to_null(1)] = "a"
d[_to_null(2)] = "b"
local e = dict(d)
assert((e[_to_null(1)] == "a"))
assert((e[_to_null(2)] == "b"))
local d, m = divmod(10, 3)
assert(((d == 3) and (m == 1)))
d, m = divmod((-10), 3)
assert(((d == (-4)) and (m == 2)))
d, m = divmod(10, (-3))
assert(((d == (-4)) and (m == (-2))))
d, m = divmod((-10), (-3))
assert(((d == 3) and (m == (-1))))
local l = list {_to_null(0, 1, 2, 3, 4)}
for _, i, n in enumerate(l) do
    assert((i == n))
end
l = list {_to_null(0, 1, 2, 3, 4, 5)}
local f = list(filter(nil, l))
assert((len(f) == 5))
assert((f[_to_null(0)] == 1))
assert((f[_to_null(4)] == 5))
f = list(filter(function(n) return ((mod_operator(n, 2)) == 0) end, l))
assert((len(f) == 3))
assert((f[_to_null(0)] == 0))
assert((f[_to_null(1)] == 2))
assert((f[_to_null(2)] == 4))
d = dict {[_to_null(0)] = _to_null("a"), [_to_null("x")] = _to_null("y"), [_to_null("")] = _to_null("space")}
f = list(filter(nil, d))
assert((len(f) == 1))
assert((f[_to_null(0)] == "x"))
assert((float(10) == 10.0))
assert((float(10.4) == 10.4))
assert((float("12") == 12.0))
assert((float("10.8") == 10.8))
assert((hex(0) == "0x0"))
assert((hex(10) == "0xa"))
assert((hex(100) == "0x64"))
assert((hex(1000) == "0x3e8"))
assert((hex(10000) == "0x2710"))
assert((hex(100000) == "0x186a0"))
assert((int() == 0))
assert((int(10) == 10))
assert((int(10.5) == 10))
assert((int((-10.5)) == (-10)))
assert((int("10", 10) == 10))
assert((int("10", 16) == 16))
assert((int(" 10", 10) == 10))
assert((int("10 ", 16) == 16))
assert((int("0b10", 0) == 2))
assert((int("0x10", 0) == 16))
assert((int("-0b10", 0) == (-2)))
assert((int("-0x10", 0) == (-16)))
assert((len("") == 0))
assert((len("abcd") == 4))
assert((len(list {_to_null()}) == 0))
assert((len(list {_to_null(1, 2, 3)}) == 3))
assert((len(dict {}) == 0))
assert((len(dict {[_to_null(0)] = _to_null(0), [_to_null("a")] = _to_null("z")}) == 2))
assert((len(list()) == 0))
l = list(list {_to_null(1, 2, 3)})
assert((len(l) == 3))
assert((l[_to_null(0)] == 1))
assert((l[_to_null(1)] == 2))
assert((l[_to_null(2)] == 3))
l = list {_to_null(0, 1, 2, 3, 4)}
local m = list(map(function(x) return (math.pow(x, 2)) end, l))
assert((len(m) == 5))
assert((m[_to_null(0)] == 0))
assert((m[_to_null(1)] == 1))
assert((m[_to_null(2)] == 4))
assert((m[_to_null(3)] == 9))
assert((m[_to_null(4)] == 16))
local n = list(map(function(x, y) return (x + y) end, l, m))
assert((len(n) == 5))
assert((n[_to_null(0)] == 0))
assert((n[_to_null(1)] == 2))
assert((n[_to_null(2)] == 6))
assert((n[_to_null(3)] == 12))
assert((n[_to_null(4)] == 20))
l = list {_to_null(1, 2, 3, 4, 5)}
assert((max(l) == 5))
assert((max(1, 2, 3, 4, 5) == 5))
l = list {_to_null(1, 2, 3, 4, 5)}
assert((min(l) == 1))
assert((min(1, 2, 3, 4, 5) == 1))
assert((oct(0) == "0o0"))
assert((oct(10) == "0o12"))
assert((oct(100) == "0o144"))
assert((oct(1000) == "0o1750"))
assert((oct(10000) == "0o23420"))
assert((pow(2, 10) == 1024))
assert((pow(2, 9, 3) == 2))
--[[
a = 10
b = 20
c = 'message'

print()
print(a)
print(a, b)
print(a, b, c)
]]
l = (function() local result = list {} for _, i in range(10) do result.append(i) end return result end)()
assert((len(l) == 10))
assert((l[_to_null(0)] == 0))
assert((l[_to_null(9)] == 9))
l = (function() local result = list {} for _, i in range(1, 5) do result.append(i) end return result end)()
assert((len(l) == 4))
assert((l[_to_null(0)] == 1))
assert((l[_to_null(1)] == 2))
assert((l[_to_null(2)] == 3))
assert((l[_to_null(3)] == 4))
l = (function() local result = list {} for _, i in range(1, 9, 2) do result.append(i) end return result end)()
assert((len(l) == 4))
assert((l[_to_null(0)] == 1))
assert((l[_to_null(1)] == 3))
assert((l[_to_null(2)] == 5))
assert((l[_to_null(3)] == 7))
l = list {_to_null(3, 1, 4, 1, 5, 9)}
local rl = list(reversed(l))
assert((rl[_to_null(0)] == 9))
assert((rl[_to_null(1)] == 5))
assert((rl[_to_null(2)] == 1))
assert((rl[_to_null(3)] == 4))
assert((rl[_to_null(4)] == 1))
assert((rl[_to_null(5)] == 3))
assert((round(10) == 10))
assert((round(10, 0) == 10))
assert((round(10, 1) == 10))
assert((round(10, 2) == 10))
assert((round(10, (-1)) == 10))
assert((round(10, (-2)) == 0))
assert((round(10.49, 0) == 10))
assert((round(10.51, 0) == 11))
assert((round(10.49, 1) == 10.5))
assert((round(10.51, 1) == 10.5))
local s = slice(4)
assert((s.start == nil))
assert((s.stop == 4))
assert((s.step == nil))
s = slice(1, 3)
assert((s.start == 1))
assert((s.stop == 3))
assert((s.step == nil))
s = slice(1, 5, 2)
assert((s.start == 1))
assert((s.stop == 5))
assert((s.step == 2))
l = list {_to_null(0, 3, (-2), 5, 6, 9)}
local sl = sorted(l)
assert((len(sl) == 6))
assert((sl[_to_null(0)] == (-2)))
assert((sl[_to_null(1)] == 0))
assert((sl[_to_null(2)] == 3))
assert((sl[_to_null(3)] == 5))
assert((sl[_to_null(4)] == 6))
assert((sl[_to_null(5)] == 9))
assert((sum(list {_to_null(1, 2, 3)}) == 6))
assert((sum(list {_to_null()}) == 0))
assert((sum(list {_to_null(1, 2, 3)}, 0) == 6))
assert((sum(list {_to_null(1, 2, 3)}, 4) == 10))
local t = tuple()
assert((len(t) == 0))
t = tuple(list {_to_null(1, 2, 3, 4)})
assert((t[_to_null(0)] == 1))
assert((t[_to_null(1)] == 2))
assert((t[_to_null(2)] == 3))
assert((t[_to_null(3)] == 4))
local l1 = list {_to_null(0, 1, 2, 3, 4, 5)}
local l2 = list {_to_null("a", "b", "c")}
local l3 = list {_to_null(3, ".", 1, 4, 1)}
local z = list(zip(l1, l2, l3))
assert((z[_to_null(0)][_to_null(0)] == 0))
assert((z[_to_null(0)][_to_null(1)] == "a"))
assert((z[_to_null(0)][_to_null(2)] == 3))
assert((z[_to_null(1)][_to_null(0)] == 1))
assert((z[_to_null(1)][_to_null(1)] == "b"))
assert((z[_to_null(1)][_to_null(2)] == "."))
assert((z[_to_null(2)][_to_null(0)] == 2))
assert((z[_to_null(2)][_to_null(1)] == "c"))
assert((z[_to_null(2)][_to_null(2)] == 1))