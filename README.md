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
configuring 3 vulkan extensions
	VK_KHR_surface
	VK_EXT_metal_surface
	VK_KHR_portability_enumeration
vulkan app info created
	.{ .sType = 0, .pNext = null, .pApplicationName = u8@10260e47b, .applicationVersion = 1, .pEngineName = u8@10260e47b, .engineVersion = 1, .apiVersion = 4210688 }
vulkan extensions converted from zig to c format
vulkan instance create info created
	.{ .sType = 1, .pNext = null, .flags = 1, .pApplicationInfo = cimport.struct_VkApplicationInfo@16d936740, .enabledLayerCount = 0, .ppEnabledLayerNames = [*c]const u8@0, .enabledExtensionCount = 3, .ppEnabledExtensionNames = [*c]const u8@116520000 }
vulkan instance created
```
