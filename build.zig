const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zig-pm-example-app",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.install();

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.condition = .always;
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const example_dep = b.dependency("libname", .{ // <== as declared in build.zig.zon
        .target = target, // the same as passing `-Dtarget=<...>` to the library's build.zig script
        .optimize = optimize, // ditto for `-Doptimize=<...>`
    });
    const foo_mod = example_dep.module("foo"); // <== as declared in the build.zig of the dependency
    const bar_mod = example_dep.artifact("bar"); // <== ditto
    const baz_mod = example_dep.artifact("baz"); // <== ditto

    exe.addModule("example-lib", foo_mod);
    exe.linkLibrary(baz_mod);

    const run_bar = b.addRunArtifact(bar_mod);
    run_bar.condition = .always;
    if (b.args) |args| {
        run_bar.addArgs(args);
    }
    const run_bar_step = b.step("run-bar", "Run the bar executable"); // this will run the 'bar' executable from the library.
    run_bar_step.dependOn(&run_bar.step);
}
