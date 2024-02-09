//! Creates a new post!

const std = @import("std");
const Allocator = std.mem.Allocator;

const options = @import("options");

const UserData = struct {
    post_name: []const u8,
    author_name: []const u8,
    date_string: []const u8,

    // Why did I go so over the top?
    // Because I felt like it :p
    /// null before resolved
    lazy_index: ?u32 = null,
};

var gpa_inst = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_inst.allocator();

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.writeAll("Input post name:\n");
    const post_name = try getInput(gpa);

    try stdout.writeAll("Input author name:\n");
    const author_name = try getInput(gpa);

    // Generate the Data (YYYY-MM-DDTHH:MM:SS)
    const date_string = try getDate(gpa);
    std.debug.print("Date String: {s}\n", .{date_string});

    var data: UserData = .{
        .author_name = author_name,
        .post_name = post_name,
        .date_string = date_string,
    };

    try resolvePostIndex(&data);
    try generateNewPost(data, gpa);
}

fn getInput(allocator: Allocator) ![]const u8 {
    const stdin = std.io.getStdIn().reader();
    return stdin.readUntilDelimiterAlloc(allocator, '\n', 100 * 1024);
}

/// Returns an iso8601 format string of the current time.
/// `(YYYY-MM-DDTHH:MM:SS)`
fn getDate(allocator: Allocator) ![]const u8 {
    var timestamp = std.time.timestamp();

    const seconds: u32 = @intCast(@rem(timestamp, 60));
    timestamp = @divFloor(timestamp, 60);
    const minutes: u32 = @intCast(@rem(timestamp, 60));
    timestamp = @divFloor(timestamp, 60);
    const hours: u32 = @intCast(@rem(timestamp, 24));
    timestamp = @divFloor(timestamp, 24);

    var days = timestamp;

    // Adjust for leap years.
    var year: u32 = 1970;
    year: while (true) {
        const daysInYear: u32 = if (year % 4 == 0 and (year % 100 != 0 or year % 400 == 0)) 366 else 365;
        if (days >= daysInYear) {
            days -= daysInYear;
            year += 1;
        } else break :year;
    }

    var month: u32 = 0;
    var day: u32 = @intCast(days + 1); // This is because Jan 1st, 1970 is day 1.
    for (0..12) |i| {
        const daysInCurrentMonth = if (i == 1 and (year % 4 == 0 and (year % 100 != 0 or year % 400 == 0))) 29 else daysInMonth[i];
        if (day <= daysInCurrentMonth) {
            month = @intCast(i + 1);
            break;
        } else {
            day -= daysInCurrentMonth;
        }
    }

    return std.fmt.allocPrint(
        allocator,
        "{d}-{:0>2}-{d:0>2}T{:0>2}:{:0>2}:{:0>2}",
        .{ year, month, day, hours, minutes, seconds },
    );
}

const daysInMonth: [12]u8 = .{ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };

fn resolvePostIndex(data: *UserData) !void {
    // First we want to figure out what is the next index.
    // Probably easiest way is to run `ls content

    // maybe make this cross-platform for whatever reason, no use i think
    const dir = try std.fs.openDirAbsolute(options.content_path, .{ .iterate = true });
    var iter = dir.iterate();

    var index: u32 = 0;
    while (try iter.next()) |item| {
        if (item.kind == .directory) {
            index += 1;
        }
    }

    // New post will be at index + 1
    index += 1;

    // Resolved.
    data.lazy_index = index;
}

fn generateNewPost(data: UserData, allocator: Allocator) !void {
    const resolved_index = data.lazy_index orelse @panic("didn't resolve index");

    // Target path.
    const post_dir = try std.fmt.allocPrint(
        allocator,
        "{s}/{d}",
        .{ options.content_path, resolved_index },
    );

    const post_path = try std.fmt.allocPrint(
        allocator,
        "{s}/index.md",
        .{post_dir},
    );

    std.debug.print("Creating Post at: {s}\n", .{post_dir});

    const index_content: []const u8 = try std.fmt.allocPrint(
        allocator,
        \\---
        \\{{
        \\  "title": "{s}",
        \\  "date": "{s}",
        \\  "author": "{s}",
        \\  "draft": true,
        \\  "layout": "blog/page.html",
        \\  "tags": []
        \\}}
        \\---
        \\Hello World! This is a new blog post.
        \\
    ,
        .{
            data.post_name,
            data.date_string,
            data.author_name,
        },
    );

    try std.fs.makeDirAbsolute(post_dir);
    const index_file = try std.fs.createFileAbsolute(post_path, .{});
    try index_file.writeAll(index_content);
    index_file.close();

    // Now we need to add this post to the index in content/index.md
    const main_index_path = try std.fmt.allocPrint(
        allocator,
        "{s}/index.md",
        .{options.content_path},
    );
    const main_index = try std.fs.openFileAbsolute(
        main_index_path,
        .{ .mode = .write_only },
    );

    const slug = try std.fmt.allocPrint(
        allocator,
        "## [{s}]({d}/)\n",
        .{ data.post_name, resolved_index },
    );

    // Seek to the end.
    try main_index.seekTo((try main_index.stat()).size);

    try main_index.writeAll(slug);

    main_index.close();
}
