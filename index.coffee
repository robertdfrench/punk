punk_log = (msg) ->
	date = new Date()
	console.log("[punk] " + date +  " " + msg)

boot_compute_service = ->
	console.log("Booting Compute Service")
	context = broker_context()

boot_console_service = ->
	console.log("Booting Console Service")
	express = require "express"
	context = broker_context()

broker_context = ->
	require('rabbit.js').createContext('amqp://localhost')

read_options = ->
	argv = require "argv"
	argv.info(' Punk. Invoke with console or compute ')
	argv.version("0.0.0")
	argv.option({name: "broker", short: "b", type: "string"})
	args = argv.run()
	console.log(args["targets"][0])
	mode = args["targets"][0]
	if mode == "compute"
		boot_compute_service()
	else if mode == "console"
		boot_console_service()
	else
		console.log("You gotta tell me compute or console")

read_options()
