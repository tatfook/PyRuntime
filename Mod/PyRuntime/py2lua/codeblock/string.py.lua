assert((("begin" + "end") == "beginend"))
assert((("begin" + 1) ~= "begin1"))
assert((("begin" + nil) ~= "begin"))
assert((("begin" + a) ~= "begin"))