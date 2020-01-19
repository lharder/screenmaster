local scm = {}
scm.levels = {}
scm.current = nil


function scm:register( proxyname, props )
	scm.levels[ proxyname ] = props or {}
end


function scm:load( proxyname, callback )
	local previous = scm.current
	scm.current = proxyname
	 
	if previous then msg.post( previous, "unload" ) end

	local url = "main:/screenmaster#" .. proxyname
	msg.post( url, "load" )
end




return scm