const std = @import("std");
const lib = @import("example-lib");

pub fn main() !void {
    std.debug.print("{d}\n", .{lib.add(3, 2)}); // print 5
    std.debug.print("{d}\n", .{lib.sub(7, 8)}); // print -1
}
