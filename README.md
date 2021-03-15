# Screenmaster

Manages screen handling in a game by naming convention:

1. Include a gameobject for every level in the game's main collection (e.g. ID = "levealA", "levelB", ... )

2. Add a collectionproxy with ID = "proxy" to each level gameobject ("levelA#proxy") with the appropriate collection selected

3. Add a screenmaster gameobject (e.g. ID = "screenmaster") to the collection and add the screenmaster.script to it

4. From any other gameobject, send a message to the screenmaster gameobject to load a new screen:

####Load a new level:
	msg.post( "main:/screenmaster", "load", { level = "levelA" } )

Optionally, you may want to pass on some information from one screen to the next. While this scenario can be solved with global variables, Screenmaster allows for arbitrary messages to be passed to any game object in the newly loaded screen collection. 

In that case, load the next screen with a messages parameter:


	local messages = {}
	messages[ "levelB:/root" ] = { 
		value = "A sends some arbitray data to B..." 
	}

	msg.post( "main:/screenmaster" , "load", { 
		level = "levelB", 
		messages = messages 
	})

The messages parameter consists of a table with each recipient's URL as the key and a table of name/value pairs to be sent as payload. It is up to the recipient in the newly loaded screen collection to interpret that data. 

Incoming messages have the message_id = "screenmaster:loaded":

	function on_message( self, message_id, message, sender )
		if message_id == hash( "screenmaster:loaded" ) then
			pprint( "I received this message on initialization:" )
			pprint( message )
		end
	end
	
Results in:
	
	DEBUG:SCRIPT: I received this message on initialization:
	DEBUG:SCRIPT: 
	{ --[[0x10debd4c0]]
	  value = "A sends some arbitray data to B..."
	}

Screenmaster waits for about 1/10 of a second after loading the new screen before sending out the messages to allow for proper initialization of all gameobjects in the collection.