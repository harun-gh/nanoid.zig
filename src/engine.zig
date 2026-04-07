const std = @import("std");
const crypto = std.crypto;

const utils = @import("utils.zig");
const calculateBitsMask = utils.calculateBitsMask;
const calculateBatchSize = utils.calculateBatchSize;

const Engine = @This();

const CACHE_LINE = 64;

dictionary: []const u8,
rand_fn: std.Random,
mask: usize,

/// Nano IDを初期化します
pub fn init(dictionary: []const u8, rand_fn: std.Random) Engine {
    const mask = calculateBitsMask(dictionary.len);

    return .{
        .dictionary = dictionary,
        .rand_fn = rand_fn,
        .mask = mask,
    };
}

/// Nano IDを生成します
pub fn generate(self: *const Engine, out: []u8, buffer: []u8) void {
    const dictionary = self.dictionary;
    const dictionary_len = dictionary.len;
    const required_len = out.len;
    const mask = self.mask;
    const rand_fn = self.rand_fn;

    var i: usize = 0;

    while (i < required_len) {
        const remaining = required_len - i; // 残り必要な文字数
        const step = calculateBatchSize(dictionary_len, remaining, mask);
        const range = @min(buffer.len, step);

        rand_fn.bytes(buffer[0..range]);

        for (buffer[0..range]) |value| {
            const index = @as(usize, value) & mask;

            if (index < dictionary_len) {
                out[i] = dictionary[index];
                i += 1;
                if (i == required_len) return;
            }
        }
    }
}
