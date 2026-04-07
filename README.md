# nanoid.zig

JavaScriptライブラリの「nanoid」をzigに移植しました  

> [!NOTE]
> ベンチマークはまだ改善の余地がありますが、可読性を優先して最適化は最小限に留めています

## 使い方

辞書文字列(ランダム文字列生成においてベースとなる辞書)に `_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ` が設定されています  
(URLに使用しても問題ない文字だけに厳選していますが、記号などを組み合わせたい場合は下の「例: カスタム辞書文字列を設定」を参照してください)

```zig
const std = @import("std");

const nanoid = @import("nanoid").nanoid;

var buffer: [64]u8 = undefined; // [ほしい文字数]u8にしてください
nanoid.generate(&buffer);

std.debug.print("nanoid(64文字): {s}", .{buffer[0..]});
```

### 例: カスタム辞書文字列を設定

```zig
const std = @import("std");

const Engine = @import("nanoid").Engine;

const dictionary = "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&()*+,./:;<=>?@[]^{}|~";

const nanoid = Engine.init(dictionary, std.crypto.random);

var buffer: [64]u8 = undefined; // [ほしい文字数]u8にしてください
nanoid.generate(&buffer);

std.debug.print("nanoid(64文字): {s}", .{buffer[0..]});
```

### 例: カスタムランダム生成器

デフォルトの `@import("nanoid").nanoid` では `std.crypto.random` が採用されいますが、ほかに `Xoshiro256` などを使いたい場合に最適です

> [!CAUTION]
> `std.Random.DefaultPrng` (Xoshiro系) は高速ですが、内部状態(seed)から出力を予測できる可能性があります
> セッションIDや認証トークンなどのセキュリティ用途には使用せず、必ず `std.crypto.random` を使用してください

```zig
const std = @import("std");

const Engine = @import("nanoid").Engine;
const default_dictionary = @import("nanoid").default_dictionary;

// Xoshiro系PRNG
var prng: std.Random.DefaultPrng = .init(blk: {
    var seed: u64 = undefined;
    try std.posix.getrandom(std.mem.asBytes(&seed));
    break :blk seed;
});
const rng = prng.random();
const generator = Engine.init(default_dictionary, rng); // 辞書文字列を置き換えたい場合は、

var buffer: [64]u8 = undefined; // [ほしい文字数]u8にしてください
generator.generate(&buffer);

std.debug.print("Xoshiro256(64文字): {s}", .{buffer[0..]});
```

## 参考文献

- [nanoid/index.js at main · ai/nanoid](https://github.com/ai/nanoid/blob/main/index.js)