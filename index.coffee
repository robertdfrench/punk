util = require("util")

punk = {}
punk.log = (msg) ->
	ts = new Date()
	console.log("[punk] " + ts + " : " + msg)

boot_compute_service = (ctx) ->
	punk.log("Booting Compute Service")
	sub = context.socket('SUBSCRIBE')
	sub.connect('compute')

api_actions = {}
api_actions.load_client = (req, res, ctx) ->
	punk.log("Responding to /")
	res.send('Hello World!')
api_actions.ping = (req, res, ctx) ->
	punk.log("Responding to /ping")

boot_console_service = (ctx) ->
	punk.log("Booting Console Service")
	pub = ctx.socket('PUBLISH')
	pub.connect('compute', ->
		start_rest_app(pub)
	)

start_rest_app = (pub) ->
	punk.log("Starting Rest app")
	express = require "express"
	app = express()
	app.get('/', (req, res) ->
		api_actions.load_client(req, res, ctx)
	)
	app.get('/ping', (req,res) ->
		api_actions.ping(req, res, ctx)
	)
	server = app.listen(3000, ->
		host = server.address().address
		port = server.address().port
		msg = util.format('Console service listening at http://%s:%s', host, port)
		punk.log(msg)
	)

disconnect_from_broker = (ctx) ->
	punk.log("disconnecting from broker")
	ctx.close()

connect_to_broker = (callback, address="localhost") ->
	broker_uri = "amqp://" + address
	punk.log("connecting to message broker at " + broker_uri)
	context = require('rabbit.js').createContext(broker_uri)
	context.on('ready', ->
		callback(context)
	)
	context.on('error', (msg) ->
		punk.log(util.format("Broker Context Error (%s)",msg))
	)
	process.on('SIGINT', ->
		disconnect_from_broker(context)
	)

read_options = ->
	punk.log("reading command line options")
	argv = require "argv"
	argv.info(' Punk. Invoke with console or compute ')
	argv.version("0.0.0")
	argv.option({name: "amqp-broker", short: "b", type: "string"})
	argv.option({name: "http-port", short: "p", type: "int"})
	return argv.run()

bootloader = ->
	punk.log("booting")
	args = read_options()
	mode = args["targets"][0]
	if mode == "compute"
		connect_to_broker(boot_compute_service)
	else if mode == "console"
		connect_to_broker(boot_console_service)
	else
		punk.log("You gotta tell me compute or console")

bootloader()
