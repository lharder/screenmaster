local Screenmaster = {}

function Screenmaster.get()
	if Screenmaster.inst == nil then
		local this = {}
		this.screenname = nil
		
		function this:load( screenname, messages )
			local url = nil

			-- unload the current level first
			if this.screenname then
				url = this.screenname .. "#proxy"
				msg.post( url, "release_input_focus" )
				msg.post( url, "unload" ) 
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
				if messages then 
					timer.delay( 0.1, false, function()
						for url, message in pairs( messages ) do
							msg.post( url, "screenmaster:loaded", message )
						end
					end )
				end
				
			end)
		end
		

		function this:getScreenname()
			return this.screenname
		end

		
		Screenmaster.inst = this
	end

	return Screenmaster.inst
end


return Screenmaster.get()
