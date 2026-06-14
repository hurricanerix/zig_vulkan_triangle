const builtin = @import("builtin");
const std = @import("std");
const c = @import("c.zig").c;

const Error = error{
    InitFailed,
    VulkanNotSupported,
    WindowCreationFailed,
};

pub const Context = struct {
    window: *c.GLFWwindow,
    extension_count: u32,
    extensions: [*c][*c]const u8,

    pub fn deinit(_: Context) void {
        c.glfwTerminate();
    }
};

pub fn create_context(width: i32, height: i32, name: [*c]const u8) !Context {
    if (c.glfwInit() != c.GLFW_TRUE) {
        return Error.InitFailed;
    }

    if (comptime builtin.mode == .Debug) std.debug.print("glfw initialized\n", .{});

    if (c.glfwVulkanSupported() == c.GLFW_FALSE) {
        return Error.VulkanNotSupported;
    }

    if (comptime builtin.mode == .Debug) std.debug.print("glfw reports vulkan supported\n", .{});

    c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_NO_API);
    const window = c.glfwCreateWindow(width, height, name, null, null);
    if (window == null) {
        return Error.WindowCreationFailed;
    }

    if (comptime builtin.mode == .Debug) std.debug.print("glfw window created\n", .{});

    var extensionCount: u32 = 0;
    const extensions = c.glfwGetRequiredInstanceExtensions(&extensionCount);

    if (comptime builtin.mode == .Debug) std.debug.print("glfw extensions received\n", .{});

    return Context{ .window = window.?, .extension_count = extensionCount, .extensions = extensions };
}
