/// # Advent of Code - Day 4
const std = @import("std");
const testing = std.testing;
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

const input = @embedFile("./input.txt");

const num_numbers = 100;
const num_boards = 100;
const board_size = 5;

pub fn main() anyerror!void {
    print("--- Part One ---\n", .{});
    print("Result: {d}\n", .{part1()});

    print("--- Part Two ---\n", .{});
    print("Result: {d}\n", .{part2()});
}

///
/// Bingo is the representation of a bingo with sets of numbers and boards
///
const Bingo = struct {
    numbers: [num_numbers]u8,
    boards: [num_boards][num_numbers]u8,
    boards_sum: [num_boards]u16,
    rows_marks: [num_boards][board_size]u8,
    cols_marks: [num_boards][board_size]u8,

    pub fn init() Bingo {
        return Bingo{
            .numbers = [_]u8{0} ** num_numbers,
            .boards = [_][num_numbers]u8{[_]u8{255} ** num_numbers} ** num_boards,
            .boards_sum = [_]u16{0} ** num_boards,
            .rows_marks = [_][board_size]u8{[_]u8{0} ** board_size} ** num_boards,
            .cols_marks = [_][board_size]u8{[_]u8{0} ** board_size} ** num_boards,
        };
    }

    pub fn setNumber(self: *Bingo, index: usize, number: u8) void {
        self.numbers[index] = number;
    }

    pub fn setBoardCell(self: *Bingo, board: usize, row: u8, col: u8, number: u8) void {
        self.boards[board][number] = row * board_size + col;
        self.boards_sum[board] += number;
    }

    ///
    /// winnerScore marks numbers on all boards until one of them wins, returning its score
    ///
    pub fn winnerScore(self: *Bingo) u16 {
        for (self.numbers) |n| {
            return self.winnerBoardScore(n) orelse continue;
        }
        unreachable;
    }

    fn winnerBoardScore(self: *Bingo, number: u8) ?u16 {
        for (self.boards) |board, b| {
            if (board[number] < 255 and self.boardWins(b, number)) {
                return self.boards_sum[b] * number;
            }
        }
        return null;
    }

    fn boardWins(self: *Bingo, board: usize, number: u8) bool {
        self.boards_sum[board] -= number;
        self.rows_marks[board][self.boards[board][number] / board_size] += 1;
        self.cols_marks[board][self.boards[board][number] % board_size] += 1;
        const rows_marked = self.rows_marks[board][self.boards[board][number] / board_size];
        const cols_marked = self.cols_marks[board][self.boards[board][number] % board_size];
        return rows_marked == board_size or cols_marked == board_size;
    }
};

///
/// --- Part One ---
///
fn part1() !i32 {
    var bingo = try readBingo();
    return bingo.winnerScore();
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

///
/// readBingo reads a bingo from the input
///
fn readBingo() !Bingo {
    var bingo = Bingo.init();
    var lines = std.mem.split(u8, std.mem.trimRight(u8, input, "\n"), "\n");
    var numbers_iter = std.mem.split(u8, lines.next() orelse "", ",");
    var number_count: u8 = 0;
    while (numbers_iter.next()) |number| : (number_count += 1) {
        bingo.setNumber(number_count, try std.fmt.parseInt(u8, number, 10));
    }
    var board_count: u8 = 0;
    while (lines.next()) |_| : (board_count += 1) {
        var r: u8 = 0;
        while (r < board_size) : (r += 1) {
            var row_str = lines.next() orelse "";
            var row_iter = std.mem.split(u8, row_str, " ");
            var c: u8 = 0;
            while (row_iter.next()) |cell_str| {
                var cell: u8 = std.fmt.parseInt(u8, cell_str, 10) catch continue;
                bingo.setBoardCell(board_count, r, c, cell);
                c += 1;
            }
        }
    }
    return bingo;
}
