/// # Advent of Code - Day 12
const std = @import("std");
const eql = std.mem.eql;
const print = std.debug.print;
const testing = std.testing;
const tokenize = std.mem.tokenize;

var gpa_impl = std.heap.GeneralPurposeAllocator(.{}){};
const gpa = gpa_impl.allocator();

const input = @embedFile("./input.txt");

const Nodes = std.StringHashMap(bool);
const Graph = std.StringHashMap(Nodes);

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
    var start = "start";
    var end = "end";
    var graph = try parseGraph(start, end);
    defer graph.deinit();
    var seen = Nodes.init(gpa);
    defer seen.deinit();
    return countPaths(graph, start, end, &seen, false, false);
}

test "day12.part1" {
    try testing.expectEqual(@as(u32, 5958), try part1());
}

///
/// --- Part Two ---
///
fn part2() !u32 {
    var start = "start";
    var end = "end";
    var graph = try parseGraph(start, end);
    defer graph.deinit();
    var seen = Nodes.init(gpa);
    defer seen.deinit();
    return countPaths(graph, start, end, &seen, true, false);
}

test "day12.part2" {
    try testing.expectEqual(@as(u32, 150426), try part2());
}

///
/// parseGraph parses the input into a Graph
///
fn parseGraph(start: []const u8, end: []const u8) !Graph {
    var graph = Graph.init(gpa);
    var input_iter = tokenize(u8, input, "\n");
    while (input_iter.next()) |edge| {
        var edge_iter = tokenize(u8, edge, "-");
        var u = edge_iter.next().?;
        var v = edge_iter.next().?;
        if (!graph.contains(u)) {
            try graph.put(u, Nodes.init(gpa));
        }
        if (!graph.contains(v)) {
            try graph.put(v, Nodes.init(gpa));
        }
        if (!eql(u8, u, end) and !eql(u8, v, start)) {
            try graph.getPtr(u).?.put(v, true);
        }
        if (!eql(u8, u, start) and !eql(u8, v, end)) {
            try graph.getPtr(v).?.put(u, true);
        }
    }
    return graph;
}

///
/// countPaths counts the number of paths in a Graph from start to end
///
fn countPaths(g: Graph, start: []const u8, end: []const u8, seen: *Nodes, allow_dupe: bool, is_dupe: bool) u32 {
    var paths: u32 = 0;
    var it = g.getPtr(start).?.keyIterator();
    while (it.next()) |n| {
        var neigh = n.*;
        if (eql(u8, neigh, end)) {
            paths += 1;
            continue;
        }
        if (seen.contains(neigh) and (!allow_dupe or is_dupe)) {
            continue;
        }
        if (allow_dupe and seen.contains(neigh)) {
            paths += countPaths(g, neigh, end, seen, allow_dupe, true);
            continue;
        }
        if (neigh[0] >= 'a') {
            seen.put(neigh, true) catch continue;
        }
        paths += countPaths(g, neigh, end, seen, allow_dupe, is_dupe);
        _ = seen.remove(neigh);
    }
    return paths;
}
