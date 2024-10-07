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

## Descriptors
`rr/descriptors` - lists all descriptors. Name and short desc
`rr/descriptors/[descriptors]` - lists the details for the specific descriptors


## Character Gen

`rr/set/type` - Displays an error and the available Types (rr/types)
`rr/set/type/[type]` - Sets the type to the character
`rr/set/tier/[tier]` - Sets the tier for the character and updates settings (WIP)

`rr/set/sa` - Shows Special Abilities that have options that have not yet been set
`rr/set/sa/[Ability Name]` - Sets the available options for the Special Ability
`rr/set/sa/[Ability Name]/option1,option2` - Sets the Special Ability with those options

`rr/remove/sa` = Removes all Special Abilities on the character
`rr/remove/sa/[tiernumber]` - Removes the Special Abilities for that tier

`rr/set/focus` - Shows all Focuses available 
`rr/set/focus/[focus]` - Sets the selected focus on the character

`rr/remove/focus` = Removes the Focus on the character

`rr/set/descriptor` - Shows all Descriptors available
`rr/set/descriptor/[descriptor]` - Sets the selected descriptor on the character

`rr/remove/descriptor` = Removes the Descriptor on the character

`rr/set/moves` - Shows all moves for the Type set. (output needs fixing)
`rr/set/move/[move]` - Sets the selected move on the character

`rr/remove/moves` = Removes all Moves on the character
`rr/rmove/moves/[move]` - Remove the Move on the character


`rr/sheet` - Gives a very basic output of the current characters sheet - for testing at the moment.
