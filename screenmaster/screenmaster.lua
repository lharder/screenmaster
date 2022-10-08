local Screenmaster = {}

local function unload( screenname )
	if screenname then
		url = screenname .. "#proxy"
		msg.post( url, "release_input_focus" )
		msg.post( url, "unload" ) 
	end
end


local function sendInitMessages( messages )
	if messages then 
		timer.delay( 0.1, false, function()
			for url, message in pairs( messages ) do
				msg.post( url, "screenmaster:loaded", message )
			end
		end )
	end
end


function Screenmaster.get()
	if Screenmaster.inst == nil then
		local this = {}
		this.screenname = nil
		
		function this:load( screenname, messages )
			local url = nil

			-- unload the current level first
			if this.screenname then
				unload( this.screenname )
			end

			-- allow for unloading to complete: important
			-- if a reload of the same level is intended!
			timer.delay( 0.1, false, function()
				-- load the new level as current
				url = screenname .. "#proxy"
				msg.post( url, "load" )
				this.screenname = screenname
				
				-- send user input to the new level
				msg.post( url, "acquire_input_focus" )

				-- allow for initialization messages to be  
				-- sent after loading a new screen
				sendInitMessages( messages )			
			end )
		end


		function this:loadOverlay( overlayname, messages )
			-- unload the current level first
			if this.screenname then
				-- freeze time in active level
				local url = msg.url( nil, this.screenname, "proxy" )
				pprint( "Freeze " .. url )
				msg.post( url, "set_time_step", { factor = 0, mode = 0 })
			end

			-- load the overlay on top of the frozen level
			local url = overlayname .. "#proxy"
			msg.post( url, "load" )
			
			-- send user input to the new level
			msg.post( url, "acquire_input_focus" )

			-- allow for initialization messages to be  
			-- sent after loading a new screen
			sendInitMessages( messages )
		end


		function this:removeOverlay( overlayname )
			unload( overlayname )

			local url = msg.url( nil, this.screenname, "proxy" )
			pprint( "Unfreeze " .. url )
			msg.post( url, "set_time_step", { factor = 1, mode = 0 })
		end
		

		function this:getScreenname()
			return this.screenname
		end

		
		Screenmaster.inst = this
	end

	return Screenmaster.inst
end


return Screenmaster.get()
