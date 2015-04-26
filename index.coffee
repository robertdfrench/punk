boot_compute_service = ->
	console.log("Booting Compute Service")
	context = broker_context()

api_actions = {}
api_actions.load_client = (req, res) ->
	res.send('Hello World!')

boot_console_service = ->
	console.log("Booting Console Service")
	express = require "express"
	app = express()
	app.get('/', api_actions.load_client)
	server = app.listen(3000, ->
		host = server.address().address
		port = server.address().port
		console.log('Console service listening at http://%s:%s', host, port)
	)


broker_context = ->
	require('rabbit.js').createContext('amqp://localhost')

read_options = ->
	argv = require "argv"
	argv.info(' Punk. Invoke with console or compute ')
	argv.version("0.0.0")
	argv.option({name: "broker", short: "b", type: "string"})
	argv.option({name: "port", short: "p", type: "int"})
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
