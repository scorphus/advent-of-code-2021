/// # Advent of Code - Day 1
const std = @import("std");
const testing = std.testing;
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const input = @embedFile("./input.txt");

pub fn main() anyerror!void {
    print("--- Part One ---\n", .{});
    print("Result: {d}\n", .{part1()});

    print("--- Part Two ---\n", .{});
    print("Result: {d}\n", .{part2()});
}

///
/// --- Part One ---
///
fn part1() !i32 {
    var increases: i32 = 0;
    var last_depth: i32 = 0xFFFF;
    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");
    while (lines.next()) |line| {
        var depth = try std.fmt.parseInt(i32, line, 10);
        if (depth > last_depth) {
            increases += 1;
        }
        last_depth = depth;
    }
    return increases;
}

test "day01.part1" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(1446, comptime try part1());
}

///
/// --- Part Two ---
///
fn part2() !i32 {
    var d1: i32 = 0;
    var d2: i32 = 0;
    var d3: i32 = 0;
    var increases: i32 = 0;
    var depth: i32 = 0;
    var last_depth: i32 = 0;
    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");
    while (lines.next()) |line| {
        var d4 = try std.fmt.parseInt(i32, line, 10);
        depth += d4 - d1;
        if (d1 > 0 and depth > last_depth) {
            increases += 1;
        }
        d1 = d2;
        d2 = d3;
        d3 = d4;
        last_depth = depth;
    }
    return increases;
}

test "day01.part2" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(1486, comptime try part2());
}
