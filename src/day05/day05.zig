/// # Advent of Code - Day 5
const std = @import("std");
const max = std.math.max;
const min = std.math.min;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const testing = std.testing;
const tokenize = std.mem.tokenize;

const input = @embedFile("./input.txt");

const size = 1000;

pub fn main() anyerror!void {
    print("--- Part One ---\n", .{});
    print("Result: {d}\n", .{part1()});

    print("--- Part Two ---\n", .{});
    print("Result: {d}\n", .{part2()});
}

///
/// --- Part One ---
///
fn part1() !u16 {
    var overlap: u16 = 0;
    var diagram = [_][size]u16{[_]u16{0} ** size} ** size;
    var lines = tokenize(u8, input, "\r\n");
    while (lines.next()) |line| {
        var numbers = tokenize(u8, line, " ,->");
        var x1 = try parseInt(u16, numbers.next() orelse "", 10);
        var y1 = try parseInt(u16, numbers.next() orelse "", 10);
        var x2 = try parseInt(u16, numbers.next() orelse "", 10);
        var y2 = try parseInt(u16, numbers.next() orelse "", 10);
        overlap += coverLine(&diagram, x1, y1, x2, y2);
    }
    return overlap;
}

test "day05.part1" {
    @setEvalBranchQuota(1_000_000); // 🤯
    try testing.expectEqual(7436, comptime try part1());
}

///
/// --- Part Two ---
///
fn part2() !u16 {
    return 0;
}

test "day05.part2" {
    try testing.expectEqual(0, comptime try part2());
}

///
/// coverLine covers all points in the line from (x1, y1) to (x2, y2)
///
fn coverLine(diagram: *[size][size]u16, x1: u16, y1: u16, x2: u16, y2: u16) u16 {
    if (x1 == x2 or y1 == y2) {
        var overlap: u16 = 0;
        var x = min(x1, x2);
        while (x <= max(x1, x2)) : (x += 1) {
            var y = min(y1, y2);
            while (y <= max(y1, y2)) : (y += 1) {
                diagram[x][y] += 1;
                if (diagram[x][y] == 2) {
                    overlap += 1;
                }
            }
        }
        return overlap;
    }
    return 0;
}
