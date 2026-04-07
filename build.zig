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
        .name = "test",
        .root_module = b.createModule(
            .{
                .root_source_file = b.path("test/root.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "nanoid", .module = nanoid },
                },
            },
        ),
    });

    const run_tests = b.addRunArtifact(tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);
}
