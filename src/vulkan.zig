const std = @import("std");
const builtin = @import("builtin");
const meta = @import("meta.zig");
const c = @import("c.zig").c;

const Error = error{ ExtensionsAllocationFailed, LayersAllocationFailed, CreateDebugMessengerFailed, CreateInstanceFailed, EnumeratePhysicalDeviceCountsFailed, EnumeratePhysicalDevicesFailed, QueueFamilyPropertiesFailed, AcceptableDeviceLocationFailed, CreateDeviceFailed, DeviceExtensionsAllocationFailed, SurfaceCapsFailed, NullPhysicalDeviceError, NullSurfaceError, SurfaceFormatsCountFailed, SurfaceFormatsAllocationFailed, SurfaceFormatsFailed, SurfaceFormatsNotFound, SurfacePresentModesCountFailed, SurfacePresentModesAllocationFailed, SurfacePresentModesFailed, SurfacePresentModesNotFound, CreateSwapchainFailed };

pub const VERSION_1_0 = c.VK_API_VERSION_1_0;
pub const VERSION_1_1 = c.VK_API_VERSION_1_1;
pub const VERSION_1_2 = c.VK_API_VERSION_1_2;
pub const VERSION_1_3 = c.VK_API_VERSION_1_3;
pub const VERSION_1_4 = c.VK_API_VERSION_1_4;

