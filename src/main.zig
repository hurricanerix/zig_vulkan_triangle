const std = @import("std");
const c = @cImport({
    @cInclude("GLFW/glfw3.h");
});

pub fn main() !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    if (c.glfwInit() != c.GLFW_TRUE) {
        std.debug.print("GLFW failed to initialize\n", .{});
        return;
    }
    defer c.glfwTerminate();

    std.debug.print("GLFW initialized\n", .{});

    c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_NO_API);

    const window = c.glfwCreateWindow(640, 480, "Hello Triangle", null, null);
    if (window == null) {
        std.debug.print("GLFW failed to create window\n", .{});
        return;
    }

    std.debug.print("GLFW created window\n", .{});

    while (c.glfwWindowShouldClose(window) == c.GLFW_FALSE) {
        // TODO: Render here

        // TODO: Swap front and back buffers

        c.glfwPollEvents();
    }
}
