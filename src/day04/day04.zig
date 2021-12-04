/// # Advent of Code - Day 4
const std = @import("std");
const testing = std.testing;
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const input = @embedFile("./input.txt");

const num_numbers = 100;
const num_boards = 1000;
const board_size = 5;

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
    var numbers = [_]u8{0} ** num_numbers;
    var boards = [_][num_numbers]u8{[_]u8{255} ** num_numbers} ** num_boards;
    var board_sum = [_]u16{0} ** num_boards;
    var rows = [_][board_size]u8{[_]u8{0} ** board_size} ** num_boards;
    var cols = [_][board_size]u8{[_]u8{0} ** board_size} ** num_boards;
    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");
    var block_count: u8 = 0;
    while (lines.next()) |line| : (block_count += 1) {
        if (block_count == 0) {
            var numbers_iter = std.mem.split(u8, line, ",");
            var number_count: u8 = 0;
            while (numbers_iter.next()) |number| : (number_count += 1) {
                numbers[number_count] = try std.fmt.parseInt(u8, number, 10);
            }
        } else {
            var r: u8 = 0;
            while (r < board_size) : (r += 1) {
                var row_str = lines.next() orelse "";
                var row_iter = std.mem.split(u8, row_str, " ");
                var c: u8 = 0;
                while (row_iter.next()) |cell_str| {
                    var cell: u8 = std.fmt.parseInt(u8, cell_str, 10) catch continue;
                    boards[block_count - 1][cell] = r * board_size + c;
                    board_sum[block_count - 1] += cell;
                    c += 1;
                }
            }
        }
    }
    for (numbers) |n| {
        for (boards) |board, b| {
            if (board[n] < 255) {
                board_sum[b] -= n;
                rows[b][board[n] / board_size] += 1;
                cols[b][board[n] % board_size] += 1;
                var row_marked = rows[b][board[n] / board_size] == board_size;
                var col_marked = cols[b][board[n] % board_size] == board_size;
                if (row_marked or col_marked) {
                    return board_sum[b] * n;
                }
            }
        }
    }
    unreachable;
}

test "day04.part1" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(49860, comptime try part1());
}

///
/// --- Part Two ---
///
fn part2() !i32 {
    return 0;
}

test "day04.part2" {
    @setEvalBranchQuota(200_000);
    try testing.expectEqual(0, comptime try part2());
}
