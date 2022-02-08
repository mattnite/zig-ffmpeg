const std = @import("std");
const ffmpeg = @import("ffmpeg.zig");
const zlib = @import("zlib-build");
const lame = @import("lame-build");

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const z = zlib.create(b, target, mode);
    _ = z;
    const mp3lame = lame.create(b, target, mode);
    _ = mp3lame;

    const lib = try ffmpeg.create(b, target, mode);
    z.link(lib.avcodec, .{});
    z.link(lib.avformat, .{});
    mp3lame.link(lib.avcodec);

    inline for (std.meta.fields(ffmpeg.Library)) |field| {
        @field(lib, field.name).install();
    }

    // TODO: tests
    //const main_tests = b.addTest("src/main.zig");
    //main_tests.setBuildMode(mode);

    //const test_step = b.step("test", "Run library tests");
    //test_step.dependOn(&main_tests.step);
}
