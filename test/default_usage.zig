// nanoid

const std = @import("std");
const nanoid = @import("nanoid").nanoid;

test {
    var out: [64]u8 = undefined; // 出力用メモリーバッファ: [ほしい文字数]u8
    var buffer: [256]u8 = undefined; // 処理用メモリーバッファ: でかいほどいいかもしれないけど、やりすぎるとただのオーバーヘッドです
    nanoid.generate(&out, &buffer);

    std.debug.print("nanoid(64文字): {s}\n", .{out[0..]});
}
