import time
import json
import paho.mqtt.client as mqtt
from sense_hat import SenseHat
from colorsys import hsv_to_rgb

MQTT_BROKER = "mqtt.htl.services"
MQTT_PORT = 1883
MQTT_KEEPALIVE_INTERVAL = 60
MQTT_PUB_TOPIC = "htlstp/4BHIF/gruber"
MQTT_SUB_TOPIC = "htlstp/4BHIF/led"
MQTT_USERNAME = "htlstp"
MQTT_PASSWORD = "nopass2day!"

sense = SenseHat()

latest_temperature = 0
latest_humidity = 0
latest_pressure = 0

def on_connect(client, userdata, flags, rc):
    print(f"Connected with result code {rc}")
    client.subscribe(MQTT_SUB_TOPIC)

def on_message(client, userdata, msg):
    try:
        index = int(msg.payload.decode())
        print(f"Message received on topic {msg.topic}: {index}")
        if 0 <= index <= 63:
            wave_effect(index)
    except ValueError:
        print("Invalid message payload")

def on_disconnect(client, userdata, rc):
    if rc != 0:
        print(f"Unexpected disconnection. Reconnecting...")
        client.reconnect()

def on_log(client, userdata, level, buf):
    print(f"Log: {buf}")

client = mqtt.Client()

client.username_pw_set(MQTT_USERNAME, MQTT_PASSWORD)

client.on_connect = on_connect
client.on_message = on_message
client.on_disconnect = on_disconnect
client.on_log = on_log

client.connect(MQTT_BROKER, MQTT_PORT, MQTT_KEEPALIVE_INTERVAL)

def publish_sensor_data():
    global latest_temperature, latest_humidity, latest_pressure
    while True:
        latest_temperature = sense.get_temperature()
        latest_humidity = sense.get_humidity()
        latest_pressure = sense.get_pressure()

        payload = {
            "temperature": latest_temperature,
            "humidity": latest_humidity,
            "pressure": latest_pressure
        }

        payload_json = json.dumps(payload)

        client.publish(MQTT_PUB_TOPIC, payload_json)
        print(f"Published: {payload_json}")

        time.sleep(10)

def hsv_to_rgb_normalized(h, s, v):
    rgb = hsv_to_rgb(h, s, v)
    return tuple(int(255 * c) for c in rgb)

def wave_effect(start_index):
    sense.clear()
    x_start = start_index % 8
    y_start = start_index // 8

    hue = (latest_temperature / 40) % 1.0  # Normalize temperature to [0, 1] (assuming max 40°C)
    saturation = latest_humidity / 100.0  # Normalize humidity to [0, 1]
    value = (latest_pressure - 900) / 200.0  # Normalize pressure to [0, 1] (assuming range 900-1100 hPa)

    for radius in range(8):
        color = hsv_to_rgb_normalized((hue + radius / 8.0) % 1.0, saturation, value)
        for x in range(max(0, x_start - radius), min(8, x_start + radius + 1)):
            for y in range(max(0, y_start - radius), min(8, y_start + radius + 1)):
                if abs(x - x_start) == radius or abs(y - y_start) == radius:
                    sense.set_pixel(x, y, color)
        time.sleep(0.1)

    time.sleep(1)
    sense.clear()

client.loop_start()

try:
    publish_sensor_data()
except KeyboardInterrupt:
    client.loop_stop()
    client.disconnect()
    print("Disconnected from MQTT broker")