pub const Context = struct {
    instance: c.VkInstance,
    debug_messenger: ?c.VkDebugUtilsMessengerEXT,

    physical_device: ?c.VkPhysicalDevice = null,
    queue_index: u32 = 0,
    device: ?c.VkDevice = null,
    surface: ?c.VkSurfaceKHR = null,
    surface_caps: ?c.VkSurfaceCapabilitiesKHR = null,
    surface_format: ?c.VkSurfaceFormatKHR = null,
    surface_present_mode: ?c.VkPresentModeKHR = null,
    swapchain: ?c.VkSwapchainKHR = null,

    pub fn create_swap_chain(self: *Context, allocator: std.mem.Allocator) !void {
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan create swap chain\n", .{});
        if (self.physical_device == null) {
            return Error.NullPhysicalDeviceError;
        }

        if (self.surface == null) {
            return Error.NullSurfaceError;
        }

        self.surface_caps = try self.get_surface_caps();
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan surface caps {}\n", .{self.surface_caps.?});

        self.surface_format = try self.get_surface_format(allocator);
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan surface format {}\n", .{self.surface_format.?});

        self.surface_present_mode = try self.get_surface_present_mode(allocator);
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan surface present mode {}\n", .{self.surface_present_mode.?});

        const swapchain_create_info: c.VkSwapchainCreateInfoKHR = .{
            .sType = c.VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR,
            .surface = self.surface.?,
            .minImageCount = self.surface_caps.?.minImageCount,
            .imageFormat = self.surface_format.?.format,
            .imageColorSpace = self.surface_format.?.colorSpace,
            .imageExtent = self.surface_caps.?.currentExtent,
            .presentMode = self.surface_present_mode.?,
            .imageArrayLayers = 1,
            .imageUsage = c.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT, // for rendering
            .imageSharingMode = c.VK_SHARING_MODE_EXCLUSIVE, // assumes graphics and present are same queue
            .preTransform = self.surface_caps.?.currentTransform,
            .compositeAlpha = c.VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR,
            .clipped = c.VK_TRUE,
        };

        if (comptime builtin.mode == .Debug) std.debug.print("vulkan swapchain {any}\n", .{swapchain_create_info});

        var swapchain: c.VkSwapchainKHR = undefined;
        if (c.vkCreateSwapchainKHR(self.device.?, &swapchain_create_info, null, &swapchain) != c.VK_SUCCESS) {
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan swapchain creation failed\n", .{});
            return Error.CreateSwapchainFailed;
        }
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan swapchain created: {any}\n", .{swapchain});
        self.swapchain = swapchain;
    }

    fn get_surface_present_mode(self: *Context, allocator: std.mem.Allocator) !c.VkPresentModeKHR {
        var modes_count: u32 = 0;
        if (c.vkGetPhysicalDeviceSurfacePresentModesKHR(self.physical_device.?, self.surface.?, &modes_count, null) != c.VK_SUCCESS) {
            return Error.SurfacePresentModesCountFailed;
        }

        if (comptime builtin.mode == .Debug) std.debug.print("vulkan surface present modes count: {d}\n", .{modes_count});

        const modes = allocator.alloc(c.VkPresentModeKHR, modes_count) catch |err| {
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan could not allocate mem for surface present modes: {}\n", .{err});
            return Error.SurfacePresentModesAllocationFailed;
        };
        defer allocator.free(modes);

        if (c.vkGetPhysicalDeviceSurfacePresentModesKHR(self.physical_device.?, self.surface.?, &modes_count, @ptrCast(@alignCast(modes.ptr))) != c.VK_SUCCESS) {
            return Error.SurfacePresentModesFailed;
        }

        if (comptime builtin.mode == .Debug) {
            for (0..modes_count) |i| {
                const fmt: c.VkPresentModeKHR = modes[i];
                std.debug.print("vulkan surface present modes: {}\n", .{fmt});
            }
        }

        if (modes_count == 0) {
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan no surface present modes found\n", .{});
            return Error.SurfacePresentModesNotFound;
        }

        for (0..modes_count) |i| {
            const fmt: c.VkPresentModeKHR = modes[i];

            if (fmt == c.VK_PRESENT_MODE_MAILBOX_KHR) {
                if (comptime builtin.mode == .Debug) std.debug.print("vulkan selecting primary choice surface present mode: {d} {d}\n", .{ i, fmt });
                return fmt;
            }
        }

        for (0..modes_count) |i| {
            const fmt: c.VkPresentModeKHR = modes[i];

            if (fmt == c.VK_PRESENT_MODE_FIFO_KHR) {
                if (comptime builtin.mode == .Debug) std.debug.print("vulkan selecting secondary choice surface present mode: {d} {d}\n", .{ i, fmt });
                return fmt;
            }
        }

        if (comptime builtin.mode == .Debug) std.debug.print("vulkan falling back on first available surface present mode: {d}\n", .{modes[0]});
        return modes[0];
    }

    fn get_surface_format(self: *Context, allocator: std.mem.Allocator) !c.VkSurfaceFormatKHR {
        var formats_count: u32 = 0;
        if (c.vkGetPhysicalDeviceSurfaceFormatsKHR(self.physical_device.?, self.surface.?, &formats_count, null) != c.VK_SUCCESS) {
            return Error.SurfaceFormatsCountFailed;
        }

        if (comptime builtin.mode == .Debug) std.debug.print("vulkan surface formats count: {d}\n", .{formats_count});

        const formats = allocator.alloc(c.VkSurfaceFormatKHR, formats_count) catch |err| {
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan could not allocate mem for surface formats: {}\n", .{err});
            return Error.SurfaceFormatsAllocationFailed;
        };
        defer allocator.free(formats);

        if (c.vkGetPhysicalDeviceSurfaceFormatsKHR(self.physical_device.?, self.surface.?, &formats_count, @ptrCast(@alignCast(formats.ptr))) != c.VK_SUCCESS) {
            return Error.SurfaceFormatsFailed;
        }

        if (comptime builtin.mode == .Debug) {
            for (0..formats_count) |i| {
                const fmt: c.VkSurfaceFormatKHR = formats[i];
                std.debug.print("vulkan surface formats: {d} {d}\n", .{ fmt.format, fmt.colorSpace });
            }
        }

        if (formats_count == 0) {
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan no surface formats found\n", .{});
            return Error.SurfaceFormatsNotFound;
        }

        for (0..formats_count) |i| {
            const fmt: c.VkSurfaceFormatKHR = formats[i];

            if (fmt.format == c.VK_FORMAT_B8G8R8A8_SRGB and fmt.colorSpace == c.VK_COLOR_SPACE_SRGB_NONLINEAR_KHR) {
                if (comptime builtin.mode == .Debug) std.debug.print("vulkan selecting surface format[{d}]: {d} {d}\n", .{ i, fmt.format, fmt.colorSpace });
                return fmt;
            }
        }
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan falling back on first available surface format[0]: {d} {d}\n", .{ formats[0].format, formats[0].colorSpace });
        return formats[0];
    }

    fn get_surface_caps(self: *Context) !c.VkSurfaceCapabilitiesKHR {
        var caps: c.VkSurfaceCapabilitiesKHR = undefined;
        if (c.vkGetPhysicalDeviceSurfaceCapabilitiesKHR(self.physical_device.?, self.surface.?, &caps) != c.VK_SUCCESS) {
            return Error.SurfaceCapsFailed;
        }

        if (comptime builtin.mode == .Debug) std.debug.print("vulkan surface caps: {}\n", .{caps});
        return caps;
    }

    pub fn create_device(self: *Context, allocator: std.mem.Allocator, is_metal_surface: bool, extensions: []const [:0]const u8) !void {
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan enumerate physical devices\n", .{});
        var device_count: u32 = 0;
        if (c.vkEnumeratePhysicalDevices(self.instance, &device_count, null) != c.VK_SUCCESS) {
            return Error.EnumeratePhysicalDeviceCountsFailed;
        }

        if (comptime builtin.mode == .Debug) std.debug.print("vulkan physical device count: {d}\n", .{device_count});

        const devices = try allocator.alloc(c.VkPhysicalDevice, device_count);
        defer allocator.free(devices);

        if (c.vkEnumeratePhysicalDevices(self.instance, &device_count, devices.ptr) != c.VK_SUCCESS) {
            return Error.EnumeratePhysicalDevicesFailed;
        }

        for (0..device_count) |i| blk: {
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan physical device {d}: {?}\n", .{ i, devices[i] });

            var property_count: u32 = 0;
            c.vkGetPhysicalDeviceQueueFamilyProperties(devices[i], &property_count, null);

            if (comptime builtin.mode == .Debug) std.debug.print("vulkan physical device {d} queue family property count: {d}\n", .{ i, property_count });

            const properties = try allocator.alloc(c.VkQueueFamilyProperties, property_count);
            defer allocator.free(properties);

            c.vkGetPhysicalDeviceQueueFamilyProperties(devices[i], &property_count, properties.ptr);
            for (0..property_count) |j| {
                if (comptime builtin.mode == .Debug) std.debug.print("vulkan physical device {d} queue family property {d}: {d}, {d}\n", .{ i, j, properties[j].queueFlags, properties[j].queueCount });

                if (properties[j].queueFlags & c.VK_QUEUE_GRAPHICS_BIT == c.VK_QUEUE_GRAPHICS_BIT) {
                    if (comptime builtin.mode == .Debug) std.debug.print("vulkan acceptable physical device found: {d}\n", .{i});
                    self.physical_device = devices[i];
                    self.queue_index = @intCast(j);
                    break :blk;
                }
            }
        }

        if (self.physical_device == null) {
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan acceptable device location not found\n", .{});
            return Error.AcceptableDeviceLocationFailed;
        }

        if (comptime builtin.mode == .Debug) std.debug.print("vulkan acceptable device location found\n", .{});

        const priority: f32 = 1.0;
        const vk_queue_create_info: c.VkDeviceQueueCreateInfo = .{
            .sType = c.VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO,
            .queueFamilyIndex = self.queue_index,
            .queueCount = 1,
            .pQueuePriorities = &priority,
        };
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan device queue create info: {}\n", .{vk_queue_create_info});

        const extensions_extra_count: u32 = if (is_metal_surface) 1 else 0;
        const extensions_c_count = @as(u32, @min(extensions.len, std.math.maxInt(u32))) + extensions_extra_count;
        const extensions_c = allocator.alloc([*c]const u8, extensions_c_count) catch |err| {
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan could not allocate mem for device extensions: {}\n", .{err});
            return Error.DeviceExtensionsAllocationFailed;
        };
        defer allocator.free(extensions_c);

        for (0..extensions.len) |i| {
            extensions_c[i] = @ptrCast(@alignCast(extensions[i].ptr));
        }

        if (is_metal_surface) {
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan metal surface detected\n", .{});
            extensions_c[extensions_c_count - 1] = "VK_KHR_portability_subset";
        }

        if (comptime builtin.mode == .Debug) {
            std.debug.print("using {d} vulkan device extensions\n", .{extensions_c_count});
            for (0..extensions_c_count) |i| {
                std.debug.print("\t{s}\n", .{extensions_c[i]});
            }
        }

        const vk_create_info: c.VkDeviceCreateInfo = .{
            .sType = c.VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO,
            .pNext = null,
            .flags = 0,
            .queueCreateInfoCount = 1,
            .pQueueCreateInfos = &vk_queue_create_info,
            .enabledExtensionCount = extensions_c_count,
            .ppEnabledExtensionNames = @ptrCast(@alignCast(extensions_c.ptr)),
            .pEnabledFeatures = null,
        };
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan device create info: {}\n", .{vk_create_info});

        var device: c.VkDevice = undefined;
        if (c.vkCreateDevice(self.physical_device.?, &vk_create_info, null, &device) != c.VK_SUCCESS) {
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan create device failed\n", .{});
            return Error.CreateDeviceFailed;
        }

        self.device = device;
    }

    pub fn deinit(self: Context) void {
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan deinit context\n", .{});

        if (self.swapchain) |s| {
            c.vkDestroySwapchainKHR(self.device.?, s, null);
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan swapchain destroyed\n", .{});
        }

        if (self.surface) |s| {
            c.vkDestroySurfaceKHR(self.instance, s, null);
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan surface destroyed\n", .{});
        }

        if (self.device) |dev| {
            c.vkDestroyDevice(dev, null);
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan device destroyed\n", .{});
        }

        if (self.debug_messenger) |messenger| {
            const fn_ptr: c.PFN_vkDestroyDebugUtilsMessengerEXT = @ptrCast(c.vkGetInstanceProcAddr(self.instance, "vkDestroyDebugUtilsMessengerEXT"));
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan vkDestroyDebugUtilsMessengerEXT fn_ptr: {*}\n", .{fn_ptr});

            fn_ptr.?(self.instance, messenger, null);
            if (comptime builtin.mode == .Debug) std.debug.print("vulkan vkDestroyDebugUtilsMessengerEXT complete\n", .{});
        }
        c.vkDestroyInstance(self.instance, null);
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan vkDestroyInstance complete\n", .{});
    }
};

