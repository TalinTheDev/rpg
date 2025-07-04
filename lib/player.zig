// Copyright 2025 Talin Sharma. Subject to the Apache-2.0 license.
//! Contains player related logic

// Imports
const rl = @import("raylib");
const utils = @import("utils.zig");
const lib = @import("root.zig");
const std = @import("std");

/// Contains player logic and data
pub const Player = struct {
    sprite: lib.Sprite,

    /// Returns a Player created from a sprite sheet at [path]
    pub fn init(alloc: std.mem.Allocator, path: [:0]const u8) !*Player {
        const sheet = try lib.SpriteSheet.init(alloc, path, .{
            .spriteCount = 1,
            .spriteWidth = 24,
            .spriteHeight = 24,
            .sheetWidth = 24,
            .sheetHeight = 24,
        });

        const sprite = sheet.getSprite(0, 0, 0, 0, 0.0, 2.5, lib.CONFIG.PLAYER_SPEED);

        const player = try alloc.create(Player);
        player.* = .{
            .sprite = sprite,
        };
        return player;
    }

    /// Update player
    pub fn update(self: *Player, delta: f32) void {
        // Movement/sprite flipping from input
        if (rl.isKeyDown(.w)) {
            self.sprite.dest.y -= self.sprite.speed * delta;
        } else if (rl.isKeyDown(.s)) {
            self.sprite.dest.y += self.sprite.speed * delta;
        }
        if (rl.isKeyDown(.d)) {
            self.sprite.dest.x += self.sprite.speed * delta;
            self.sprite.source.width = self.sprite.sheet.sheetWidth;
        } else if (rl.isKeyDown(.a)) {
            self.sprite.dest.x -= self.sprite.speed * delta;
            self.sprite.source.width = -1 * self.sprite.sheet.sheetWidth;
        }
    }
};
