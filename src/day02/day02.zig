/// # Advent of Code - Day 2
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
    var depth: i32 = 0;
    var position: i32 = 0;
    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");
    while (lines.next()) |line| {
        var command = std.mem.split(u8, line, " ");
        var kind = command.next() orelse "";
        var quantity = try std.fmt.parseInt(i32, command.next() orelse "0", 10);
        if (std.mem.eql(u8, kind, "up")) {
            depth -= quantity;
        } else if (std.mem.eql(u8, kind, "down")) {
            depth += quantity;
        } else {
            position += quantity;
        }
    }
    return depth * position;
}

test "day02.part1" {
    try testing.expectEqual(0, comptime try part1());
}

///
/// --- Part Two ---
///
fn part2() !i32 {
    var aim: i32 = 0;
    var depth: i32 = 0;
    var position: i32 = 0;
    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");
    while (lines.next()) |line| {
        var command = std.mem.split(u8, line, " ");
        var kind = command.next() orelse "";
        var quantity = try std.fmt.parseInt(i32, command.next() orelse "0", 10);
        if (std.mem.eql(u8, kind, "up")) {
            aim -= quantity;
        } else if (std.mem.eql(u8, kind, "down")) {
            aim += quantity;
        } else {
            position += quantity;
            depth += aim * quantity;
        }
    }
    return depth * position;
}

test "day02.part2" {
    try testing.expectEqual(0, comptime try part2());
}