pub fn create_context(allocator: std.mem.Allocator, app_info: meta.Info, engine_info: meta.Info, vk_version: u32, extensions: []const [:0]const u8, layers: []const [:0]const u8) !Context {
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
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan could not allocate mem for extensions: {}\n", .{err});
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

    const layers_c_count = @as(u32, @min(layers.len, std.math.maxInt(u32)));
    const layers_c = allocator.alloc([*c]const u8, layers_c_count) catch |err| {
        if (comptime builtin.mode == .Debug) std.debug.print("vulkan could not allocation mem for layers: {}\n", .{err});
        return Error.LayersAllocationFailed;
    };
    defer allocator.free(layers_c);

    for (0..layers.len) |i| {
        layers_c[i] = @ptrCast(@alignCast(layers[i].ptr));
    }

    if (comptime builtin.mode == .Debug) {
        std.debug.print("using {d} vulkan extensions\n", .{extensions_c_count});
        for (0..extensions_c_count) |i| {
            std.debug.print("\t{s}\n", .{extensions_c[i]});
        }

        std.debug.print("using {d} vulkan layers\n", .{layers_c_count});
        for (0..layers_c_count) |i| {
            std.debug.print("\t{s}\n", .{layers_c[i]});
        }
    }

    const vk_create_info: c.VkInstanceCreateInfo = .{
        .sType = c.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
        .flags = flags,
        .pApplicationInfo = &vk_app_info,
        .enabledExtensionCount = extensions_c_count,
        .ppEnabledExtensionNames = @ptrCast(@alignCast(extensions_c.ptr)),
        .enabledLayerCount = layers_c_count,
        .ppEnabledLayerNames = @ptrCast(@alignCast(layers_c.ptr)),
    };

    if (comptime builtin.mode == .Debug) std.debug.print("vulkan instance create info created\n\t{}\n", .{vk_create_info});

    var instance: c.VkInstance = undefined;
    if (c.vkCreateInstance(&vk_create_info, null, &instance) != c.VK_SUCCESS) {
        // TODO: provide richer error messages with vkGetInstanceExtensionProperties.
        if (comptime builtin.mode == .Debug) std.debug.print("error creating vulkan instance\n", .{});
        return Error.CreateInstanceFailed;
    }

    if (comptime builtin.mode == .Debug) std.debug.print("vulkan instance created\n", .{});

    var vk_debug_messenger: ?c.VkDebugUtilsMessengerEXT = null;
    if (comptime builtin.mode == .Debug) {
        const severity = c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT | c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT | c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT | c.VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
        const message_type = c.VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT | c.VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT | c.VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT;

        vk_debug_messenger = try create_debug_messenger(instance, severity, message_type);
    }

    return Context{
        .instance = instance,
        .debug_messenger = vk_debug_messenger,
    };
}

