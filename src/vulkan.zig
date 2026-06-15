const std = @import("std");
const builtin = @import("builtin");
const meta = @import("meta.zig");
const c = @import("c.zig").c;

const Error = error{ ExtensionsAllocationFailed, CreateInstanceFailed };

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

    const is_metal_surface = for (extensions) |ext| {
        if (std.mem.eql(u8, ext, "VK_EXT_metal_surface")) break true;
    } else false;

    const extensions_extra_count: u32 = if (is_metal_surface) 1 else 0;
    const extensions_c_count = @as(u32, @min(extensions.len, std.math.maxInt(u32))) + extensions_extra_count;
    const extensions_c = allocator.alloc([*c]const u8, extensions_c_count) catch |err| {
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan could not allocate mem for extensions {}\n", .{err});
        return Error.ExtensionsAllocationFailed;
    };
    defer allocator.free(extensions_c);

    var flags: c.VkFlags = 0;
    for (0..extensions.len) |i| {
        extensions_c[i] = @ptrCast(@alignCast(extensions[i].ptr));
    }

    if (is_metal_surface) {
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan metal surface detected\n", .{});
        flags |= c.VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR;
        extensions_c[extensions_c_count - 1] = c.VK_KHR_PORTABILITY_ENUMERATION_EXTENSION_NAME;
    }

    if (comptime builtin.mode == .Debug) {
        std.debug.print("using {d} vulkan extensions\n", .{extensions_c_count});
        for (0..extensions_c_count) |i| {
            std.debug.print("\t{s}\n", .{extensions_c[i]});
        }
    }

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
