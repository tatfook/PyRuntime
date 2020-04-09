local function func(kvs, n)
    n = get_posarg(kvs, 'n', n, nil, 'func')
    return (math.pow(n, 1))
end
return {
    func = func,
}