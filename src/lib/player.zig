// Copyright 2025 Talin Sharma. Subject to the Apache-2.0 license.
//! Contains player related logic

// Imports
const rl = @import("raylib");
const utils = @import("utils.zig");

/// Contains player logic and data
pub const Player = struct {
    /// Image of sprite sheet
    image: rl.Image = undefined,
    /// Texture from image
    texture: rl.Texture2D = undefined,
    /// Number of sprites in the sheet
    spriteCount: i32 = undefined,
    /// Width of the spritesheet
    width: f32 = undefined,
    /// Height of the spritesheet
    height: f32 = undefined,
    /// Source rectangle of current frame from spritesheet
    sourceRec: rl.Rectangle = undefined,
    /// Rectangle of where to draw the sprite
    destRec: rl.Rectangle = undefined,
    /// Origin of sprite, around which rotation and scaling is done
    origin: rl.Vector2 = undefined,

    /// Sprite's rotation
    rotation: f32 = 0.00,
    /// Sprite's scale
    scale: f32 = 2.5,

    /// Sprite's speed
    speed: i32 = 100,

    /// Initialize player data
    pub fn init(self: *Player) !*Player {
        self.spriteCount = 1;
        self.image = try rl.loadImage("assets/sprites/player.png");
        self.texture = try rl.loadTextureFromImage(self.image);
        self.width = @divExact(utils.itf(self.texture.width), utils.itf(self.spriteCount));
        self.height = utils.itf(self.texture.height);

        self.sourceRec = rl.Rectangle{
            .x = 0,
            .y = 0,
            .width = self.width,
            .height = self.height,
        };
        self.calculateDestRec();
        self.calculateOrigin();
        return self;
    }

    /// Calculate the destination rectangle for the player sprite (also reset
    /// position)
    pub fn calculateDestRec(self: *Player) void {
        self.destRec = rl.Rectangle{
            .x = 0,
            .y = 0,
            .width = self.width * self.scale,
            .height = self.height * self.scale,
        };
    }

    /// Calculate the origin of the player sprite
    pub fn calculateOrigin(self: *Player) void {
        self.origin = rl.Vector2{
            .x = @divExact(self.destRec.width, 2),
            .y = @divExact(self.destRec.height, 2),
        };
    }

    /// Change the scale of the player sprite
    pub fn setScale(self: *Player, scale: f32) void {
        self.scale = scale;
        self.calculateDestRec();
        self.calculateOrigin();
    }

    /// De-initialize player data
    pub fn deinit(self: *Player) void {
        rl.unloadTexture(self.texture);
        rl.unloadImage(self.image);
    }

    /// Draws player
    pub fn draw(self: *Player) void {
        rl.drawTexturePro(self.texture, self.sourceRec, self.destRec, self.origin, self.rotation, rl.Color.white);
    }

    /// Update player
    pub fn update(self: *Player, delta: f32) void {
        // Movement & sprite flipping from input
        if (rl.isKeyDown(.w)) {
            self.destRec.y -= utils.itf(self.speed) * delta;
        } else if (rl.isKeyDown(.s)) {
            self.destRec.y += utils.itf(self.speed) * delta;
        }
        if (rl.isKeyDown(.d)) {
            self.destRec.x += utils.itf(self.speed) * delta;
            self.sourceRec.width = self.width;
        } else if (rl.isKeyDown(.a)) {
            self.destRec.x -= utils.itf(self.speed) * delta;
            self.sourceRec.width = -1 * self.width;
        }
    }
};
