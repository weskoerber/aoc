const ParseState = enum {
    instruction_start,
    op1_start,
    op1,
    op2_start,
    op2,
};
pub fn main() !void {
    const result = try calculate(input);
    std.debug.print("{d}\n", .{result});
}

fn calculate(str: []const u8) !i32 {
    var acc: i32 = 0;

    var ipos: usize = 0;
    var op1_start: usize = 0;
    var op1_end: usize = 0;
    var op2_start: usize = 0;
    var op2_end: usize = 0;

    var state: ParseState = .instruction_start;

    var i: usize = 0;
    var enabled = true;
    while (i < str.len) : (i += 1) {
        const c = str[i];

        switch (state) {
            .instruction_start => {
                if (str.len > i + 7 and std.mem.eql(u8, "don't()", str[i .. i + 7])) {
                    enabled = false;
                    i = i + 6;
                } else if (str.len > i + 4 and std.mem.eql(u8, "do()", str[i .. i + 4])) {
                    enabled = true;
                    i = i + 3;
                }

                if (enabled and str.len > i + 4 and std.mem.eql(u8, "mul(", str[i .. i + 4])) {
                    ipos = i;
                    i = i + 3;
                    state = .op1_start;
                }
            },
            .op1_start => {
                if (std.ascii.isDigit(c)) {
                    op1_start = i;
                    state = .op1;
                } else {
                    state = .instruction_start;
                }
            },
            .op1 => {
                if (i - op1_start > 3) {
                    state = .instruction_start;
                } else if (c == ',') {
                    op1_end = i;
                    state = .op2_start;
                } else if (!std.ascii.isDigit(c)) {
                    state = .instruction_start;
                }
            },
            .op2_start => {
                if (std.ascii.isDigit(c)) {
                    op2_start = i;
                    state = .op2;
                } else {
                    state = .instruction_start;
                }
            },
            .op2 => {
                if (i - op2_start > 3) {
                    state = .instruction_start;
                } else if (c == ')') {
                    op2_end = i;
                    state = .instruction_start;

                    const op1 = try std.fmt.parseInt(i32, str[op1_start..op1_end], 10);
                    const op2 = try std.fmt.parseInt(i32, str[op2_start..op2_end], 10);

                    if (enabled) {
                        acc += op1 * op2;
                    }

                    std.debug.print("({s}) {d} * {d} = {d} ({d})\n", .{ if (enabled) "enabled" else "disabled", op1, op2, op1 * op2, acc });
                } else if (!std.ascii.isDigit(c)) {
                    state = .instruction_start;
                }
            },
        }
    }

    return acc;
}

test "sample data" {
    const sample_input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))";

    try std.testing.expectEqual(161, try calculate(sample_input));
}

test "4 digit" {
    const inputs = &.{
        "mul(123,1234)",
        "mul(1234,123)",
        "mul(1234,1234)",
    };

    inline for (inputs) |i| {
        try std.testing.expectEqual(0, try calculate(i));
    }
}

test "part 2" {
    const sample_input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))";

    try std.testing.expectEqual(48, try calculate(sample_input));
}

const std = @import("std");
const input = @embedFile("day3.txt");
