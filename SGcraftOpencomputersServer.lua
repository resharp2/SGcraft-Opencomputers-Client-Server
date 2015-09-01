component=require("component")
event=require("event")
sgserverchannel=421
print("Stargate Command and Control Version 0.2(Alpha): Online")
 
print("Opening connection....")
component.modem.open(sgserverchannel)
print("Waiting for command computer....")
address, a, b, c, d, stuff, sgaddy, cchannel = event.pull("modem")
 
while (stuff ~= "exit") do
	--component.modem.open(sgserverchannel)
 
	if stuff == "dial" then
		if component.stargate.irisState()=="Closed" then
			print("Iris closed")
			print("Opening Iris")
			component.stargate.openIris()
		end
		if component.stargate.stargateState()=="Connected" then
			print("Disconnecting: " .. component.stargate.remoteAddress())
			component.stargate.disconnect()
			stuff=component.stargate.stargateState()
			print("Stargate unable to dial please wait.")
			while (stuff~="Idle") do
				stuff=component.stargate.stargateState()
			end
			print("Dialing: " .. sgaddy)
			component.modem.broadcast(cchannel, "Dialing: " .. sgaddy)
			component.stargate.dial(sgaddy)
		elseif component.stargate.stargateState()=="Idle" then
			print("Dialing: " .. sgaddy)
			component.modem.broadcast(cchannel, "Dialing: " .. sgaddy)
			component.stargate.dial(sgaddy)
			
		end
	elseif stuff=="disconnect" then
		component.stargate.disconnect()
		print("Disconnected from " .. component.stargate.remoteAddress())
		component.modem.broadcast(cchannel, "Disconnected from "..component.stargate.remoteAddress())
 
	elseif stuff=="statusrequest" then
		print("Responding to Status Request from client: " ..b)
		component.modem.broadcast(cchannel, "Online")
		
	end
	component.modem.close(sgserverchannel)
	component.modem.open(sgserverchannel)
	print("Request Completed")
	address, a, b, c, d, stuff, sgaddy, cchannel = event.pull("modem")
	print("New data received from channel: " .. cchannel)
end
 
if component.stargate.stargateState()~="Idle" then
	print("Preparing for system shutdown")
	print("Closing all connections")
	component.stargate.disconnect()
	print("Closing Iris")
	component.stargate.closeIris()
	component.modem.broadcast(cchannel, "confirm")
	print("System shutdown complete")
else
	component.stargate.closeIris()
	component.modem.broadcast(cchannel, "confirm")
	print("System shutdown complete")
end
