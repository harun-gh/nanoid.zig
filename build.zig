const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const nanoid = b.addModule("nanoid", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const tests = b.addTest(.{
        .name = "nanoid-test",
        .root_module = nanoid,
    });

    const run_tests = b.addRunArtifact(tests);

    const test_step = b.step("test", "テスト実行");
    test_step.dependOn(&run_tests.step);
}
