const std = @import("std");
const c = @cImport({
    @cInclude("GLFW/glfw3.h");
    @cInclude("vulkan/vulkan.h");
});

pub fn main() !void {
    var gpa: std.heap.DebugAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    if (c.glfwInit() != c.GLFW_TRUE) {
        std.debug.print("GLFW failed to initialize\n", .{});
        return;
    }
    defer c.glfwTerminate();

    if (c.glfwVulkanSupported() == c.GLFW_FALSE) {
        std.debug.print("Vulkan is not supported\n", .{});
        return;
    }

    std.debug.print("GLFW initialized\n", .{});

    c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_NO_API);

    const window = c.glfwCreateWindow(640, 480, "Hello Triangle", null, null);
    if (window == null) {
        std.debug.print("GLFW failed to create window\n", .{});
        return;
    }

    std.debug.print("GLFW created window\n", .{});

    const appInfo: c.VkApplicationInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .pApplicationName = "Hello Triangle",
        .applicationVersion = c.VK_MAKE_VERSION(1, 0, 0),
        .pEngineName = "No Engine",
        .engineVersion = c.VK_MAKE_VERSION(1, 0, 0),
        .apiVersion = c.VK_API_VERSION_1_4,
    };

    var glfwExtensionsCount: u32 = undefined;
    const glfwExtensions = c.glfwGetRequiredInstanceExtensions(&glfwExtensionsCount);

    // TODO: move to func that gets OS extensions
    const extensionsCount = glfwExtensionsCount + 1;
    const extensions = try allocator.alloc([*c]const u8, extensionsCount);
    defer allocator.free(extensions);
    for (0..glfwExtensionsCount) |i| {
        extensions[i] = glfwExtensions[i];
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

    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        // TODO: Render here

        // TODO: Swap front and back buffers

        c.glfwPollEvents();
    }
}
