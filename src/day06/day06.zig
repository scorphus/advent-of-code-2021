/// # Advent of Code - Day 6
const std = @import("std");
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const testing = std.testing;
const tokenize = std.mem.tokenize;

const input = @embedFile("./input.txt");

const lifespan = 8;
const respawn = 6;

pub fn main() anyerror!void {
    print("--- Part One ---\n", .{});
    print("Result: {d}\n", .{part1()});

    print("--- Part Two ---\n", .{});
    print("Result: {d}\n", .{part2()});
}

///
/// --- Part One ---
///
fn part1() !usize {
    var fish = try readFish();
    simulate(&fish, 80);
    return sumFish(&fish);
}

test "day06.part1" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(362666, comptime try part1());
}

///
/// --- Part Two ---
///
fn part2() !usize {
    var fish = try readFish();
    simulate(&fish, 256);
    return sumFish(&fish);
}

test "day06.part2" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(1640526601595, comptime try part2());
}

///
/// readFish reads the input file and returns an array of fish
///
fn readFish() ![lifespan + 1]usize {
    var fish = [_]usize{0} ** (lifespan + 1);
    var state = tokenize(u8, input, "\n,");
    while (state.next()) |fish_str| {
        const i = try parseInt(u8, fish_str, 10);
        fish[i] += 1;
    }
    return fish;
}

///
/// cycle simulates one cycle in the lives of fish
///
fn cycle(fish: *[lifespan + 1]usize) void {
    var respawned = fish[0];
    var i: usize = 0;
    while (i < lifespan) : (i += 1) {
        fish[i] = fish[i + 1];
    }
    fish[lifespan] = respawned;
    fish[respawn] += respawned;
}

///
/// simulate simulates n cycles in the lives of fish
///
fn simulate(fish: *[lifespan + 1]usize, n: usize) void {
    var i: usize = 0;
    while (i < n) : (i += 1) {
        cycle(fish);
    }
}

///
/// sumFish returns the sum of the fish in the array
///
fn sumFish(fish: *[lifespan + 1]usize) usize {
    var sum: usize = 0;
    for (fish) |f| {
        sum += f;
    }
    return sum;
}
