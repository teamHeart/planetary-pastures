# Planetary Pastures Copilot Instructions

Planetary Pastures is a Godot 4.6 incremental farming game about growing alien plants to generate energy for Little Green's ship (`README.md`, `project.godot`).

## Build, test, and lint commands

```bash
# Run the game from the repository's bundled editor binary
./Godot-Bin/godot --path .

# Headless smoke test of the main project
./Godot-Bin/godot --headless --path . --quit

# Focused smoke test of the standalone test scene
./Godot-Bin/godot --headless --path . --scene res://src/Scenes/test_scene.tscn --quit

# Lint GDScript when gdlint is installed on PATH (rules live in gdlintrc)
gdlint src/

# Lint a single script
gdlint src/Scenes/game_manager.gd
```

Notes:

- The repository pins a local editor binary at `./Godot-Bin/godot` and VS Code is configured to use it.
- There is no checked-in export preset or separate build script at the moment.
- There is no checked-in automated unit test framework yet; `test_scene.tscn` is the closest thing to a focused single-scene smoke test.
- Headless runs currently exit `0` but print a `signal_lens` unregister error during shutdown because of the autoloaded plugin setup in `project.godot`.

## High-level architecture

- `project.godot` starts `src/Scenes/game_scene.tscn`. The top-level scene is composed around `GameManager`, `GameScene`, `GameScene/CanvasLayer/UILayer`, `GameScene/MapNode`, `GameScene/MapNode/Garden`, `GameScene/LittleGreen`, and `GameScene/CameraSystem`.
- `src/Scenes/game_manager.gd` is the gameplay coordinator. It connects UI signals, iterates every `GardenPlot` child under `Garden`, listens for plot lifecycle signals, updates inventory and watt totals, and translates clicks/tool selection into queued actions for `LittleGreen`.
- `src/Sub-Scenes/Actors/Little Green/little_green.gd` is the active worker/agent. Its real execution path is the dictionary-backed `_action_queue` with string action types such as `move_to_plot`, `process_plot`, `water_plot`, and `fertilize_plot`. The typed action classes under `src/Utility/Actions/` exist, but they are only partially implemented and are not the main gameplay path yet.
- `src/Sub-Scenes/Garden Plot/gargen_plot.gd` owns the simulation for a single plot: click handling, planted/watered/fertilized/grown state, progress bars, timers, and plot signals. Growth timing is driven here, not in `GameManager`.
- `src/Sub-Scenes/Plants/util/plant.gd` is the visual/runtime wrapper for a plant instance, while `src/Sub-Scenes/Plants/util/plant_details.gd` plus the `.tres` files in `src/Sub-Scenes/Plants/` define plant data such as timings, yield, textures, and grown animations.
- `src/Scenes/ui_layer/ui_layer.gd` is the keyboard-driven tool selector and watt counter. It emits `tool_selected` and `request_tool_qty`, and `GameManager` treats it as the source of truth for the currently held tool.
- `src/Upgrades/parameters.gd`, `src/Upgrades/upgrade.gd`, and `src/Upgrades/settings.gd` hold tunable gameplay parameters and upgrade metadata. Current movement, watering, and fertilizing speeds are read directly from `Parameters`.

## Key conventions

- `Tool.Type` and `PlantDetails.PlantType` intentionally share numeric values for seed items. Seed/tool IDs start at `5 + 10`, and the codebase relies on casts between the two enums plus checks like `tool > 10` to decide whether the current tool is a seed. Preserve that mapping when adding tools or plants.
- Adding a new plant is a cross-file change: add/update the `PlantDetails.PlantType` enum and name map, wire the matching preload in `Plant`, add the corresponding seed/tool resource, and preload/select it in `ui_layer.gd` if it should be user-selectable.
- Plot identity is runtime-generated. `GardenPlot` assigns `plot_id` and renames itself to `Plot_<id>` in `_enter_tree()`, so code usually refers to plots by signal payloads or `plot_id` rather than by hard-coded node paths.
- Signal wiring is centralized. New plot events should usually be connected in `GameManager.connect_plot_signals()`, and new UI tool interactions should flow through the existing `tool_selected` / `request_tool_qty` signals instead of reaching into gameplay nodes directly.
- State is intentionally split between scene scripts and resources: `.gd` files own behavior, while `.tres` resources hold plant/tool/upgrade data. Prefer changing resource data over hard-coding plant-specific values into logic.
- GDScript style is enforced by `gdlintrc`: snake_case function/variable names, PascalCase `class_name`, max line length `100`, tabs instead of spaces, and the documented class member ordering. The action subclasses intentionally use inline `# gdlint:ignore = class-name` where the existing naming diverges.