fn create_debug_messenger(instance: c.VkInstance, severity: c.VkDebugUtilsMessageSeverityFlagBitsEXT, message_type: c.VkDebugUtilsMessageTypeFlagBitsEXT) !c.VkDebugUtilsMessengerEXT {
    const vk_create_info: c.VkDebugUtilsMessengerCreateInfoEXT = .{
        .sType = c.VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT,
        .messageSeverity = severity,
        .messageType = message_type,
        .pfnUserCallback = &vk_debug_callback,
    };

    if (comptime builtin.mode == .Debug) std.debug.print("vulkan debug_messenger create info created\n\t{}\n", .{vk_create_info});

    const fn_ptr: c.PFN_vkCreateDebugUtilsMessengerEXT = @ptrCast(c.vkGetInstanceProcAddr(instance, "vkCreateDebugUtilsMessengerEXT"));

    if (comptime builtin.mode == .Debug) std.debug.print("vulkan vkCreateDebugUtilsMessengerEXT fn_ptr: {*}\n", .{fn_ptr});

    var messenger: c.VkDebugUtilsMessengerEXT = undefined;
    if (fn_ptr.?(
        instance,
        &vk_create_info,
        null,
        &messenger,
    ) != c.VK_SUCCESS) {
        if (comptime builtin.mode == .Debug) std.debug.print("error creating vulkan debug messenger\n", .{});
        return Error.CreateDebugMessengerFailed;
    }

    if (comptime builtin.mode == .Debug) std.debug.print("vulkan vkCreateDebugUtilsMessengerEXT complete\n", .{});

    return messenger;
}

fn vk_debug_callback(
    severity: c.VkDebugUtilsMessageSeverityFlagBitsEXT,
    message_type: c.VkDebugUtilsMessageTypeFlagsEXT,
    callback_data: ?*const c.VkDebugUtilsMessengerCallbackDataEXT,
    user_data: ?*anyopaque,
) callconv(.c) c.VkBool32 {
    if (comptime builtin.mode == .Debug) std.debug.print("vulkan debug: {d} {d} {s} {?}\n", .{ severity, message_type, callback_data.?.pMessage, user_data });
    return c.VK_FALSE;
}
