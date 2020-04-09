local i = 0
while bool({}, true) do
    if bool({}, (i > 99)) then
        break
    end
    i = (i + 1)
end
assert(bool({}, (i == 100)))
i = 0
local j = 0
while bool({}, true) do
    while bool({}, true) do
        if bool({}, (i > 99)) then
            break
        end
        i = (i + 1)
    end
    if bool({}, (j > 49)) then
        break
    end
    j = (j + 1)
end
assert(bool({}, (i == 100)))
assert(bool({}, (j == 50)))
return {
    i = i,
    j = j,
}