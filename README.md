# Zig Vulkan Triangle

A simple app intended to help me learn [Zig](https://ziglang.org/) and [Vulkan](https://www.vulkan.org/).

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
	.{ .sType = 0, .pNext = null, .pApplicationName = u8@12c29ca, .applicationVersion = 1, .pEngineName = u8@12c29ca, .engineVersion = 1, .apiVersion = 4210688 }
using 3 vulkan extensions
	VK_KHR_surface
	VK_KHR_xcb_surface
	VK_EXT_debug_utils
using 1 vulkan layers
	VK_LAYER_KHRONOS_validation
vulkan instance create info created
	.{ .sType = 1, .pNext = null, .flags = 0, .pApplicationInfo = cimport.struct_VkApplicationInfo@7ffceb829f48, .enabledLayerCount = 1, .ppEnabledLayerNames = [*c]const u8@7f5dca6c0000, .enabledExtensionCount = 3, .ppEnabledExtensionNames = [*c]const u8@7f5dca6e0000 }
vulkan instance created
vulkan debug_messenger create info created
	.{ .sType = 1000128004, .pNext = null, .flags = 0, .messageSeverity = 4369, .messageType = 7, .pfnUserCallback = fn (c_uint, u32, [*c]const cimport.struct_VkDebugUtilsMessengerCallbackDataEXT, ?*anyopaque) callconv(.c) u32@12119d0, .pUserData = null }
vulkan vkCreateDebugUtilsMessengerEXT fn_ptr: *const fn (?*cimport.struct_VkInstance_T, [*c]const cimport.struct_VkDebugUtilsMessengerCreateInfoEXT, [*c]const cimport.struct_VkAllocationCallbacks, [*c]?*cimport.struct_VkDebugUtilsMessengerEXT_T) callconv(.c) c_int@7f5df49ab3e0
vulkan vkCreateDebugUtilsMessengerEXT complete
vulkan enumerate physical devices
vulkan debug: 16 1 linux_read_sorted_physical_devices: null
vulkan debug: 16 1      Original order: null
vulkan debug: 16 1            [0] NVIDIA GeForce RTX 4070 SUPER null
vulkan debug: 16 1            [1] llvmpipe (LLVM 22.1.5, 256 bits) null
vulkan debug: 16 1      Sorted order: null
vulkan debug: 16 1            [0] NVIDIA GeForce RTX 4070 SUPER   null
vulkan debug: 16 1            [1] llvmpipe (LLVM 22.1.5, 256 bits)   null
vulkan debug: 1 1 Copying old device 0 into new device 0 null
vulkan debug: 1 1 Copying old device 1 into new device 1 null
vulkan debug: 16 1 linux_read_sorted_physical_devices: null
vulkan debug: 16 1      Original order: null
vulkan debug: 16 1            [0] NVIDIA GeForce RTX 4070 SUPER null
vulkan debug: 16 1            [1] llvmpipe (LLVM 22.1.5, 256 bits) null
vulkan debug: 16 1      Sorted order: null
vulkan debug: 16 1            [0] NVIDIA GeForce RTX 4070 SUPER   null
vulkan debug: 16 1            [1] llvmpipe (LLVM 22.1.5, 256 bits)   null
vulkan debug: 1 1 Copying old device 0 into new device 0 null
vulkan debug: 1 1 Copying old device 1 into new device 1 null
vulkan physical device count: 2
vulkan debug: 16 1 linux_read_sorted_physical_devices: null
vulkan debug: 16 1      Original order: null
vulkan debug: 16 1            [0] NVIDIA GeForce RTX 4070 SUPER null
vulkan debug: 16 1            [1] llvmpipe (LLVM 22.1.5, 256 bits) null
vulkan debug: 16 1      Sorted order: null
vulkan debug: 16 1            [0] NVIDIA GeForce RTX 4070 SUPER   null
vulkan debug: 16 1            [1] llvmpipe (LLVM 22.1.5, 256 bits)   null
vulkan debug: 1 1 Copying old device 0 into new device 0 null
vulkan debug: 1 1 Copying old device 1 into new device 1 null
vulkan debug: 16 1 linux_read_sorted_physical_devices: null
vulkan debug: 16 1      Original order: null
vulkan debug: 16 1            [0] NVIDIA GeForce RTX 4070 SUPER null
vulkan debug: 16 1            [1] llvmpipe (LLVM 22.1.5, 256 bits) null
vulkan debug: 16 1      Sorted order: null
vulkan debug: 16 1            [0] NVIDIA GeForce RTX 4070 SUPER   null
vulkan debug: 16 1            [1] llvmpipe (LLVM 22.1.5, 256 bits)   null
vulkan debug: 1 1 Copying old device 0 into new device 0 null
vulkan debug: 1 1 Copying old device 1 into new device 1 null
vulkan debug: 16 1 Removing driver /usr/lib64/libvulkan_virtio.so due to not having any physical devices null
vulkan debug: 16 1 Removing driver /usr/lib64/libvulkan_radeon.so due to not having any physical devices null
vulkan debug: 16 1 Removing driver /usr/lib64/libvulkan_powervr_mesa.so due to not having any physical devices null
vulkan debug: 16 1 Removing driver /usr/lib64/libvulkan_panfrost.so due to not having any physical devices null
vulkan debug: 16 1 Removing driver /usr/lib64/libvulkan_nouveau.so due to not having any physical devices null
vulkan debug: 16 1 Removing driver /usr/lib64/libvulkan_intel.so due to not having any physical devices null
vulkan debug: 16 1 Removing driver /usr/lib64/libvulkan_intel_hasvk.so due to not having any physical devices null
vulkan debug: 16 1 Removing driver /usr/lib64/libvulkan_freedreno.so due to not having any physical devices null
vulkan debug: 16 1 Removing driver /usr/lib64/libvulkan_broadcom.so due to not having any physical devices null
vulkan debug: 16 1 Removing driver /usr/lib64/libvulkan_asahi.so due to not having any physical devices null
vulkan physical device 0: cimport.struct_VkPhysicalDevice_T@2c90e100
vulkan physical device 0 queue family property count: 6
vulkan physical device 0 queue family property 0: 15, 16
vulkan acceptable physical device found: 0
vulkan acceptable device location found
vulkan device queue create info: .{ .sType = 2, .pNext = null, .flags = 0, .queueFamilyIndex = 0, .queueCount = 1, .pQueuePriorities = f32@12c2728 }
using 1 vulkan device extensions
	VK_KHR_swapchain
vulkan device create info: .{ .sType = 3, .pNext = null, .flags = 0, .queueCreateInfoCount = 1, .pQueueCreateInfos = cimport.struct_VkDeviceQueueCreateInfo@7ffceb82a360, .enabledLayerCount = 0, .ppEnabledLayerNames = [*c]const u8@0, .enabledExtensionCount = 1, .ppEnabledExtensionNames = [*c]const u8@7f5dca660000, .pEnabledFeatures = cimport.struct_VkPhysicalDeviceFeatures@0 }
vulkan debug: 16 1 Inserted device layer "VK_LAYER_KHRONOS_validation" (/usr/lib64/libVkLayer_khronos_validation.so) null
vulkan debug: 16 1 Failed to find vkGetDeviceProcAddr in layer "/usr/lib64/libVkLayer_MESA_device_select.so" null
vulkan debug: 16 1 vkCreateDevice layer callstack setup to: null
vulkan debug: 16 1    <Application> null
vulkan debug: 16 1      || null
vulkan debug: 16 1    <Loader> null
vulkan debug: 16 1      || null
vulkan debug: 16 1    VK_LAYER_KHRONOS_validation null
vulkan debug: 16 1            Type: Explicit null
vulkan debug: 16 1            Enabled By: By the Application null
vulkan debug: 16 1            Manifest: /usr/share/vulkan/explicit_layer.d/VkLayer_khronos_validation.json null
vulkan debug: 16 1            Library:  /usr/lib64/libVkLayer_khronos_validation.so null
vulkan debug: 16 1      || null
vulkan debug: 16 1    <Device> null
vulkan debug: 16 1        Using "NVIDIA GeForce RTX 4070 SUPER" with driver: "/usr/lib64/libGLX_nvidia.so.595.80" null
glfw created vulkan surface
vulkan create swap chain
vulkan surface caps: .{ .minImageCount = 3, .maxImageCount = 8, .currentExtent = .{ .width = 640, .height = 480 }, .minImageExtent = .{ .width = 640, .height = 480 }, .maxImageExtent = .{ .width = 640, .height = 480 }, .maxImageArrayLayers = 1, .supportedTransforms = 1, .currentTransform = 1, .supportedCompositeAlpha = 1, .supportedUsageFlags = 159 }
vulkan surface caps .{ .minImageCount = 3, .maxImageCount = 8, .currentExtent = .{ .width = 640, .height = 480 }, .minImageExtent = .{ .width = 640, .height = 480 }, .maxImageExtent = .{ .width = 640, .height = 480 }, .maxImageArrayLayers = 1, .supportedTransforms = 1, .currentTransform = 1, .supportedCompositeAlpha = 1, .supportedUsageFlags = 159 }
vulkan surface formats count: 2
vulkan surface formats: 44 0
vulkan surface formats: 50 0
vulkan selecting surface format[1]: 50 0
vulkan surface format .{ .format = 50, .colorSpace = 0 }
vulkan surface present modes count: 4
vulkan surface present modes: 2
vulkan surface present modes: 3
vulkan surface present modes: 0
vulkan surface present modes: 1000361000
vulkan selecting secondary choice surface present mode: 0 2
vulkan surface present mode 2
vulkan swapchain .{ .sType = 1000001000, .pNext = null, .flags = 0, .surface = cimport.struct_VkSurfaceKHR_T@20000000002, .minImageCount = 3, .imageFormat = 50, .imageColorSpace = 0, .imageExtent = .{ .width = 640, .height = 480 }, .imageArrayLayers = 1, .imageUsage = 16, .imageSharingMode = 0, .queueFamilyIndexCount = 0, .pQueueFamilyIndices = u32@0, .preTransform = 1, .compositeAlpha = 1, .presentMode = 2, .clipped = 1, .oldSwapchain = null }
vulkan swapchain created: cimport.struct_VkSwapchainKHR_T@30000000003
vulkan swapchain images 3
vulkan swapchain images found: 3
vulkan deinit context
vulkan swapchain destroyed
vulkan surface destroyed
vulkan device destroyed
vulkan vkDestroyDebugUtilsMessengerEXT fn_ptr: *const fn (?*cimport.struct_VkInstance_T, ?*cimport.struct_VkDebugUtilsMessengerEXT_T, [*c]const cimport.struct_VkAllocationCallbacks) callconv(.c) void@7f5df49ab5c0
vulkan vkDestroyDebugUtilsMessengerEXT complete
vulkan vkDestroyInstance complete
```
