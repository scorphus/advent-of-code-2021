/// # Advent of Code - Day 9
const std = @import("std");
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const tokenize = std.mem.tokenize;
const testing = std.testing;

const input = @embedFile("./input.txt");
const rows = 100;
const cols = 100;

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
    var heatmap: [rows][cols]u8 = try parseHeatmap();
    for (heatmap) |row, i| {
        for (heatmap[i]) |cell, j| {
            if (j != 0 and cell >= heatmap[i][j - 1]) continue;
            if (j != row.len - 1 and cell >= heatmap[i][j + 1]) continue;
            if (i != 0 and cell >= heatmap[i - 1][j]) continue;
            if (i != heatmap.len - 1 and cell >= heatmap[i + 1][j]) continue;
            ans += cell + 1;
        }
    }
    return ans;
}

test "day09.part1" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(537, comptime try part1());
}

///
/// --- Part Two ---
///
fn part2() !u32 {
    var s1: u32 = 0;
    var s2: u32 = 0;
    var s3: u32 = 0;
    var heatmap: [rows][cols]u8 = try parseHeatmap();
    for (heatmap) |row, i| {
        for (heatmap[i]) |cell, j| {
            if (j != 0 and cell >= heatmap[i][j - 1]) continue;
            if (j != row.len - 1 and cell >= heatmap[i][j + 1]) continue;
            if (i != 0 and cell >= heatmap[i - 1][j]) continue;
            if (i != heatmap.len - 1 and cell >= heatmap[i + 1][j]) continue;
            var size = fillBasin(&heatmap, .{ i, j });
            if (size > s1) {
                s3 = s2;
                s2 = s1;
                s1 = size;
            } else if (size > s2) {
                s3 = s2;
                s2 = size;
            } else if (size > s3) {
                s3 = size;
            }
        }
    }
    return s1 * s2 * s3;
}

test "day09.part2" {
    @setEvalBranchQuota(1_000_000);
    try testing.expectEqual(1142757, comptime try part2());
}

///
/// parseHeatmap parses the input into a 2D array of u8s
///
fn parseHeatmap() ![rows][cols]u8 {
    var heatmap: [rows][cols]u8 = undefined;
    var input_iter = tokenize(u8, input, "\n");
    var i: usize = 0;
    while (input_iter.next()) |row| : (i += 1) {
        for (row) |cell, j| {
            heatmap[i][j] = cell - '0';
        }
    }
    return heatmap;
}

///
/// fillBasin fills a basin of the start cell in a BFS fashion and returns its size
///
fn fillBasin(heatmap: *[rows][cols]u8, start: anytype) u32 {
    var queue: [rows * cols][2]usize = undefined;
    var front: u32 = 0;
    var back: u32 = 1;
    queue[front] = start;
    while (front < back) : (front += 1) {
        var i = queue[front][0];
        var j = queue[front][1];
        inline for (.{ .{ 1, 0 }, .{ 0, 1 }, .{ -1, 0 }, .{ 0, -1 } }) |deltas| {
            if ((i != 0 or deltas[0] != -1) and (j != 0 or deltas[1] != -1)) {
                var x: usize = @intCast(usize, @intCast(i16, i) + deltas[0]);
                var y: usize = @intCast(usize, @intCast(i16, j) + deltas[1]);
                if (x < rows and y < cols and heatmap[x][y] < 9) {
                    heatmap[x][y] = 9;
                    queue[back] = .{ x, y };
                    back += 1;
                }
            }
        }
    }
    return back - 1;
}
