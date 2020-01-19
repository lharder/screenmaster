# Screenmaster

Manages screen handling in a game by naming convention:

1. Include a gameobject for every level in the game's main collection (e.g. ID = "levealA", "levelB", ... )

2. Add a collectionproxy with ID = "proxy" to each level gameobject ("levelA#proxy") with the appropriate collection selected

3. Add a screenmaster gameobject (e.g. ID = "screenmaster") to the collection and add the screenmaster.script to it

4. From any other gameobject, send a message to the screenmaster gameobject to load a new screen:

####Load a new level:
<code>
msg.post( "main:/screenmaster", "load", { level = "levelA" } )
</code>

