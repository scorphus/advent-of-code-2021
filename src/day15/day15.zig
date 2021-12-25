/// # Advent of Code - Day 15
const std = @import("std");
const Order = std.math.Order;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const PriorityQueue = std.PriorityQueue;
const tokenize = std.mem.tokenize;
const testing = std.testing;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

const input = @embedFile("./input.txt");
const size = 100;

const DELTAS = .{
    .{ 1, 0 },
    .{ 0, 1 },
    .{ -1, 0 },
    .{ 0, -1 },
};

///
/// riskLevelLessThan compares two RiskLevels
///
fn riskLevelLessThan(context: void, a: RiskLevel, b: RiskLevel) Order {
    _ = context;
    for (a) |ai, i| {
        if (ai < b[i]) return .lt;
        if (ai > b[i]) return .gt;
    }
    return .eq;
}

const RiskLevel = [3]u32;
const LowestRiskLevels = PriorityQueue(RiskLevel, void, riskLevelLessThan);

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
    var density: [size][size]u8 = try readChitonDensity();
    return try findLowestRiskLevel(&density, .{ 0, 0 }, .{ size - 1, size - 1 });
}

test "day15.part1" {
    try testing.expectEqual(@as(u32, 361), try part1());
}

///
/// --- Part Two ---
///
fn part2() !i32 {
    return 0;
}

test "day15.part2" {
    try testing.expectEqual(0, comptime try part2());
}

///
/// readChitonDensity reads the input file and returns a square matrix
///
fn readChitonDensity() ![size][size]u8 {
    var density: [size][size]u8 = undefined;
    var input_iter = tokenize(u8, input, "\n");
    var i: usize = 0;
    while (input_iter.next()) |row| : (i += 1) {
        for (row) |chiton, j| {
            density[i][j] = chiton - '0';
        }
    }
    return density;
}

///
/// findLowestRiskLevel returns the lowest risk level of a path from start to end
///
fn findLowestRiskLevel(density: *[size][size]u8, start: [2]u8, end: [2]u8) !u32 {
    var queue = LowestRiskLevels.init(gpa, {});
    defer queue.deinit();
    try queue.add(RiskLevel{ 0, start[0], start[1] });
    while (queue.count() > 0) {
        var least = queue.remove();
        var risk = least[0];
        var i = least[1];
        var j = least[2];
        if (i == end[0] and j == end[1]) {
            return risk;
        }
        inline for (DELTAS) |deltas| {
            if ((i != 0 or deltas[0] != -1) and (j != 0 or deltas[1] != -1)) {
                var ni: u8 = @intCast(u8, @intCast(i16, i) + deltas[0]);
                var nj: u8 = @intCast(u8, @intCast(i16, j) + deltas[1]);
                if (ni < size and nj < size and density[ni][nj] < 10) {
                    try queue.add(RiskLevel{ risk + density[ni][nj], ni, nj });
                    density[ni][nj] = 10;
                }
            }
        }
    }
    return 0;
}
