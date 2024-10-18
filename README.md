# CHUTNEY


## Abstract

This is a repository for AAA Game Jam.


## Installation 

No install needed for now. Just clone this repository with the following commands; 

For https :

```bash
git clone https://github.com/ParisRomane/CHUTNEY.git
```

For ssh :

```bash
git clone git@github.com:ParisRomane/CHUTNEY.git
```

## File organisation

The project is organise with the following architecture :

### assets : It is where we put every assets of the game
### camera : Camera and camera controller scene and script directory.
### entities : All the entities we consider as they are.
### globals : All scenes or scripts used as autoloads or singleton.
### levels : The levels or sublevels of the game (excluding menu and ui).
### menu and ui : Other scenes for menus and ui
### tools : Developer tools and all scripts with incidence inside the Godot editor (keyword @tool).

## Dev tutorial

Please refer to the GDScript style guide (https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) for your script style.
You can find an example in `docs_and_example/my_class.gd`.

For the scene and node naming : use PascalCase for node name inside the editor and snake_case for name the scenes (.tscn files).

For documentation, please read the following Godot's official tutorial : https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_documentation_comments.html.
