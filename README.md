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

Add the following to your shell:

```
export VK_LAYER_PATH="$(brew --prefix)/share/vulkan/explicit_layer.d"
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
	.{ .sType = 0, .pNext = null, .pApplicationName = u8@105123359, .applicationVersion = 1, .pEngineName = u8@105123359, .engineVersion = 1, .apiVersion = 4210688 }
vulkan metal surface detected
using 4 vulkan extensions
	VK_KHR_surface
	VK_EXT_metal_surface
	VK_EXT_debug_utils
	VK_KHR_portability_enumeration
using 1 vulkan layers
	VK_LAYER_KHRONOS_validation
vulkan instance create info created
	.{ .sType = 1, .pNext = null, .flags = 1, .pApplicationInfo = cimport.struct_VkApplicationInfo@16ae2e2c0, .enabledLayerCount = 1, .ppEnabledLayerNames = [*c]const u8@1190c0000, .enabledExtensionCount = 4, .ppEnabledExtensionNames = [*c]const u8@117900000 }
vulkan instance created
vulkan debug_messenger create info created
	.{ .sType = 1000128004, .pNext = null, .flags = 0, .messageSeverity = 4369, .messageType = 7, .pfnUserCallback = fn (c_uint, u32, [*c]const cimport.struct_VkDebugUtilsMessengerCallbackDataEXT, ?*anyopaque) callconv(.c) u32@1050dbb34, .pUserData = null }
vulkan vkCreateDebugUtilsMessengerEXT fn_ptr: *const fn (?*cimport.struct_VkInstance_T, [*c]const cimport.struct_VkDebugUtilsMessengerCreateInfoEXT, [*c]const cimport.struct_VkAllocationCallbacks, [*c]?*cimport.struct_VkDebugUtilsMessengerEXT_T) callconv(.c) c_int@10534730c
vulkan vkCreateDebugUtilsMessengerEXT complete
vulkan enumerate physical devices
vulkan physical device count: 1
vulkan physical device 0: cimport.struct_VkPhysicalDevice_T@b838004a0
vulkan physical device 0 queue family property count: 4
vulkan physical device 0 queue family property 0: 7, 1
vulkan acceptable physical device found: 0
vulkan acceptable device location found
vulkan device queue create info: .{ .sType = 2, .pNext = null, .flags = 0, .queueFamilyIndex = 0, .queueCount = 1, .pQueuePriorities = f32@10511d484 }
vulkan metal surface detected
using 1 vulkan device extensions
	VK_KHR_portability_subset
vulkan device create info: .{ .sType = 3, .pNext = null, .flags = 0, .queueCreateInfoCount = 1, .pQueueCreateInfos = cimport.struct_VkDeviceQueueCreateInfo@16ae2e3f8, .enabledLayerCount = 0, .ppEnabledLayerNames = [*c]const u8@0, .enabledExtensionCount = 1, .ppEnabledExtensionNames = [*c]const u8@1190c0008, .pEnabledFeatures = cimport.struct_VkPhysicalDeviceFeatures@0 }
vulkan debug: 16 1 Inserted device layer "VK_LAYER_KHRONOS_validation" (/opt/homebrew/Cellar/vulkan-validationlayers/1.4.350.0/lib/libVkLayer_khronos_validation.dylib) null
vulkan debug: 16 1 vkCreateDevice layer callstack setup to: null
vulkan debug: 16 1    <Application> null
vulkan debug: 16 1      || null
vulkan debug: 16 1    <Loader> null
vulkan debug: 16 1      || null
vulkan debug: 16 1    VK_LAYER_KHRONOS_validation null
vulkan debug: 16 1            Type: Explicit null
vulkan debug: 16 1            Enabled By: By the Application null
vulkan debug: 16 1            Manifest: /opt/homebrew/share/vulkan/explicit_layer.d/VkLayer_khronos_validation.json null
vulkan debug: 16 1            Library:  /opt/homebrew/Cellar/vulkan-validationlayers/1.4.350.0/lib/libVkLayer_khronos_validation.dylib null
vulkan debug: 16 1      || null
vulkan debug: 16 1    <Device> null
vulkan debug: 16 1        Using "Apple M1" with driver: "/opt/homebrew/Cellar/molten-vk/1.4.1/lib/libMoltenVK.dylib" null
vulkan debug: 16 1 Vulkan semaphores using MTLEvent. null
vulkan debug: 16 1 Descriptor sets binding resources using Metal3 argument buffers. null
vulkan debug: 16 1 Created VkDevice to run on GPU Apple M1 with the following 1 Vulkan extensions enabled:
	VK_KHR_portability_subset v1 null
glfw created vulkan surface
vulkan deinit context
vulkan surface destroyed
vulkan debug: 16 1 Destroyed VkDevice on GPU Apple M1 with 1 Vulkan extensions enabled. null
vulkan device destroyed
vulkan vkDestroyDebugUtilsMessengerEXT fn_ptr: *const fn (?*cimport.struct_VkInstance_T, ?*cimport.struct_VkDebugUtilsMessengerEXT_T, [*c]const cimport.struct_VkAllocationCallbacks) callconv(.c) void@1053477c8
vulkan vkDestroyDebugUtilsMessengerEXT complete
vulkan vkDestroyInstance complete
```
