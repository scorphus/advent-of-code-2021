/// # Advent of Code - Day 13
const std = @import("std");
const eql = std.mem.eql;
const min = std.math.min;
const max = std.math.max;
const mem = std.mem;
const parseInt = std.fmt.parseInt;
const print = std.debug.print;
const testing = std.testing;
const tokenize = std.mem.tokenize;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

const input = @embedFile("./input.txt");
// const input = @embedFile("./input-sample.txt");

const Dot = [2]u32;
const Dots = std.AutoHashMap(Dot, bool);
const Folds = std.ArrayList(Dot);

pub fn main() anyerror!void {
    print("--- Part One ---\n", .{});
    print("Result: {d}\n", .{part1()});

    print("--- Part Two ---\n", .{});
    print("Result:\n{s}\n", .{part2()});
}

///
/// --- Part One ---
///
fn part1() !u32 {
    var dots = try parseDots();
    defer dots.deinit();
    var folds = try parseFolds();
    defer folds.deinit();
    var new_dots = try foldOnce(dots, folds.items[0]);
    defer new_dots.deinit();
    return new_dots.count();
}

test "day13.part1" {
    try testing.expectEqual(@as(u32, 827), try part1());
}

///
/// --- Part Two ---
///
fn part2() ![]u8 {
    var dots = try parseDots();
    defer dots.deinit();
    var folds = try parseFolds();
    defer folds.deinit();
    for (folds.items) |fold| {
        var new_dots = try foldOnce(dots, fold);
        dots.deinit();
        dots = new_dots;
    }
    return try dotsToString(dots, 2);
}

test "day13.part2" {
    const eahkrecp =
        \\########    ####    ##    ##  ##    ##  ######    ########    ####    ######  .
        \\##        ##    ##  ##    ##  ##  ##    ##    ##  ##        ##    ##  ##    ##.
        \\######    ##    ##  ########  ####      ##    ##  ######    ##        ##    ##.
        \\##        ########  ##    ##  ##  ##    ######    ##        ##        ######  .
        \\##        ##    ##  ##    ##  ##  ##    ##  ##    ##        ##    ##  ##      .
        \\########  ##    ##  ##    ##  ##    ##  ##    ##  ########    ####    ##      .
    ;
    var expected: [eahkrecp.len]u8 = undefined;
    _ = mem.replace(u8, eahkrecp, ".", "", expected[0..]);
    const actual = try part2();
    try testing.expect(eql(u8, actual, expected[0..actual.len]));
}

///
/// parseDots parses the input into a Dots
///
fn parseDots() !Dots {
    var dots = Dots.init(gpa);
    var input_iter = tokenize(u8, input, ",\n");
    while (true) {
        var x = parseInt(u32, input_iter.next().?, 10) catch break;
        var y = try parseInt(u32, input_iter.next().?, 10);
        try dots.put(.{ x, y }, true);
    }
    return dots;
}

///
/// parseFolds parses the input into a Folds
///
fn parseFolds() !Folds {
    var folds = Folds.init(gpa);
    var input_iter = tokenize(u8, input, " \n");
    while (true) {
        var fold = input_iter.next() orelse break;
        var x: u32 = 0;
        var y: u32 = 0;
        if (fold[0] == 'x') {
            x = try parseInt(u32, fold[2..], 10);
        } else if (fold[0] == 'y') {
            y = try parseInt(u32, fold[2..], 10);
        } else {
            continue;
        }
        try folds.append(.{ x, y });
    }
    return folds;
}

///
/// foldOnce folds the dots at a given line
///
fn foldOnce(dots: Dots, fold: Dot) !Dots {
    var new_dots = Dots.init(gpa);
    var it = dots.keyIterator();
    while (it.next()) |d| {
        var dot = d.*;
        if (fold[0] == 0) {
            // fold along y
            try new_dots.put(.{ dot[0], min(dot[1], 2 * fold[1] - dot[1]) }, true);
        } else {
            // fold along x
            try new_dots.put(.{ min(dot[0], 2 * fold[0] - dot[0]), dot[1] }, true);
        }
    }
    return new_dots;
}

///
/// dotsToString the dots at a given line
///
fn dotsToString(dots: Dots, thickness: u8) ![]u8 {
    var cols: u32 = 0;
    var rows: u32 = 0;
    var it = dots.keyIterator();
    while (it.next()) |d| {
        var dot = d.*;
        cols = max(cols, dot[0]);
        rows = max(rows, dot[1]);
    }
    cols += 1;
    rows += 1;
    const length = thickness * cols * rows + rows;
    const string = try gpa.alloc(u8, length);
    mem.set(u8, string, ' ');
    var row: usize = 1;
    while (row < rows) : (row += 1) {
        string[row * (thickness * cols + 1)] = '\n';
    }
    it = dots.keyIterator();
    while (it.next()) |d| {
        var dot = d.*;
        const x = thickness * dot[0] + 1;
        const y = dot[1];
        var xi: u32 = x;
        while (xi < x + thickness) : (xi += 1) {
            string[y * (thickness * cols + 1) + xi] = '#';
        }
    }
    return string[1..length];
}
