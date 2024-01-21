# Entities

Here are my thoughts on entities right now.
## Players
Players are those who can play in a game of bocce.
Some are controlled by you, and some are AI based.

Each `Player` comes in two flavors: `OverworldPlayer` and `BoccePlayer`

_Overworld_ players are disabled when a game of bocce ball is started, and a corresponding _Bocce_ player is created.
When the bocce game is finished, we'll disable _those_ entities and re-enable the Overworld variants.

The pro this is that we can keep logic pertaining to the overworld and bocce games completely separate, since the two have wildly different requirements.

The con is that the inheritance structure is pretty confusing:
```
              |----OverworldControllablePlayer
              |
              |----OverworldBoccePlayer (NPC)
              |
BasePlayer----|                       |----BocceControllablePlayer
              |----BaseBoccePlayer----|
                                      |----BocceAiPlayer (NPC)
```
