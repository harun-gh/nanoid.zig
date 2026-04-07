const std = @import("std");
const print = std.debug.print;

pub const Engine = @import("engine.zig");

const CryptoRandom = std.crypto.random;

pub const default_dictionary = "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

/// nanoid.generate(out: []u8) で使用できます
/// outの引数におけるバッファサイズは任意です
pub const nanoid = Engine.init(default_dictionary, CryptoRandom);

pub fn customDictionary(alphabet: []const u8) Engine {
    return Engine.init(alphabet, CryptoRandom);
}
