---
toc: Recursive Realms
summary: Commands.
---
# Recursive Realms
The `rr` command is the base of everything Recursive Realms.  You can list the Character Types and dig into them etc. 


`rr` - Shows command usage.

## Character Types
`rr/types` - Display all the character types available to players.
`rr/types/[type]` - Substitute [type] for a known Character type and get all the details on it.  ie. rr/types/vector
`rr/types/[type]/tiers` - Substitute [type] for a known Character type and display all the Tier details for the type.  ie. rr/types/vector/tiers
`rr/types/[type]/sa` - Substitute [type] for a known Character type and display all the Special Abilities for the type.  ie. rr/types/vector/sa
`rr/types/[type]/moves` - Substitute [type] for a known Character type and display all the Moves for the type.  ie. rr/types/vector/moves
`rr/types/[type]/full` - Substitute [type] for a known Character type and get all the details on it.  ie. rr/types/vector/full

Permitted Character Types:
Vector
Paradox
Spinner

## Focus
`rr/focus` - lists all focuses. Name and short desc
`rr/focus/[focus]` - lists the details for the specific focus


## Character Gen

`rr/set/type` - Displays an error and the available Types (rr/types)
`rr/set/type/[type]` - Sets the type to the character
`rr/set/tier/[tier]` - Sets the tier for the character and updates settings (WIP)

`rr/sheet` - Gives a very basic output of the current characters sheet - for testing at the moment.
