// 例: カスタム辞書文字列を設定

const std = @import("std");
const customDictionary = @import("nanoid").customDictionary;

const dictionary = "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!#$%&()*+,./:;<=>?@[]^{}|~";

test {
    const nanoid = customDictionary(dictionary);

    var out: [64]u8 = undefined;
    var buffer: [256]u8 = undefined;
    nanoid.generate(&out, &buffer);

    std.debug.print("nanoid(64文字, 辞書文字列カスタム): {s}\n", .{out[0..]});
}
