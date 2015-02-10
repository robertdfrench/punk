express = require "express"

module.exports =
	init: (punkfile) ->
		console.log "Got my punkfile right here: #{punkfile}"

	send: (message, to_punk) ->
		console.log "Sending message [#{message}] to punk [#{to_punk}]"

	read_message: (from_punk) ->
		console.log "Reading message from [#{from_punk}]"
		return {hello: "punk"}
