# PyRuntime Mod

一个用来在 npl 平台执行 python 代码的 npl mod，通过 transpiler 技术实现。

## 支持语言版本

针对 python 3.4 版本，对于 feature 的支持可参考列表 https://github.com/tatfook/PyRuntime/blob/master/Mod/PyRuntime/py2npl/doc/features.md

## usage

确保 PyRuntime 已添加到 Mod 搜索路径下

```lua
local transpiler = NPL.load("Mod/PyRuntime/Transpiler.lua")

transpiler:start()

error, luacode = transpiler:transpile(py_code)

if error then
    local error_msg = luacode
    print("error msg", error_msg)
end

-- handle with the transpiled luacode

transpiler:terminate()
```

其中注意两个地方
1. transpiler 使用了 C/S 结构来增加性能，意味着底层有一个 transpile 服务，我们通过
   transpile() 方法来调用这个服务，这也是为什么需要 start() 和 terminate() 方法的原因
2. transpile() 方法的返回值有两个，第一个为错误标识，第二个为返回信息
   - 当没有错误时，第二个参数为转换得到的 lua 代码
   - 当发生错误时，第二个参数表示 transpile 过程中的错误信息


## details

transpile 的底层服务是一个 http 服务器，使用 python 代码编写，最终打包成为 exe。
这样 npl 就可以开启/关闭服务器，并且使用 http 接口来获取 transpile 服务。

至于具体的 transpiler 实现，参考 [py2npl](./Mod/PyRuntime/py2npl/README.md)

