// Copyright 2025 Talin Sharma. Subject to the Apache-2.0 license.
//! Contains player related logic

// Imports
const rl = @import("raylib");
const utils = @import("utils.zig");

pub const Player = struct {
    image: rl.Image = undefined,
    texture: rl.Texture2D = undefined,
    position: rl.Vector2 = undefined,
    rotation: f32 = 0.00,
    scale: f32 = 2.5,

    speed: i32 = 100,

    /// Initialize player data
    pub fn init(self: *Player) !*Player {
        self.position = rl.Vector2{ .x = 50, .y = 50 };
        self.image = try rl.loadImage("assets/sprites/player.png");
        self.texture = try rl.loadTextureFromImage(self.image);

        return self;
    }

    /// De-initialize player data
    pub fn deinit(self: *Player) void {
        rl.unloadTexture(self.texture);
        rl.unloadImage(self.image);
    }

    /// Draws player
    pub fn draw(self: *Player) void {
        rl.drawTextureEx(self.texture, self.position, self.rotation, self.scale, rl.Color.white);
    }

    /// Update player
    pub fn update(self: *Player, delta: f32) void {
        if (rl.isKeyDown(.w)) {
            self.position.y -= utils.itf(self.speed) * delta;
        } else if (rl.isKeyDown(.s)) {
            self.position.y += utils.itf(self.speed) * delta;
        }
        if (rl.isKeyDown(.d)) {
            self.position.x += utils.itf(self.speed) * delta;
        } else if (rl.isKeyDown(.a)) {
            self.position.x -= utils.itf(self.speed) * delta;
        }
    }
};
