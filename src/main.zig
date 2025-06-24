// Copyright 2025 Talin Sharma. Subject to the Apache-2.0 license.
//! Project root

// Imports
const lib = @import("rpg");
const rl = @import("raylib");
const std = @import("std");

// Game entry point
pub fn main() !void {
    // Initialize window and OpenGL context; Also defer closing both
    rl.initWindow(800, 600, "Hello World!");
    defer rl.closeWindow();

    // Load player texture
    const playerImage = try rl.loadImage("assets/sprites/player.png");
    const playerTexture = try rl.loadTextureFromImage(playerImage);
    defer rl.unloadImage(playerImage);
    defer rl.unloadTexture(playerTexture);

    // While window should stay open...
    while (!rl.windowShouldClose()) {
        // Begin drawing and clear screen
        rl.beginDrawing();
        rl.clearBackground(rl.Color.sky_blue);

        // Draw player
        // rl.drawTexture(playerTexture, 50, 50, rl.Color.white);
        rl.drawTextureEx(playerTexture, rl.Vector2{
            .x = 50,
            .y = 50,
        }, 0.00, 2.5, rl.Color.white);

        // End drawing
        rl.endDrawing();
    }
}
