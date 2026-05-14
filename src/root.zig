const std = @import("std");
const unicode = std.unicode;
const Io = std.Io;

pub const Utils = @import("utils.zig");
const calculateBitsMask = Utils.calculateBitsMask;
const calculateBatchSize = Utils.calculateBatchSize;

pub const Dictionary = @import("dictionary.zig");

pub const RandomMode = enum {
    secure,
    non_secure,
};

pub const default_dictionary = "_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

pub fn generate(comptime mode: RandomMode, io: *Io, buffer: []u8, comptime dictionary: []const u8, out: []u8) !void {
    const required_len = out.len;
    const dictionary_len = dictionary.len;

    const mask = try comptime calculateBitsMask(dictionary.len);

    var i: usize = 0;

    while (i < required_len) {
        const remaining = required_len - i; // 残り必要な文字数
        const step = try calculateBatchSize(dictionary_len, remaining, mask);
        const range = @min(buffer.len, step);

        switch (mode) {
            .non_secure => io.vtable.random(io.userdata, buffer[0..range]),
            .secure => try io.vtable.randomSecure(io.userdata, buffer[0..range]),
        }

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

test "nanoid(secure): 256文字" {
    const allocator = std.testing.allocator;

    var io_evented: Io.Evented = undefined;
    try std.Io.Evented.init(&io_evented, allocator, .{
        .backing_allocator_needs_mutex = false,
    });
    defer io_evented.deinit();

    var io = io_evented.io();

    var out: [256]u8 = undefined;
    var buffer: [512]u8 = undefined;

    try generate(.secure, &io, &buffer, Dictionary.standard, &out);

    // std.debug.print("secure: {s}\n", .{out});

    // チェック

    try std.testing.expect(try unicode.utf8CountCodepoints(&out) == out.len);
}

test "nanoid(non-secure): 256文字" {
    const allocator = std.testing.allocator;

    var io_evented: Io.Evented = undefined;
    try std.Io.Evented.init(&io_evented, allocator, .{
        .backing_allocator_needs_mutex = false,
    });
    defer io_evented.deinit();

    var io = io_evented.io();

    var out: [256]u8 = undefined;
    var buffer: [512]u8 = undefined;

    try generate(.non_secure, &io, &buffer, Dictionary.standard, &out);

    // std.debug.print("non-secure: {s}\n", .{out});

    // チェック

    try std.testing.expect(try unicode.utf8CountCodepoints(&out) == out.len);
}
