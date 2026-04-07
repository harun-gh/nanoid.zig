# nanoid.zig

JavaScriptの「nanoid」をZigに移植したライブラリです  

> [!NOTE]
> デフォルトで、辞書文字列(ランダム文字列生成においてベースとなる辞書)に `_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ` が設定されています  
> (URLに使用しても問題ない文字だけに厳選していますが、記号などを組み合わせたい場合は `test/custom_dictionary.zig` を参照してください)

## 使い方・例

以下で実行可能です

```bash
zig build test
```

- **デフォルト**: `test/default_usage.zig`
- **カスタム辞書文字列を設定**: `test/custom_dictionary.zig`
- **カスタムランダム生成器**: `test/custom_rand.zig`

## 参考文献

- [nanoid/index.js at main · ai/nanoid](https://github.com/ai/nanoid/blob/main/index.js)