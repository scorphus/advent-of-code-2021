/// # Advent of Code - Day 3
const std = @import("std");
const testing = std.testing;
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

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
fn part1() !u64 {
    var report = try readReport(input);
    var numbers = try parseNumbers(report);
    var bit: u64 = report[0].len;
    const master_mask = std.math.pow(u64, 2, bit) - 1;
    var mask = master_mask + 1;
    var gamma: u64 = 0;
    while (bit > 0) : (bit -= 1) {
        mask /= 2;
        var count: u64 = 0;
        for (numbers) |number| {
            if (number & mask != 0) {
                count += 1;
            }
        }
        if (2 * count >= numbers.len) {
            gamma |= mask;
        }
    }
    return gamma * (master_mask - gamma);
}

test "day03.part1" {
    try testing.expectEqual(@as(u64, 3985686), try part1());
}

///
/// --- Part Two ---
///
fn part2() !u64 {
    var report = try readReport(input);
    var numbers = try parseNumbers(report);
    var oxygen = try determineRating(report[0].len, numbers, 1);
    var co2 = try determineRating(report[0].len, numbers, 0);
    return oxygen * co2;
}

test "day03.part2" {
    try testing.expectEqual(@as(u64, 2555739), try part2());
}

fn readReport(whole_input: []const u8) ![][]const u8 {
    var report = ArrayList([]const u8).init(std.heap.page_allocator);
    defer report.deinit();
    var lines_iter = std.mem.split(u8, std.mem.trimRight(u8, whole_input, "\n"), "\n");
    while (lines_iter.next()) |line| {
        try report.append(line);
    }
    return report.toOwnedSlice();
}

fn parseNumbers(report: [][]const u8) ![]u64 {
    var numbers = ArrayList(u64).init(std.heap.page_allocator);
    defer numbers.deinit();
    for (report) |line| {
        try numbers.append(try std.fmt.parseInt(u64, line, 2));
    }
    return numbers.toOwnedSlice();
}

fn determineRating(len: u64, numbers: []u64, crit: u1) !u64 {
    var bit = len;
    var rating = numbers;
    while (rating.len > 1 and bit > 0) : (bit -= 1) {
        var mask = std.math.pow(u64, 2, bit - 1);
        var rating_one = ArrayList(u64).init(std.heap.page_allocator);
        defer rating_one.deinit();
        var rating_nil = ArrayList(u64).init(std.heap.page_allocator);
        defer rating_nil.deinit();
        for (rating) |r| {
            if (r & mask == 0) {
                try rating_nil.append(r);
            } else {
                try rating_one.append(r);
            }
        }
        if (rating_one.items.len >= rating_nil.items.len) {
            rating = if (crit == 1) rating_one.toOwnedSlice() else rating_nil.toOwnedSlice();
        } else {
            rating = if (crit == 1) rating_nil.toOwnedSlice() else rating_one.toOwnedSlice();
        }
    }
    return rating[0];
}
