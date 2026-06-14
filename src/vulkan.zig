const builtin = @import("builtin");
const std = @import("std");
const c = @import("c.zig").c;
const meta = @import("meta.zig");

const Error = error{ ExtensionsAllocationFailed, CreateInstanceFailed };

pub const PORTABILITY_EXTENSION_NAME = c.VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME;

pub const VERSION_1_0 = c.VK_API_VERSION_1_0;
pub const VERSION_1_1 = c.VK_API_VERSION_1_1;
pub const VERSION_1_2 = c.VK_API_VERSION_1_2;
pub const VERSION_1_3 = c.VK_API_VERSION_1_3;
pub const VERSION_1_4 = c.VK_API_VERSION_1_4;

pub const Context = struct {
    instance: c.VkInstance,

    pub fn deinit(self: Context) void {
        c.vkDestroyInstance(self.instance, null);
    }
};

pub fn create_context(allocator: std.mem.Allocator, app_info: meta.Info, engine_info: meta.Info, vk_version: u32, extensions: []const [:0]const u8) !Context {
    const vk_app_info: c.VkApplicationInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_APPLICATION_INFO,
        .pApplicationName = @ptrCast(@alignCast(app_info.name.ptr)),
        .applicationVersion = c.VK_MAKE_VERSION(app_info.major, app_info.minor, app_info.patch),
        .pEngineName = @ptrCast(@alignCast(engine_info.name.ptr)),
        .engineVersion = c.VK_MAKE_VERSION(engine_info.major, engine_info.minor, engine_info.patch),
        .apiVersion = vk_version,
    };

    if (comptime builtin.mode == .Debug) std.debug.print("vulkan app info created\n\t{}\n", .{vk_app_info});

    const extensions_c_count = @as(u32, @min(extensions.len, std.math.maxInt(u32)));
    const extensions_c = allocator.alloc([*c]const u8, extensions_c_count) catch |err| {
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan could not allocate mem for extensions {}\n", .{err});
        return Error.ExtensionsAllocationFailed;
    };

    var flags: c.VkFlags = 0;

    for (0..extensions_c_count) |i| {
        extensions_c[i] = @ptrCast(@alignCast(extensions[i].ptr));
        if (std.mem.eql(u8, extensions[i], PORTABILITY_EXTENSION_NAME)) {
            flags |= c.VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR;
        }
    }
    defer allocator.free(extensions_c);

    if (comptime builtin.mode == .Debug) std.debug.print("vulkan extensions converted from zig to c format\n", .{});

    const vk_create_info: c.VkInstanceCreateInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .flags = flags,
        .pApplicationInfo = &vk_app_info,
        .enabledExtensionCount = extensions_c_count,
        .ppEnabledExtensionNames = @ptrCast(@alignCast(extensions_c.ptr)),
    };

    if (comptime builtin.mode == .Debug) std.debug.print("vulkan instance create info created\n\t{}\n", .{vk_create_info});

    var instance: c.VkInstance = undefined;
    if (c.vkCreateInstance(&vk_create_info, null, &instance) != c.VK_SUCCESS) {
        // TODO: provide richer error messages with vkGetInstanceExtensionProperties.
        std.debug.print("Error creating Vulkan instance\n", .{});
        return Error.CreateInstanceFailed;
    }

    if (comptime builtin.mode == .Debug) std.debug.print("vulkan instance created\n", .{});

    return Context{
        .instance = instance,
    };
}
