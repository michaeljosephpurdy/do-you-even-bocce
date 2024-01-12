
# Do You Even Bocce?

## Overview

A **Playdate** game where you play bocce ball ([wiki](https://en.wikipedia.org/wiki/Bocce)).

## Vertical Slice

You have a match against a (CPU) opponent.
There is one 'jack' ball, and each player gets 4 'bocce' balls.

Random participant (aka: you or computer) start by throwing jack ball.
Then take turns throwing your balls, trying to get as close to jack ball as you can.

During each players turn they will:

* move their player
  * limited to specific _throw zone_.
* set direction of their throw
  * input direction with crank (or with d-pad)
* set power of their throw
  * time their button press with dynamic progress bar
* (potentially) set spin on their throw
  * time their button press with dynamic progress bar

## The Story

You're a down on your luck detective, having blown a major case in the big city.

To take your mind off of it all, you leave the big city, and plan to drive across the country.

Your car breaks down though, near the end of the first day on the road, at a small town.

You go to the mechanic, and need to wait for parts to come in, more than a couple of days.
Mechanic says they have a room for rent, so you stay there.

The mechanics son goes missing that night.
The local sheriff realizes who you are, and asks you to help.

## The Game Loop

> "But Mike, why do we have to have a story?"
We need a forcing function for the player to explore, outside of 'exploring for exploring sake'.
A story, especially a decent one, will be that.

Some games get away with less story than others.
An example that comes to mind is the original Pokemon.
Pokemon Red and Blue (or Green if you were in JP) got away with a relatively weak story because the gameplay was so revolutionary.
The 'weak story' is:

> You, like probably every kid in this world, want to be a Pokemon Master.
> You are introduced to a kid (Professor Oak's son) and are told that this is your rival.
> Go travel to become a Pokemon Master

Not really a story, though Team Rocket is introduced further in the game for some story elements.

No, the story is definitely  not the _pull_.  I'd argue the main _pull_ for players are the following goals:

1. get more (all) Pokemon
2. level up/evolve your existing Pokemon
3. get gym badges
  a. become a Pokemon master

There are a few mechanisms that are leveraged to allow you to get to that goal:

Random encounters are sought after in Pokemon because it brings you the ability fulfill goals #1 and #2.

Trainer battles help fulfill goal #2, but can be argued to hinder the rest of the goals!
Since players don't have the opportunity to _run_ from the battles, they may end up with all their Pokemon fainted, and find themselves back at the last Pokemon center.
This is counteracted by giving the players an opportunity to try to circumvent the battle entirely.

Exploration of the world is forced upon players by all three of these goals.
Players know they need to explore to find new Pokemon to catch.
Any Pokemon they encounter, either in trainer battles or random encounters will help them gain experience, allowing their Pokemon to level up and in most cases, evolve.
And you don't know where these gyms are, so you need to go find them.

---

When thinking about "Do You Even Bocce?", what would the main _pull_ for players be, and what are the goals of the game?

The goals:

1. win bocce games
2. solve a mystery (story)

Additional goals that I'm thinking about:
* collecting more bocce balls!
  * maybe after you beat a player they give you their bocce balls; and you can collect them all

Uncovering the mystery acts as the forcing function (outside of exploring for the fun of it) for you to travel the area.
Traveling the area triggers bocce ball games, similar to trainer fights.

There are no random-encounters.

