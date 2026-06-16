# Zig Vulkan Triangle

A simple app intended to help me learn how [Zig](https://ziglang.org/) and [Vulkan](https://www.vulkan.org/) work.

Currently only supports macOS, with Linux and Windows support comming soon.

## Setup

### macOS

Runtime dependencies:

```shell
brew install glfw vulkan-loader
```

Development dependencies:

```shell
brew install vulkan-headers vulkan-validationlayers vulkan-tools glslang
```

### Build & Run

```
zig build
./zig-out/bin/vulkan_triangle
glfw initialized
glfw reports vulkan supported
glfw window created
glfw extensions received
vulkan app info created
	.{ .sType = 0, .pNext = null, .pApplicationName = u8@1286452, .applicationVersion = 1, .pEngineName = u8@1286452, .engineVersion = 1, .apiVersion = 4210688 }
using 3 vulkan extensions
	VK_KHR_surface
	VK_KHR_xcb_surface
	VK_EXT_debug_utils
using 1 vulkan layers
	VK_LAYER_KHRONOS_validation
vulkan instance create info created
	.{ .sType = 1, .pNext = null, .flags = 0, .pApplicationInfo = cimport.struct_VkApplicationInfo@7ffcce390d28, .enabledLayerCount = 1, .ppEnabledLayerNames = [*c]const u8@7f0e622c0000, .enabledExtensionCount = 3, .ppEnabledExtensionNames = [*c]const u8@7f0e622e0000 }
vulkan instance created
vulkan debug_messenger create info created
	.{ .sType = 1000128004, .pNext = null, .flags = 0, .messageSeverity = 4369, .messageType = 7, .pfnUserCallback = fn (c_uint, u32, [*c]const cimport.struct_VkDebugUtilsMessengerCallbackDataEXT, ?*anyopaque) callconv(.c) u32@11d6890, .pUserData = null }
vulkan vkCreateDebugUtilsMessengerEXT fn_ptr: *const fn (?*cimport.struct_VkInstance_T, [*c]const cimport.struct_VkDebugUtilsMessengerCreateInfoEXT, [*c]const cimport.struct_VkAllocationCallbacks, [*c]?*cimport.struct_VkDebugUtilsMessengerEXT_T) callconv(.c) c_int@7f0e8c5723e0
vulkan vkCreateDebugUtilsMessengerEXT complete
vulkan deinit context
vulkan vkDestroyDebugUtilsMessengerEXT fn_ptr: *const fn (?*cimport.struct_VkInstance_T, ?*cimport.struct_VkDebugUtilsMessengerEXT_T, [*c]const cimport.struct_VkAllocationCallbacks) callconv(.c) void@7f0e8c5725c0
vulkan vkDestroyDebugUtilsMessengerEXT complete
vulkan vkDestroyInstance complete
```
