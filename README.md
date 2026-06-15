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
	.{ .sType = 0, .pNext = null, .pApplicationName = u8@100f6e870, .applicationVersion = 1, .pEngineName = u8@100f6e870, .engineVersion = 1, .apiVersion = 4210688 }
vulkan metal surface detected
using 4 vulkan extensions
	VK_KHR_surface
	VK_EXT_metal_surface
	VK_EXT_debug_utils
	VK_KHR_portability_enumeration
vulkan instance create info created
	.{ .sType = 1, .pNext = null, .flags = 1, .pApplicationInfo = cimport.struct_VkApplicationInfo@16efd6760, .enabledLayerCount = 0, .ppEnabledLayerNames = [*c]const u8@0, .enabledExtensionCount = 4, .ppEnabledExtensionNames = [*c]const u8@114e40000 }
vulkan instance created
```
