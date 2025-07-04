// Copyright 2025 Talin Sharma. Subject to the Apache-2.0 license.
//! Project root

// Imports
const lib = @import("rpg_lib");
const rl = @import("raylib");
const std = @import("std");

// Game entry point
pub fn main() !void {
    // Initialize window and OpenGL context; Also defer closing both
    rl.initWindow(800, 600, "RPG");
    rl.setTargetFPS(60);
    defer rl.closeWindow();

    // Initialize an Arena Allocator for general purpose use; Also defer de-initializing it
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Initialize the player; Also defer de-initializing it
    const player = try lib.Player.init(allocator, "assets/sprites/player.png");

    // Setup camera
    var camera = rl.Camera2D{
        .target = rl.Vector2{
            .x = 0,
            .y = 0,
        },
        .offset = rl.Vector2{
            .x = lib.itf(@divExact(rl.getScreenWidth(), 2)),
            .y = lib.itf(@divExact(rl.getScreenHeight(), 2)),
        },
        .rotation = 0.0,
        .zoom = 1.0,
    };

    // While window should stay open...
    while (!rl.windowShouldClose()) {
        // Run updates
        player.update(rl.getFrameTime());
        camera.target.x = player.sprite.dest.x;
        camera.target.y = player.sprite.dest.y;

        // Begin drawing and clear screen
        rl.beginDrawing();
        rl.clearBackground(rl.Color.sky_blue);

        rl.beginMode2D(camera);

        rl.drawCircle(0, 0, 25, rl.Color.orange); // Reference circle
        player.sprite.draw();

        rl.endMode2D();
        rl.drawFPS(50, 50);

        // End drawing
        rl.endDrawing();
    }
}
