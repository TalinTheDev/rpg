// Copyright 2025 Talin Sharma. Subject to the Apache-2.0 license.
//! Project root

// Imports
const lib = @import("rpg_lib");
const rl = @import("raylib");
const std = @import("std");

// Game entry point
pub fn main() !void {
    // Initialize window and OpenGL context; Also defer closing both
    rl.initWindow(800, 600, "Hello World!");
    defer rl.closeWindow();

    // Initialize the player; Also defer de-initializing it
    var p = lib.Player{};
    var player: *lib.Player = try lib.Player.init(&p);
    defer player.deinit();

    // While window should stay open...
    while (!rl.windowShouldClose()) {
        // Begin drawing and clear screen
        rl.beginDrawing();
        rl.clearBackground(rl.Color.sky_blue);

        player.draw();

        // End drawing
        rl.endDrawing();
    }
}
