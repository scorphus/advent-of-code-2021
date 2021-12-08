/// # Advent of Code - Day 8
const std = @import("std");
const powi = std.math.powi;
const print = std.debug.print;
const split = std.mem.split;
const tokenize = std.mem.tokenize;
const testing = std.testing;

const input = @embedFile("./input.txt");

const pattern_size = 10;
const output_size = 4;

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
    while (input_iter.next()) |note| {
        var note_iter = split(u8, note, " | ");
        _ = note_iter.next();
        var output_iter = tokenize(u8, note_iter.next().?, " ");
        while (output_iter.next()) |out| {
            if (out.len == 2 or out.len == 3 or out.len == 4 or out.len == 7) {
                ans += 1;
            }
        }
    }
    return ans;
}

test "day08.part1" {
    @setEvalBranchQuota(300_000);
    try testing.expectEqual(521, comptime try part1());
}

///
/// --- Part Two ---
///
fn part2() !u32 {
    var ans: u32 = 0;
    var input_iter = tokenize(u8, input, "\n");
    while (input_iter.next()) |note| {
        var note_iter = split(u8, note, " | ");
        var patterns_iter = tokenize(u8, note_iter.next().?, " ");
        var masks: [10]u7 = undefined;
        while (patterns_iter.next()) |pat| {
            if (pat.len == 2 or pat.len == 3 or pat.len == 4 or pat.len == 7) {
                masks[pat.len] = makeMask(pat);
            }
        }
        var output_iter = tokenize(u8, note_iter.next().?, " ");
        var i: u32 = 0;
        while (output_iter.next()) |out| : (i += 1) {
            var digit: u32 = switch (out.len) {
                2 => 1,
                3 => 7,
                4 => 4,
                5 => matchAFiver(out, &masks),
                6 => matchASixer(out, &masks),
                7 => 8,
                else => unreachable,
            };
            ans += digit * try powi(u32, 10, 3 - i);
        }
    }
    return ans;
}

test "day08.part2" {
    @setEvalBranchQuota(300_000);
    try testing.expectEqual(1016804, comptime try part2());
}

///
/// makeMask creates a bitset mask for a given pattern
///
fn makeMask(pattern: []const u8) u7 {
    var mask = std.StaticBitSet(7).initEmpty();
    for (pattern) |c| {
        mask.set(c - 'a');
    }
    return mask.mask;
}

///
/// matchAFiver matches a 5-character pattern and returns the corresponding digit
///
fn matchAFiver(fiver: []const u8, masks: []const u7) u32 {
    var mask: u7 = makeMask(fiver);
    if (mask & masks[3] == masks[3]) {
        return 3;
    }
    if (mask | masks[3] | masks[4] == masks[7]) {
        return 2;
    }
    return 5;
}

///
/// matchASixer matches a 6-character pattern and returns the corresponding digit
///
fn matchASixer(sixer: []const u8, masks: []const u7) u32 {
    var mask: u7 = makeMask(sixer);
    if (mask & masks[4] == masks[4]) {
        return 9;
    }
    if (mask & masks[4] & masks[3] != masks[2]) {
        return 6;
    }
    return 0;
}
