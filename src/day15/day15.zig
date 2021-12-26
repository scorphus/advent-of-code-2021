/// # Advent of Code - Day 15
const std = @import("std");
const AutoHashMap = std.AutoHashMap;
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
const Locations = AutoHashMap([2]u9, bool);
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
    return try findLowestRiskLevel(&density, .{ 0, 0 }, .{ size - 1, size - 1 }, 1);
}

test "day15.part1" {
    try testing.expectEqual(@as(u32, 361), try part1());
}

///
/// --- Part Two ---
///
fn part2() !u32 {
    var density: [size][size]u8 = try readChitonDensity();
    return try findLowestRiskLevel(&density, .{ 0, 0 }, .{ 5 * size - 1, 5 * size - 1 }, 5);
}

test "day15.part2" {
    try testing.expectEqual(@as(u32, 2838), try part2());
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
fn findLowestRiskLevel(density: *[size][size]u8, start: [2]u9, end: [2]u9, factor: u9) !u32 {
    var queue = LowestRiskLevels.init(gpa, {});
    defer queue.deinit();
    var seen = Locations.init(gpa);
    defer seen.deinit();
    try queue.add(RiskLevel{ 0, start[0], start[1] });
    try seen.put(start, true);
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
                var ni: u9 = @intCast(u9, @intCast(i18, i) + deltas[0]);
                var nj: u9 = @intCast(u9, @intCast(i18, j) + deltas[1]);
                if (ni < size * factor and nj < size * factor and !seen.contains(.{ ni, nj })) {
                    var r = (density[ni % size][nj % size] + ni / size + nj / size - 1) % 9 + 1;
                    try queue.add(RiskLevel{ risk + r, ni, nj });
                    try seen.put(.{ ni, nj }, true);
                }
            }
        }
    }
    return 0;
}
