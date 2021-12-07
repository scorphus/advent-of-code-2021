/// # Advent of Code - Day 7
const std = @import("std");
const absInt = std.math.absInt;
const min = std.math.min;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const sort = std.sort;
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
fn part1() !i32 {
    var crab_positions = try readCrabPositions();
    sort.sort(i32, &crab_positions, {}, comptime sort.asc(i32));
    var median: i32 = crab_positions[size / 2];
    var fuel: i32 = 0;
    for (crab_positions) |p| {
        fuel += try absInt(p - median);
    }
    return fuel;
}

test "day07.part1" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(347011, comptime try part1());
}

///
/// --- Part Two ---
///
fn part2() !i32 {
    var crab_positions = try readCrabPositions();
    var sum: i32 = 0;
    for (crab_positions) |p| {
        sum += p;
    }
    const mean_floor = @divFloor(sum, size);
    const mean_ceil = mean_floor + 1;
    var total_fuel_floor: i32 = 0;
    var total_fuel_ceil: i32 = 0;
    for (crab_positions) |p| {
        const fuel_floor = try absInt(p - mean_floor);
        total_fuel_floor += @divFloor(((fuel_floor + 1) * fuel_floor), 2);
        const fuel_ceil = try absInt(p - mean_ceil);
        total_fuel_ceil += @divFloor(((fuel_ceil + 1) * fuel_ceil), 2);
    }
    return min(total_fuel_floor, total_fuel_ceil);
}

test "day07.part2" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(98363777, comptime try part2());
}

///
/// readCrabPositions reads the input file and returns a sorted array of crab positions
///
fn readCrabPositions() ![size]i32 {
    var crab_positions: [size]i32 = undefined;
    var positions = tokenize(u8, input, "\n,");
    var i: usize = 0;
    while (positions.next()) |pos| : (i += 1) {
        crab_positions[i] = try parseInt(i32, pos, 10);
    }
    return crab_positions;
}
