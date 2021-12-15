/// # Advent of Code - Day 14
const std = @import("std");
const eql = std.mem.eql;
const max = std.math.max;
const min = std.math.min;
const print = std.debug.print;
const split = std.mem.split;
const testing = std.testing;
const tokenize = std.mem.tokenize;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

const input = @embedFile("./input.txt");

const Reagents = [2]u8;
const InsertionRules = std.AutoHashMap(Reagents, u8);
const Insertions = std.AutoHashMap(Reagents, u64);
const ElementsCounter = std.AutoHashMap(u8, u64);

pub fn main() anyerror!void {
    print("--- Part One ---\n", .{});
    print("Result: {d}\n", .{part1()});

    print("--- Part Two ---\n", .{});
    print("Result: {d}\n", .{part2()});
}

///
/// --- Part One ---
///
fn part1() !u64 {
    return runIterations(10);
}

test "day14.part1" {
    try testing.expectEqual(@as(u64, 3342), try part1());
}

///
/// --- Part Two ---
///
fn part2() !u64 {
    return runIterations(40);
}

test "day14.part2" {
    try testing.expectEqual(@as(u64, 3776553567525), try part2());
}

///
/// parseInsertionRules parses the rules input into a InsertionRules map
///
fn runIterations(iterations: u8) !u64 {
    var input_iter = split(u8, input, "\n\n");
    var template = input_iter.next().?;
    var rules = try parseInsertionRules(input_iter.next().?);
    defer rules.deinit();
    var insertions = try templateToInsertions(template);
    defer insertions.deinit();
    var counter = try countElementsInTemplate(template);
    defer counter.deinit();
    var i: u8 = 0;
    while (i < iterations) : (i += 1) {
        try updtCountElements(&counter, insertions, rules);
        var new_ins = try applyInsertions(insertions, rules);
        insertions.deinit();
        insertions = new_ins;
    }
    var counter_iter = counter.valueIterator();
    var max_count: u64 = 0;
    var min_count: u64 = 0xffffffffffffffff;
    while (counter_iter.next()) |count| {
        max_count = max(max_count, count.*);
        min_count = min(min_count, count.*);
    }
    return max_count - min_count;
}

///
/// parseInsertionRules parses the rules input into a InsertionRules map
///
fn parseInsertionRules(rules_input: []const u8) !InsertionRules {
    var rules = InsertionRules.init(gpa);
    var input_iter = tokenize(u8, rules_input, "-> \n");
    while (true) {
        var ab = input_iter.next() orelse break;
        var c = input_iter.next().?;
        try rules.put(ab[0..2].*, c[0]);
    }
    return rules;
}

///
/// templateToInsertions convert the initial template into a map of insertions
///
fn templateToInsertions(template: []const u8) !Insertions {
    var insertions = Insertions.init(gpa);
    var i: usize = 0;
    while (i < template.len - 1) : (i += 1) {
        var entry = try insertions.getOrPutValue(.{ template[i], template[i + 1] }, 0);
        entry.value_ptr.* += 1;
    }
    return insertions;
}

///
/// countElementsInTemplate initializes a counter of elements in the template
///
fn countElementsInTemplate(template: []const u8) !ElementsCounter {
    var counter = ElementsCounter.init(gpa);
    for (template) |c| {
        const entry = try counter.getOrPutValue(c, 0);
        entry.value_ptr.* += 1;
    }
    return counter;
}

///
/// updtCountElements updates the counter of elements in the template based on
/// the insertion rules
///
fn updtCountElements(counter: *ElementsCounter, insertions: Insertions, rules: InsertionRules) !void {
    var insertions_iter = insertions.iterator();
    while (insertions_iter.next()) |ab_count| {
        var ab = ab_count.key_ptr.*;
        var count = ab_count.value_ptr.*;
        var c = rules.get(ab).?;
        const entry = try counter.getOrPutValue(c, 0);
        entry.value_ptr.* += count;
    }
}

///
/// applyInsertions generates the new insertions from the current insertions
/// based on the insertion rules
///
fn applyInsertions(insertions: Insertions, rules: InsertionRules) !Insertions {
    var insertions_iter = insertions.iterator();
    var new_ins = Insertions.init(gpa);
    while (insertions_iter.next()) |ab_count| {
        var ab = ab_count.key_ptr.*;
        var count = ab_count.value_ptr.*;
        var c = rules.get(ab).?;
        const entry_ac = try new_ins.getOrPutValue(.{ ab[0], c }, 0);
        entry_ac.value_ptr.* += count;
        const entry_cb = try new_ins.getOrPutValue(.{ c, ab[1] }, 0);
        entry_cb.value_ptr.* += count;
    }
    return new_ins;
}
