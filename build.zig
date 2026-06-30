const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "vulkan_triangle",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });

    exe.root_module.linkSystemLibrary("glfw", .{});
    exe.root_module.linkSystemLibrary("vulkan", .{});

    if (builtin.os.tag == .macos) {
        exe.root_module.addIncludePath(.{ .cwd_relative = "/opt/homebrew/include" });
        exe.root_module.addLibraryPath(.{ .cwd_relative = "/opt/homebrew/lib" });
    }

    const compile_vert = b.addSystemCommand(&.{ "glslang", "-V", "-o" });
    const vert_spv = compile_vert.addOutputFileArg("vert.spv");
    compile_vert.addFileArg(b.path("src/shaders/triangle.vert"));
    const install_vert = b.addInstallFileWithDir(vert_spv, .bin, "vert.spv");
    b.getInstallStep().dependOn(&install_vert.step);

    const compile_frag = b.addSystemCommand(&.{ "glslang", "-V", "-o" });
    const frag_spv = compile_frag.addOutputFileArg("frag.spv");
    compile_frag.addFileArg(b.path("src/shaders/triangle.frag"));
    const install_frag = b.addInstallFileWithDir(frag_spv, .bin, "frag.spv");
    b.getInstallStep().dependOn(&install_frag.step);

    b.installArtifact(exe);
}
