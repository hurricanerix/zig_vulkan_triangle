const std = @import("std");
const builtin = @import("builtin");
const meta = @import("meta.zig");
const glfw = @import("glfw.zig");
const vulkan = @import("vulkan.zig");

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
    const vk_extensions = [_][:0]const u8{"VK_EXT_debug_utils"};

    const screen_width = 640;
    const screen_height = 480;

    const glfw_context = glfw.create_context(screen_width, screen_height, app_info.name) catch |err| {
        std.debug.print("Failed to create GLFW context: {}\n", .{err});
        return;
    };
    defer glfw_context.deinit();

    const extension_count = glfw_context.extension_count + vk_extensions.len;
    const extensions = try allocator.alloc([:0]const u8, extension_count);
    defer allocator.free(extensions);
    for (0..glfw_context.extension_count) |i| {
        extensions[i] = std.mem.span(glfw_context.extensions[i]);
    }
    for (0..vk_extensions.len) |i| {
        extensions[glfw_context.extension_count + i] = vk_extensions[i];
    }

    const vulkan_context = vulkan.create_context(allocator, app_info, app_info, vk_version, extensions) catch |err| {
        std.debug.print("Failed to create Vulkan context: {}\n", .{err});
        return;
    };
    defer vulkan_context.deinit();

    while (!glfw_context.window_should_close()) {
        // TODO: Render here

        // TODO: Swap front and back buffers

        glfw_context.poll_events();
    }
}
