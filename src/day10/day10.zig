/// # Advent of Code - Day 10
const std = @import("std");
const ArrayList = std.ArrayList;
const print = std.debug.print;
const sort = std.sort;
const testing = std.testing;
const tokenize = std.mem.tokenize;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

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
fn part1() !u32 {
    var ans: u32 = 0;
    var input_iter = tokenize(u8, input, "\n");
    while (input_iter.next()) |line| {
        var stack = ArrayList(u8).init(gpa);
        defer stack.deinit();
        for (line) |c| {
            switch (c) {
                '(' => try stack.append(')'),
                '[' => try stack.append(']'),
                '{' => try stack.append('}'),
                '<' => try stack.append('>'),
                else => if (stack.items.len == 0 or stack.pop() != c) {
                    switch (c) {
                        ')' => ans += 3,
                        ']' => ans += 57,
                        '}' => ans += 1197,
                        '>' => ans += 25137,
                        else => unreachable,
                    }
                    break;
                },
            }
        }
    }
    return ans;
}

test "day10.part1" {
    try testing.expectEqual(@as(u32, 266301), try part1());
}

///
/// --- Part Two ---
///
fn part2() !u64 {
    var scores = ArrayList(u64).init(gpa);
    defer scores.deinit();
    var input_iter = tokenize(u8, input, "\n");
    while (input_iter.next()) |line| {
        var stack = ArrayList(u8).init(gpa);
        defer stack.deinit();
        for (line) |c| {
            switch (c) {
                '(' => try stack.append(')'),
                '[' => try stack.append(']'),
                '{' => try stack.append('}'),
                '<' => try stack.append('>'),
                else => if (stack.items.len == 0 or stack.pop() != c) {
                    stack.clearAndFree();
                    break;
                },
            }
        }
        var score: u64 = 0;
        while (stack.popOrNull()) |c| {
            switch (c) {
                ')' => score = score * 5 + 1,
                ']' => score = score * 5 + 2,
                '}' => score = score * 5 + 3,
                '>' => score = score * 5 + 4,
                else => unreachable,
            }
        }
        if (score != 0) {
            try scores.append(score);
        }
    }
    sort.sort(u64, scores.items, {}, comptime sort.asc(u64));
    return scores.items[scores.items.len / 2];
}

test "day10.part2" {
    try testing.expectEqual(@as(u64, 3404870164), try part2());
}
