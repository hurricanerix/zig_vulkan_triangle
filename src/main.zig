const std = @import("std");
const glfw = @import("glfw.zig");
const c = @import("c.zig").c;

pub fn main() !void {
    var gpa: std.heap.DebugAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const glfw_context = glfw.create_context(640, 480, "Hello Triangle") catch |err| {
        std.debug.print("Failed to create GLFW context: {}\n", .{err});
        return;
    };
    defer glfw_context.deinit();

    const appInfo: c.VkApplicationInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .pApplicationName = "Hello Triangle",
        .applicationVersion = c.VK_MAKE_VERSION(1, 0, 0),
        .pEngineName = "No Engine",
        .engineVersion = c.VK_MAKE_VERSION(1, 0, 0),
        .apiVersion = c.VK_API_VERSION_1_4,
    };

    // TODO: move to func that gets OS extensions
    const extensionsCount = glfw_context.extension_count + 1;
    const extensions = try allocator.alloc([*c]const u8, extensionsCount);
    defer allocator.free(extensions);
    for (0..glfw_context.extension_count) |i| {
        extensions[i] = glfw_context.extensions[i];
    }
    extensions[extensionsCount - 1] = c.VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME;

    std.debug.print("requested {d} extensions\n", .{extensionsCount});
    for (0..extensionsCount) |i| {
        std.debug.print("\tusing: {s}\n", .{extensions[i]});
    }

    const createInfo: c.VkInstanceCreateInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .flags = c.VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR,
        .pApplicationInfo = &appInfo,
        .enabledExtensionCount = extensionsCount,
        .ppEnabledExtensionNames = extensions.ptr,
    };

    var instance: c.VkInstance = undefined;
    if (c.vkCreateInstance(&createInfo, null, &instance) != c.VK_SUCCESS) {
        // TODO: provide richer error messages with vkGetInstanceExtensionProperties.
        std.debug.print("Error creating Vulkan instance\n", .{});
        return;
    }
    defer c.vkDestroyInstance(instance, null);

    std.debug.print("Vulkan instance created\n", .{});

    while (c.glfwWindowShouldClose(glfw_context.window) == c.GLFW_FALSE) {
        // TODO: Render here

        // TODO: Swap front and back buffers

        c.glfwPollEvents();
    }
}
