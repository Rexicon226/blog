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

    const target = b.resolveTargetQuery(.{});
    const optimize = b.standardOptimizeOption(.{});

    const new_post_tool = b.addExecutable(.{
        .name = "new_post",
        .root_source_file = .{ .path = "tools/new_post.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(new_post_tool);

    const new_post_options = b.addOptions();
    new_post_options.addOption([]const u8, "content_path", b.pathFromRoot("content/"));
    new_post_tool.root_module.addOptions("options", new_post_options);

    const new_post_step = b.step("add-post", "Adds a new post");

    const new_post_run = b.addRunArtifact(new_post_tool);
    new_post_step.dependOn(&new_post_run.step);
}
