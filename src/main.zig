// Copyright 2025 Talin Sharma. Subject to the Apache-2.0 license.
//! Project root

// Imports
const lib = @import("rpg");
const rl = @import("raylib");

// Game entry point
pub fn main() !void {
    // Initialize window and OpenGL context; Also defer closing both
    rl.initWindow(800, 600, "Hello World!");
    defer rl.closeWindow();

    // While window should stay open...
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();

        // Clear screen
        rl.clearBackground(rl.Color.sky_blue);

        rl.endDrawing();
    }
}
