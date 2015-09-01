component=require("component")
event=require("event")
schannel=421
print("Starting ... Stargate Command and Control Client Version 0.1(Alpha)")
 
io.write("Specify Channel(must be numeric): ")
channel=io.read()
print("Opening connection on channel:" .. channel)
channel=tonumber(channel)
component.modem.open(channel)
 
print("Requesting Stargate Command and Control Server Status to " ..schannel)
component.modem.broadcast(schannel, "statusrequest", "nil", channel)
address, a, b, c, d, response = event.pull("modem")

if response=="Online" then
	cncserverstatus=response
else
	cncserverstatus="Offline"
end
print("Stargate Command and Control Server Status: " .. cncserverstatus)

activeclient=true
while (activeclient==true) do
	if cncserverstatus=="Online" then
		print("Please select an option: ")
		print("1: Dial")
		print("2: Disconnect")
		--print("3: open iris")
		--print("4: close iris")
		--print("5: Stargate Status")
		--print("6: Iris Status")
		print("7: Shutdown Client")
		print("8: Stargate Command and Control shutdown")
		io.write("option: ")
		command=io.read()

		if command == "1" then
			io.write("Which address: ")
			sgaddy=io.read()
			print ("Sending dialing request using address: " ..sgaddy)
			component.modem.broadcast(schannel, "dial", sgaddy, channel)
			print("waiting for response from Command and Control Server...")
			address, a, b, c, d, response = event.pull("modem")
			print(response)
		
		elseif command == "2" then
			print("Sending disconnect command...")
			component.modem.broadcast(schannel, "disconnect", "nil", channel)
			print("waiting for response from Command and Control Server...")
			address, a, b, c, d, response = event.pull("modem")
			print (response)
		
		elseif command == "7" then
			print("Closing ports")
			print("Exiting client")
			activeclient=false
			return
		
		elseif command == "8" then
			print("Sending shutdown command...")
			component.modem.broadcast(schannel, "exit", "nil", channel)
			print("Waiting for response from Command and Control Server")
			address, a, b, c, d, response = event.pull("modem")
			if response == "confirm" then
				print("Server Shutdown Confirmed.")
				cncserverstatus = "Offline"
			else
				print("WARNING: Server unresponsive it will require manual shutdown!")
				cncserverstatus = "Offline"
			end
		end
	else
		print("Please select an option:")
		print("1: Shutdown Client")
		io.write("option: ")
		command=io.read()
		if command=="1" then
			print("Closing ports")
			print("Exiting client")
			activeclient=false
			return
		end
	end
end
