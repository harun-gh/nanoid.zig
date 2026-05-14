# nanoid.zig

JavaScriptの「nanoid」をZigに移植したライブラリです

## 使い方・例

以下で実行可能です

```zig
const nanoid = @import("nanoid");

try nanoid.generate(
    comptime mode: RandomMode, // non-secureかsecure
    io: *Io, // std.Io
    buffer: []u8, // 処理用バッファ
    comptime dictionary: []const u8, // 辞書文字列
    out: []u8 // 出力先バッファ
);
```

## 参考文献

- [nanoid/index.js at main · ai/nanoid](https://github.com/ai/nanoid/blob/main/index.js)