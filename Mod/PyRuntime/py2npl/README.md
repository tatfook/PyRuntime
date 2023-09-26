# py2npl

A python project for transpiling pycode to luacode and can be distributed as a single executable file to run.


## features

支持的 python 语言以 python 3.4 为基准，支持大部分 feature。

具体可见 :point_right: [features](./doc/features.md) :point_left:


## usage

### prerequisite

- 安装 python 3.4.4 32bit（对于老式的平台如 XP，无法运行 64bit 程序）
- `python.exe -m pip install pyinstaller==3.4` （更新版本的 pyinstaller 脱离了对 py 3.4 的支持）
- （可选，仅供运行测试）安装 lua5.1 (use `choco install lua51` for windows)

### run

```
$ python py2npl.py --help
usage: py2npl.py [-h] [--addr ADDR] [--port PORT] [--verbose]

optional arguments:
  -h, --help   show this help message and exit
  --addr ADDR  serve listen address
  --port PORT  serve listen port
  --verbose    if show verbose information
```

py2npl 采用了 C/S 结构来提升并发性，直接运行相当于启动了服务器

```
$ python py2npl.py
start server at 127.0.0.1:8006, use <Ctrl-C> to stop
```


通过接口 `/transpile` 来进行转换

```
curl --location --request POST '127.0.0.1:8006/transpile' \
--header 'Content-Type: application/json' \
--data-raw '{
	"pycode": "a = 1\r\nb = 1\r\n"
}'
```

得到结果
```
{"luacode": "local a = 1\nlocal b = 1", "error": false}
```

通过接口 `/exit` 可主动关闭服务器

```
curl --location --request POST '127.0.0.1:8006/exit'
```

得到结果，同时服务器关闭

```
{"exit": true}
```

### polyfill

python 语言和 lua 语言在单纯的语法结构上有很大程度的类似，但是 python 比 lua 有更丰富的内建函数（比如 dir, hex, etc）和内建数据结构（比如 list, dict, etc）。

对于 lua 本身并不支持的上述概念，就需要在 lua 层面用语言来实现，比如用 lua 实现一个 list 结构，提供在 python 中一样的操作接口，这样就可以将在语法层面转换过来的代码，在真实的 lua 环境执行，这个环境称作 polyfill，通过 lua 中的 setfenv 来实现。

这部分功能的实现都在 `pypolyfill.lua` 文件中，如果要执行转换后的 lua 代码，引用 `pypolyfill.lua` 是必不可少的。


### distribute

通过 pyinstaller，将项目代码打包为不依赖平台环境的可执行文件

```
pip install pyinstaller
pip install --upgrade pyinstaller
python distribute.py
```

可以在 `dist/` 目录下，找到生成的 `py2npl` 可执行文件。


