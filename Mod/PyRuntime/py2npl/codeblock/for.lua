local n = 0
for _, i in list({}, {_to_null(1, 2, 3)}) do
    n = (n + 1)
    assert(bool({}, (i == n)))
end
local d = dict({}, {[_to_null(1)] = _to_null(1), [_to_null(2)] = _to_null(2), [_to_null(3)] = _to_null(3)})
for _, k, v in d.items(merge_kwargs({}, {})) do
    assert(bool({}, (k == v)))
end
n = 0
for _, i in range(merge_kwargs({}, {}), 10) do
    assert(bool({}, (i == n)))
    n = (n + 1)
end
assert(bool({}, (n == 10)))
n = 1
for _, i in range(merge_kwargs({}, {}), 1, 5) do
    assert(bool({}, (i == n)))
    n = (n + 1)
end
assert(bool({}, (n == 5)))
n = 1
for _, i in range(merge_kwargs({}, {}), 1, 10, 2) do
    assert(bool({}, (i == n)))
    n = (n + 2)
end
assert(bool({}, (n == 11)))
n = 10
for _, i in range(merge_kwargs({}, {}), 10, 1, (-2)) do
    assert(bool({}, (i == n)))
    n = (n - 2)
end
assert(bool({}, (n == 0)))
return {
    n = n,
    d = d,
}