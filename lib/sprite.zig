// Copyright 2025 Talin Sharma. Subject to the Apache-2.0 license.
//! Sprite!

// Imports
const rl = @import("raylib");
const utils = @import("utils.zig");
const std = @import("std");

/// Config for a SpriteSheet
pub const SpriteSheetConfig = struct {
    /// Number of sprites in the sheet
    spriteCount: i32,
    /// Width of each sprite
    spriteWidth: f32 = 24.0,
    /// Height of each sprite
    spriteHeight: f32 = 24.0,

    /// Width of the sprite sheet
    sheetWidth: f32,
    /// Height of the sprite sheet
    sheetHeight: f32,
};

/// Represents a sprite sheet
pub const SpriteSheet = struct {
    /// The Raylib image of the spite sheet
    image: rl.Image,
    /// The Raylib texture holding the sprite sheet
    texture: rl.Texture2D,

    /// Number of sprites in the sheet
    spriteCount: i32,
    /// Width of each sprite
    spriteWidth: f32,
    /// Height of each sprite
    spriteHeight: f32,

    /// Width of the sprite sheet
    sheetWidth: f32,
    /// Height of the sprite sheet
    sheetHeight: f32,

    /// Returns a configured SpriteSheet
    pub fn init(alloc: std.mem.Allocator, path: [:0]const u8, config: SpriteSheetConfig) !*SpriteSheet {
        const self = try alloc.create(SpriteSheet);

        self.image = try rl.loadImage(path);
        self.texture = try rl.loadTextureFromImage(self.image);

        self.spriteCount = config.spriteCount;
        self.spriteWidth = config.spriteWidth;
        self.spriteHeight = config.spriteHeight;

        self.sheetWidth = config.sheetWidth;
        self.sheetHeight = config.sheetHeight;

        return self;
    }

    /// Unloads the SpriteSheet texture and image
    pub fn deinit(self: *SpriteSheet) void {
        rl.unloadTexture(self.texture);
        rl.unloadImage(self.image);
    }

    /// Returns a Sprite from a SpriteSheet
    pub fn getSprite(self: *SpriteSheet, posX: i32, posY: i32, x: i32, y: i32, rotation: f32, scale: f32, speed: f32, animated: bool, frameCount: i32) Sprite {
        return Sprite{
            .sheet = self,

            .source = rl.Rectangle{
                .x = utils.itf(posX) * self.spriteWidth,
                .y = utils.itf(posY) * self.spriteHeight,
                .width = self.spriteWidth,
                .height = self.spriteHeight,
            },
            .dest = rl.Rectangle{
                .x = utils.itf(x),
                .y = utils.itf(y),
                .width = self.spriteWidth * scale,
                .height = self.spriteHeight * scale,
            },
            .origin = rl.Vector2{
                .x = @divExact(self.spriteWidth * scale, 2),
                .y = @divExact(self.spriteHeight * scale, 2),
            },

            .rotation = rotation,
            .scale = scale,
            .speed = speed,

            .animated = animated,
            .frameCount = frameCount,
        };
    }
};

/// Represents a singular sprite
pub const Sprite = struct {
    /// The SpriteSheet
    sheet: *SpriteSheet,

    /// Rectangle representing the sprite on the SpriteSheet
    source: rl.Rectangle,
    /// Rectangle representing the position of the rendered sprite
    dest: rl.Rectangle,
    /// Sprite's rotation/scaling origin; relative to the destination rectangle
    origin: rl.Vector2,

    /// Sprite's rotation
    rotation: f32 = 0.00,
    /// Sprite's scale
    scale: f32 = 2.5,
    /// Sprite's movement speed
    speed: f32,

    /// Whether or not to run sprite animations
    animated: bool,
    /// Current Animation (number representing row of sprite sheet the current animation is on)
    currentAnimation: i32 = 1,
    /// Sprite's animation speed; will be divided by the number of frames to determine the actual speed
    animationSpeed: f32 = 20,
    /// Represents the current frame of the animation
    currentFrame: i32 = 1,
    /// Number of frames in the animation
    frameCount: i32,
    /// Animation tick counter
    counter: i32 = 0,

    /// Draws the sprite
    pub fn draw(self: *Sprite) void {
        // Calculate when to update the animation frame if this sprite is animated
        if (self.animated) {
            // Update frame if needed
            if (utils.itf(self.counter) == (self.animationSpeed / utils.itf(self.frameCount))) {
                self.currentFrame += 1;
                self.counter = 0;
            }
            // Make sure we stay within the number of frames
            if (self.currentFrame > self.frameCount)
                self.currentFrame = 1;

            // Update frame location on sprite sheet
            self.source.x = utils.itf(self.currentFrame - 1) * self.sheet.spriteWidth;
            self.source.y = utils.itf(self.currentAnimation - 1) * self.sheet.spriteHeight;

            // Update counter
            self.counter += 1;
        }
        rl.drawTexturePro(self.sheet.texture, self.source, self.dest, self.origin, self.rotation, rl.Color.white);
    }
};
