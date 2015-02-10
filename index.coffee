express = require "express"
os = require "os"
fs = require "fs"

punks = {}
configure_punks = (punkfile) ->
	if fs.existsSync(punkfile)
		console.log "[FYI] Reading in punkfile at #{punkfile}"
		require punkfile
	else
		console.log "[Little Problem] Could not find punkfile at #{punkfile}, so I do not know where your other punks are. This program will not run in parallel"
		# define at least one lonely punk
		{os.hostname(): {address: "127.0.0.1", port: 3000}}


module.exports =
	punks: punks
	init: (punkfile = "punkfile.json") ->
		punks = configure_punks punkfile
		comm_layer = express()
		selfpunk = punks[os.hostname()]
		server = comm_layer.listen selfpunk.port, ->
			console.log "This punk is up to no good at #{selfpunk.address}:#{selfpunk.port}"


	send: (message, to_punk) ->
		console.log "Sending message [#{message}] to punk [#{to_punk}]"

	read_message: (from_punk) ->
		console.log "Reading message from [#{from_punk}]"
		return {hello: "punk"}
