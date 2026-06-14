const builtin = @import("builtin");
const std = @import("std");
const glfw = @import("glfw.zig");
const vulkan = @import("vulkan.zig");
const c = @import("c.zig").c;
const meta = @import("meta.zig");

pub fn main() !void {
    var gpa: std.heap.DebugAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const app_info = meta.Info{
        .name = "Hello Triangle",
        .major = 0,
        .minor = 0,
        .patch = 1,
    };

    const vk_version = vulkan.VERSION_1_4;

    const screen_width = 640;
    const screen_height = 480;

    // TODO: move extensions here.

    // End App Configuration

    const glfw_context = glfw.create_context(screen_width, screen_height, app_info.name) catch |err| {
        std.debug.print("Failed to create GLFW context: {}\n", .{err});
        return;
    };
    defer glfw_context.deinit();

    var extension_count = glfw_context.extension_count;
    if (builtin.os.tag == .macos) {
        extension_count += 1;
    }

    const extensions = try allocator.alloc([:0]const u8, extension_count);
    defer allocator.free(extensions);
    for (0..glfw_context.extension_count) |i| {
        extensions[i] = std.mem.span(glfw_context.extensions[i]);
    }

    if (builtin.os.tag == .macos) {
        extensions[extension_count - 1] = @as([:0]const u8, vulkan.PORTABILITY_EXTENSION_NAME);
    }

    if (comptime builtin.mode == .Debug) {
        std.debug.print("configuring {d} vulkan extensions\n", .{extensions.len});
        for (0..extensions.len) |i| {
            std.debug.print("\t{s}\n", .{extensions[i]});
        }
    }

    const vulkan_context = vulkan.create_context(allocator, app_info, app_info, vk_version, extensions) catch |err| {
        std.debug.print("Failed to create Vulkan context: {}\n", .{err});
        return;
    };
    defer vulkan_context.deinit();

    while (c.glfwWindowShouldClose(glfw_context.window) == c.GLFW_FALSE) {
        // TODO: Render here

        // TODO: Swap front and back buffers

        c.glfwPollEvents();
    }
}
