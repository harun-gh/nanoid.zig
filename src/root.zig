const std = @import("std");
const print = std.debug.print;
const testing = std.testing;

pub const Engine = @import("engine.zig");

const CryptoRandom = std.crypto.random;

pub const default_dictionary = "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

/// nanoid.generate(out: []u8) で使用できます
/// outの引数におけるバッファサイズは任意です
pub const nanoid = Engine.init(default_dictionary, CryptoRandom);

pub fn customAlphabet(alphabet: []const u8) Engine {
    return Engine.init(alphabet, CryptoRandom);
}

test "nanoidテスト" {
    var buffer: [64]u8 = undefined;
    nanoid.generate(&buffer);

    for (buffer) |t| {
        try std.testing.expect(std.mem.indexOfScalar(u8, default_dictionary, t) != null);
    }
}
