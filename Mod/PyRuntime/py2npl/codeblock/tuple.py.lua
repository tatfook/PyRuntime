local t = tuple(list {_to_null(1, 2, 3, nil)})
assert((len(t) == 4))
assert((t[_to_null(0)] == 1))
assert((t[_to_null(1)] == 2))
assert((t[_to_null(2)] == 3))
assert((t[_to_null(3)] == nil))
t = tuple(list {_to_null(1, "a", "z", "pi", "a", "c", "c", nil)})
assert((t.count(1) == 1))
assert((t.count("a") == 2))
assert((t.count("b") == 0))
assert((t.count("c") == 2))
assert((t.count(nil) == 1))
t = tuple(list {_to_null(1, "a", "z", "pi", "a", "c", "c")})
assert((t.index("a") == 1))
assert((t.index("a", 0) == 1))
assert((t.index("a", 1) == 1))
assert((t.index("a", 2) == 4))
assert((t.index("a", 3) == 4))
assert((t.index("a", 4) == 4))
assert((t.index("a", 1, 4) == 1))
assert((t.index("a", 2, 5) == 4))