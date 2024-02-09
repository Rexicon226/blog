---
{
  "title": "Applying SIMD in the Zig standard library",
  "date": "2024-02-06T11:37:00",
  "author": "David Rubin",
  "draft": false,
  "layout": "page.html",
  "tags": [ "simd", "optimizing", "zig" ]
}  
--- 

# This is a test
---

<br>

```zig
// main.zig
const std = @import("std");

pub fn main() !void {
    std.debug.print("Hello World!", .{});
}
```
