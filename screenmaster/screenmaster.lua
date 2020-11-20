local Screenmaster = {}

function Screenmaster.get()
	if Screenmaster.inst == nil then
		local this = {}
		this.screenname = nil
		
		function this:load( screenname )
			local url = nil

			-- unload the current level first
			if this.screenname then
				url = this.screenname .. "#proxy"
				msg.post( url, "release_input_focus" )
				msg.post( url, "unload" ) 
			end

			-- load the new level as current
			url = screenname .. "#proxy"
			msg.post( url, "load" )
			this.screenname = screenname

			-- send user input to the new level
			msg.post( url, "acquire_input_focus" )
		end
		

		function this:getScreenname()
			return this.screenname
		end

		
		Screenmaster.inst = this
	end

	return Screenmaster.inst
end


return Screenmaster.get()
