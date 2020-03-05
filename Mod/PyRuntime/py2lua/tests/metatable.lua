local string_meta = getmetatable("")

string_meta.__add = function(v1, v2)
   print(type(v1))
   print(type(v2))
   return 'add'
end

print('a' + 1)

print(1 + 'a')

print(1 + 'a' + 1)

print(1 + 1)
