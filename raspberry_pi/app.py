# import paho.mqtt.client as mqtt
# from gpiozero import LOAD

# load = LOAD(17)
# maxHeat = 24


# # The callback for when the client receives a CONNACK response from the server.
# def on_connect(client, userdata, flags, rc):
#     print("Connected with result code "+str(rc))
 
#     # Subscribing in on_connect() - if we lose the connection and
#     # reconnect then subscriptions will be renewed.
#     client.subscribe("magicHeat/load")
#     client.subscribe("magicHeat/sensor1")

 
# # The callback for when a PUBLISH message is received from the server.
# def on_message(client, userdata, msg):
#     data = str(msg.payload).decode("utf-8")
#     print(msg.topic+" "+ str(msg.payload).decode("utf-8"))

#     if msg.topic == 'magicHeat/load':
#         if data == "on":
#             load.on()
#         else:
#             load.off()


#     if msg.topic == 'magicHeat/heat':
#         if data >= maxHeat:
#             load.off()


# # Create an MQTT client and attach our routines to it.
# client = mqtt.Client()
# client.on_connect = on_connect
# client.on_message = on_message
 
# client.connect('raspberry ip address', 1883, 60)
 
# # Process network traffic and dispatch callbacks. This will also handle
# # reconnecting. Check the documentation at
# # https://github.com/eclipse/paho.mqtt.python
# # for information on how to use other loop*() functions
# client.loop_forever()