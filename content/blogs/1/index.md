---
{
  "title": "Zig SIMD",
  "date": "2024-02-06T11:37:00",
  "author": "David Rubin",
  "draft": false,
  "layout": "blog/page.html",
  "tags": [ "simd", "optimizing", "zig" ]
}  
--- 


# This is a test
---

<br>

```zig
const std = @import("std");
const zine = @import("zine");

pub fn build(b: *std.Build) !void {
    try zine.addWebsite(b, .{
        .layouts_dir_path = "layouts",
        .content_dir_path = "content",
        .static_dir_path = "static",
        .site = .{
            .base_url = "https://blog.vortan.dev",
            .title = "Sinon's Blog",
        },
    });
}
```
