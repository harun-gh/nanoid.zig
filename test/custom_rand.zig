// 例: カスタムランダム生成器

const std = @import("std");

const Engine = @import("nanoid").Engine;
const default_dictionary = @import("nanoid").default_dictionary;

test {
    var prng: std.Random.DefaultPrng = .init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();

    const generator = Engine.init(default_dictionary, rand);

    var out: [64]u8 = undefined;
    var buffer: [256]u8 = undefined;
    generator.generate(&out, &buffer);

    std.debug.print("Xoshiro256(64文字): {s}\n", .{out[0..]});
}
