# PyTranspiler Mod

一个 npl mod，用来将可执行的 python 代码转换为 lua 代码。

## 支持语言版本

针对 python 3 版本，支持大部分 features，具体可参考 https://github.com/tatfook/py2lua

## usage

先将 Mod 安装到 paracraft 的搜索路径下

```
$ cd ${paracraft_installed_root}/Mod
$ git clone https://github.com/tatfook/PyTranspiler
```

在代码中使用 PyTranspiler

```lua
local py2lua = NPL.load("Mod/PyTranspiler/Transpiler.lua")
local lua_code = py2lua:transpile("b = 3")
print(lua_code)
```

示例结果

```
local b = 3
```

## error handling

在使用 mod 的过程中，可能会出现错误情况，比如
- python 代码语法不正确
- etc

`transpile()`方法会返回两个值，当转换结果为 `nil` 时，说明转换出现问题，相关错误信息会保存在第 2 个值。

```lua
local lua_code, error_msg = py2lua:transpile("b = 3")
if lua_code == nil then
    -- handle error_msg
end
```

