pub fn main() !void {
    var num_safe: u32 = 0;
    var reports = std.mem.tokenizeScalar(u8, input, '\n');
    rpt: while (reports.next()) |report| {
        var levels = std.mem.tokenizeScalar(u8, report, ' ');
        var last: i32 = try std.fmt.parseInt(i32, levels.next().?, 10);
        var dir: ?Direction = null;
        while (levels.next()) |level_str| {
            const level = try std.fmt.parseInt(i32, level_str, 10);
            if (@abs(level - last) > 3 or level == last) {
                continue :rpt;
            }

            if (dir) |_| {
                const tmp_dir: Direction = if (level > last) .increasing else .decreasing;
                if (tmp_dir != dir) {
                    continue :rpt;
                }
            } else {
                dir = if (level > last) .increasing else .decreasing;
            }

            last = level;
        }

        num_safe += 1;
    }

    std.debug.print("{d}\n", .{num_safe});
}

const std = @import("std");
const input = @embedFile("day2.txt");

const Direction = enum {
    increasing,
    decreasing,
};
