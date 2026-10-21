# Changelog

## Unreleased

## 2.1.1 - 2026-10-21

- Fixed the game not starting when a keybind was saved with the numpad + key (MSU can't read it back). Such key combinations are now dropped from the saved keybinds at startup, with a warning in the log.
- Fixed a crash with Legends versions where items' `isChangeableInBattle` takes no entity. Extra Keybinds now works with either kind.
