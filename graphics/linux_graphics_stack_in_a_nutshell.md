# The Linux Graphics Stack in a Nutshell

## Graphics used to be done with X11

- Linux graphics stack was originally built around X11

- X server was a single monolithic userspace program that handlled all output. X clients (i.e. applications) sent drawing commands to the X server

- Network transparent, but includes a certain lag

- Even worse: 3D graphics hardware requires locality to keep pipeline saturated

## Buffer sharing improves performance

- With the **Direct Rendering Infrastructure (DRI)** buffers in video memory can be shared between X client and X server

- **DRI** consists of a number of components: including the kernels's **Direct Rendering Manager (DRM)**

- X11 had to drop support for network transparency (at least if performance was a concern)

- X client renders into shared buffer; X server displays the buffer

- Multiple X clients can shared the same hardware

## Video memory is the central resource

- Clients render into video memory

- Discrete video memory is located on the graphics device, available via PCI BAR

- **Graphics Address Remapping Table (GART)** extends discrete memory

- **DMA** memory is usually used by SoC designs

- System memory (with GPUs)

## Graphics drivers manage video memory

- Kernel's **Direct Rendering Manager (DRM)** provides helpers for common use cases: **Transiation Table Manager (TTM)** for **VRAM** and **GART**, **DMA** helpers, **SHMEM** helpers for system memory

- Kernel graphics drivers implement memory management

- The **Graphics Execution Manager (GEM)** provides the interface to memory buffers

- **GEM** buffer object is the central data structure

## Buffer creation depends on the graphics driver

- **GEN** provides common buffer operations, such as pining, mmapping, releasing

- Except for buffer creation

- Driver ioctls for hardware accelerated rendering

- Buffer objects tied to hardware features

- Dumb-buffer interface for plain software rendering via `mmap()` and `memcpy()`

- Dumb buffers good enough for basic user space or the kernel console

## Userspace libraries provide rendering

- Rendering implemented in user space

- **Mesa** library provides 3D graphics driver for each support chipset

- **Mesa** also implements common software rending interfaces such as **OpenGL**, **OpenGLES**, **Vulkan**

- **Mesa** translates interfaces into nternal state trackers(Gallium) and shader IR(NIR)

- **Mesa** drivers translate and forward to hardware via **DRM** kernel drivers

- Data resides in **GEM** buffer objects

## The Wayland protocol enables compositing

- Modern compositors and their clients use the **Wayland protocol**

- The compositor also uses software rendering interfaces to render screen output

- Applications window is a rectangle textured with the application's output buffer

- The application's output buffer became an input buffer for the compositor

- Wayland is only for local clients, no more network transparency

## Plain shared memory can be enough

- Client creates a file descriptor for shared memory and transfers it to the compositors

- Both **mmap** the memory pages

- The client renders into the buffer, then sends a damage message to the compositor

- The compositor updates the on-screen window on each damage message

- Weak synchronization makes it only feasible with software rendering

## Linux's dma-buf enables high-performance rendering

- Client creates a **GEM object buffer** that support hardware-accelerated rendering

- Driver-specific buffer-object creation is required to do this

- Client and compositor export/import **GEM object buffers** via kernel's dma-buf framework

- Both share the same pages within video memory

## Fencing synchronizes client and compositor

- Each **dma-buf object** comes with a **dma-buf** reservation lock for syncrhronization within kernel

- Clients send rendering commands to the hardware (via **Mesa**) and a damage message to the compositor (via **Wayland**)

- Compositors renders screen

- **DRM** kernel drivers implement fencing on top of **dma-buf** reservation lock, so that the client's job has been completed when the compositor's job starts

- **DRM** scheduler dependencies

## Video decoding works the same

- Client decodes video with available software or hardware

- Various interfaces available, such as VA-API, VDPAU, maybe Vulkan Video, plenty of higher-level decoders

- Transfer resulting video fram to compositor as with rendered output

- Linux kernel's media subsystem also uses **dma-buf**; can synchronize with **DRM** rendering

- Video is typically in **YUV** format

## DRM kernel drivers implement the modesetting pipeline

- Compositor attaches its output buffer object to **DRM framebuffer**, which gives it a color format and a resolution

- Compositor implements modesetting and page flips

- Instructs **DRM** driver to set a display mode and display the framebuffer's content

- **DRM** provides individual statges of the modesetting pipeline, such as planes, CRTCs, encoders, connectors

## Encoder and connector represent the output

- Encoder transforms the display signal

- Connector represents the physical connector and attached screen

- Connector also reads EDID information from attached monitor and returns display modes

## All pipeline changes are atomic

- Complex pipelines might push hardware beyond limits

- Limited video memory or number of planes can be a problem

- Modesetting fail in an intermediate state

- Atomic modesetting implements check/commit procedure for every change

- Atomic commit is all-or-nothing

## There's more

- Kernel's framebuffer console is on in-kernel client that is being shown while no userspace has opened the device file

- **DRM** leases allow temporary handover of modesetting capabilities to other programs; used for 3D headsets

- Compositors implement network support independently from **Wayland**, via **RDP**

- **Xwayland** implements **X11** on top of **Wayland**

- The Linux kernel's new accelerator subsystem build on top of **DRM**; think of "rendering without graphics output"
