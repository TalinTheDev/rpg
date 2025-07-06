// Copyright 2025 Talin Sharma. Subject to the Apache-2.0 license.
//! Contains player related logic

// Imports
const rl = @import("raylib");
const utils = @import("utils.zig");
const lib = @import("root.zig");
const std = @import("std");

/// Contains player logic and data
pub const Player = struct {
    /// The sprite for this player
    sprite: lib.Sprite,
    /// Whether or not the sprite should play the idle animation
    idle: bool = true,

    /// Returns a Player created from a sprite sheet at [path]
    pub fn init(alloc: std.mem.Allocator, path: [:0]const u8) !*Player {
        const sheet = try lib.SpriteSheet.init(alloc, path, .{
            .spriteCount = 1,
            .spriteWidth = 24,
            .spriteHeight = 24,
            .sheetWidth = 96,
            .sheetHeight = 48,
        });

        const sprite = sheet.getSprite(0, 0, 0, 0, 0.0, lib.CONFIG.PLAYER_SCALE, lib.CONFIG.PLAYER_SPEED, true, 2);

        const player = try alloc.create(Player);
        player.* = .{
            .sprite = sprite,
        };
        return player;
    }

    /// Update player
    pub fn update(self: *Player, delta: f32) void {
        // Reset idle state
        const lastAnimState = self.idle;
        self.idle = true;

        // Handle input and flip sprite if needed; also change idle state
        if (rl.isKeyDown(.w)) {
            self.sprite.dest.y -= self.sprite.speed * delta;
            self.idle = false;
        } else if (rl.isKeyDown(.s)) {
            self.sprite.dest.y += self.sprite.speed * delta;
            self.idle = false;
        }
        if (rl.isKeyDown(.d)) {
            self.sprite.dest.x += self.sprite.speed * delta;
            self.sprite.source.width = self.sprite.sheet.spriteWidth;
            self.idle = false;
        } else if (rl.isKeyDown(.a)) {
            self.sprite.dest.x -= self.sprite.speed * delta;
            self.sprite.source.width = -1 * self.sprite.sheet.spriteWidth;
            self.idle = false;
        }

        // Toggle between idle animation (frames 1-2) and walking animation (frames 1-4)
        if (self.idle) {
            self.sprite.currentAnimation = 1;
            self.sprite.frameCount = 2;
        } else {
            self.sprite.currentAnimation = 2;
            self.sprite.frameCount = 4;
        }

        // Reset animation state if a new animation is going to be played
        if (lastAnimState != self.idle) {
            self.sprite.currentFrame = 1;
            self.sprite.counter = 0;
        }
    }
};
