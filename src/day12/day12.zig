/// # Advent of Code - Day 12
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
    return 0;
}

test "day12.part1" {
    try testing.expectEqual(0, comptime try part1());
}

///
/// --- Part Two ---
///
fn part2() !i32 {
    return 0;
}

test "day12.part2" {
    try testing.expectEqual(0, comptime try part2());
}
