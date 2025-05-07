# Godot Cutscene System

A simple cutscene system for Godot 4.x that allows you to create cinematic sequences by combining reusable components.

## Features

- Component-based architecture for easy reuse and composition
- Built-in components for common cutscene actions:
  - Dialog display with typewriter effect
  - Camera switching
  - Showing/hiding nodes
- Automatic player control handling during cutscenes
- Easy to extend with custom components

## Usage

1. Create a new scene and add a `Cutscene` node as the root
2. Add cutscene component nodes as children (Dialog, SwitchCamera, ShowNodes, etc.)
3. Configure the components' properties in the inspector
4. Call the `play()` method on the Cutscene node to start the sequence

## Example

An example scene is included that demonstrates the following common patterns:

- Blue Ball: The player's avatar. Only responds to input when a cutscene isn't playing.
- Green Ball: An NPC. Green ball will say a few things until you've exhausted their dialog.
- Red Ball: An NPC. Red ball will always say the same thing.
- Yellow Ball: An NPC. Yellow ball will say one thing before disappearing.
