pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const allocator = gpa.allocator();

    var nums_a = std.ArrayList(i32).init(allocator);
    var nums_b = std.ArrayList(i32).init(allocator);
    defer {
        nums_a.deinit();
        nums_b.deinit();
    }

    var lines = std.mem.tokenizeScalar(u8, input, '\n');
    while (lines.next()) |line| {
        var nums = std.mem.tokenizeScalar(u8, line, ' ');
        const a = try std.fmt.parseInt(i32, nums.next() orelse @panic("invalid input"), 10);
        const b = try std.fmt.parseInt(i32, nums.next() orelse @panic("invalid input"), 10);

        try nums_a.append(a);
        try nums_b.append(b);
    }

    std.mem.sort(i32, nums_a.items, {}, cmp);
    std.mem.sort(i32, nums_b.items, {}, cmp);

    var acc: u32 = 0;
    for (nums_a.items, nums_b.items) |a, b| {
        acc += @abs(a - b);
    }

    std.debug.print("{d}\n", .{acc});
}

fn cmp(ctx: void, rhs: i32, lhs: i32) bool {
    _ = ctx;

    return rhs < lhs;
}

const std = @import("std");
const input = @embedFile("day1.txt");
