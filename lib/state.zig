// Copyright 2025 Talin Sharma. Subject to the Apache-2.0 license.
//! Contains structures to define the game's global state & config

const GlobalConfig = struct {
    PLAYER_SCALE: f32 = 2.5,
    PLAYER_SPEED: f32 = 100,
};

pub const CONFIG = GlobalConfig{};
