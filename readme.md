# PyRuntime Mod

一个用来在 npl 平台执行 python 代码的 npl mod，主要通过 transpiler 技术实现。

## 支持语言版本

针对 python 3 版本，支持 feature 列表可参考 https://github.com/tatfook/py2lua/blob/master/doc/features.md

## usage

下载代码，再将 PyRuntime 添加到 npl 搜索路径下

```
$ git clone https://github.com/tatfook/PyRuntime
```

在代码中使用 PyRuntime

```lua
local pyruntime = NPL.load("Mod/PyRuntime/Transpiler.lua")
pyruntime:transpile("b = 3", function(res)
    local lua_code = res["lua_code"]
    if lua_code == nil then
        -- error happens
        print(res["error_msg"])
    end

    -- deal with lua_code normally
    print(lua_code)
end)
```

示例结果

```
local b = 3
```

## error handling

在使用 mod 的过程中，可能会出现错误情况，比如
- python 代码语法不正确
- 底层代码出现错误
- etc

`transpile()`方法会返回一个 table，其中包含 `lua_code` 和 `error_msg`：
- 当转换正常，`lua_code` 保存了转换的结果
- 当转换过程出现错误时，`lua_code` 结果为 `nil`，相关错误信息会保存在 `error_msg`



