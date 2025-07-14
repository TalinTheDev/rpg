// Copyright 2025 Talin Sharma. Subject to the Apache-2.0 license.
//! Project root

// Imports
const lib = @import("rpg_lib");
const rl = @import("raylib");
const std = @import("std");

// Game entry point
pub fn main() !void {
    // Initialize window and OpenGL context; also defer closing both
    rl.initWindow(800, 600, "RPG");
    rl.setTargetFPS(60);
    defer rl.closeWindow();

    // Initialize an Arena Allocator for general purpose use; also defer de-initializing it
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Initialize the player; also defer de-initializing it
    const player = try lib.Player.init(allocator, "assets/sprites/player/player.png");
    defer player.sprite.sheet.deinit();

    // Initialize the map tilemap and some test tiles; also defer de-initializing them
    const tileMap = try lib.SpriteSheet.init(allocator, "assets/map/island.png", .{
        .sheetWidth = 192,
        .sheetHeight = 192,
        .spriteWidth = 24,
        .spriteHeight = 24,
        .spriteCount = 1,
    });
    // var grass = tileMap.getSprite(0, 0, 0, 0, 0, 2.5, 0, false, 0);
    // var water1 = tileMap.getSprite(0, 6, 60, -60, 0, 2.5, 0, false, 0);
    // var water = tileMap.getSprite(0, 7, 60, 0, 0, 2.5, 0, false, 0);
    defer tileMap.deinit();

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
    const Tiles = enum {
        grass,
        water,
    };
    const Tile = struct {
        tileName: Tiles,
        pos: struct {
            row: u8,
            col: u8,
        },
    };
    const map = [3][3]Tile{
        [_]Tile{
            .{ .tileName = .grass, .pos = .{ .row = 0, .col = 0 } },
            .{ .tileName = .grass, .pos = .{ .row = 0, .col = 0 } },
            .{ .tileName = .grass, .pos = .{ .row = 0, .col = 0 } },
        },
        [_]Tile{
            .{ .tileName = .grass, .pos = .{ .row = 0, .col = 0 } },
            .{ .tileName = .water, .pos = .{ .row = 5, .col = 5 } },
            .{ .tileName = .grass, .pos = .{ .row = 0, .col = 0 } },
        },
        [_]Tile{
            .{ .tileName = .grass, .pos = .{ .row = 0, .col = 0 } },
            .{ .tileName = .grass, .pos = .{ .row = 0, .col = 0 } },
            .{ .tileName = .grass, .pos = .{ .row = 0, .col = 0 } },
        },
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

        // Draw map tiles
        for (map, 0..) |row, i| {
            for (row, 0..) |tile, j| {
                var sprite = tileMap.getSprite(tile.pos.col, tile.pos.row, @as(u64, j) * 60, @as(u64, i) * 60, 0, 2.5, 0, false, 1);
                sprite.draw();
            }
        }

        // Draw the player
        player.sprite.draw();

        rl.endMode2D();

        // End drawing
        rl.endDrawing();
    }
}
