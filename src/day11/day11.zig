/// # Advent of Code - Day 11
const std = @import("std");
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const tokenize = std.mem.tokenize;
const testing = std.testing;

const input = @embedFile("./input.txt");
const size = 10;

const DELTAS = .{
    .{ 1, 0 },
    .{ 0, 1 },
    .{ -1, 0 },
    .{ 0, -1 },
    .{ 1, 1 },
    .{ -1, -1 },
    .{ 1, -1 },
    .{ -1, 1 },
};

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
    var grid: [size][size]u8 = try parseGrid();
    var i: u8 = 0;
    while (i < 100) : (i += 1) {
        ans += step(&grid);
    }
    return ans;
}

test "day11.part1" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(1755, comptime try part1());
}

///
/// --- Part Two ---
///
fn part2() !u32 {
    var ans: u8 = 0;
    var grid: [size][size]u8 = try parseGrid();
    while (true) {
        ans += 1;
        if (step(&grid) == size * size) {
            break;
        }
    }
    return ans;
}

test "day11.part2" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(212, comptime try part2());
}

///
/// parseGrid parses the input into a 2D array of u8s representing energy levels
///
fn parseGrid() ![size][size]u8 {
    var grid: [size][size]u8 = undefined;
    var input_iter = tokenize(u8, input, "\n");
    var i: usize = 0;
    while (input_iter.next()) |row| : (i += 1) {
        for (row) |octopus, j| {
            grid[i][j] = octopus - '0';
        }
    }
    return grid;
}

///
/// step performs one step of the Dumbo Octopus simulation 🐙
///
fn step(grid: *[size][size]u8) u32 {
    var flashers: [size * size][2]usize = undefined;
    var flashed: u32 = 0;
    flashed = levelUpStep(grid, &flashers);
    flashed = flashStep(grid, &flashers, flashed);
    resetFlashed(grid, &flashers, flashed);
    return flashed;
}

///
/// levelUpStep walks the grid cell by cell, increasing each value and filling
/// a list of positions with energy level equal to 10
///
fn levelUpStep(grid: *[size][size]u8, flashers: *[size * size][2]usize) u32 {
    var flashed: u32 = 0;
    for (grid) |_, i| {
        for (grid[i]) |_, j| {
            grid[i][j] += 1;
            if (grid[i][j] == 10) {
                flashers[flashed] = .{ i, j };
                flashed += 1;
            }
        }
    }
    return flashed;
}

///
/// flashStep walks through the grid in a BSF fashion flashing all octopuses
/// with energy level equal to 10
///
fn flashStep(grid: *[size][size]u8, flashers: *[size * size][2]usize, flashed: u32) u32 {
    var back = flashed;
    var front: u32 = 0;
    while (front < back) : (front += 1) {
        var i = flashers[front][0];
        var j = flashers[front][1];
        inline for (DELTAS) |deltas| {
            if ((i != 0 or deltas[0] != -1) and (j != 0 or deltas[1] != -1)) {
                var x: usize = @intCast(usize, @intCast(i16, i) + deltas[0]);
                var y: usize = @intCast(usize, @intCast(i16, j) + deltas[1]);
                if (x < size and y < size and grid[x][y] < 10) {
                    grid[x][y] += 1;
                    if (grid[x][y] == 10) {
                        flashers[back] = .{ x, y };
                        back += 1;
                    }
                }
            }
        }
    }
    return back;
}

///
/// resetFlashed resets all octopuses that flashed
///
fn resetFlashed(grid: *[size][size]u8, flashers: *[size * size][2]usize, flashed: u32) void {
    var i: u32 = 0;
    while (i < flashed) : (i += 1) {
        grid[flashers[i][0]][flashers[i][1]] = 0;
    }
}
