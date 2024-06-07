
import time
import json
import paho.mqtt.client as mqtt
from sense_hat import SenseHat

MQTT_BROKER = "mqtt.htl.services"
MQTT_PORT = 1883
MQTT_KEEPALIVE_INTERVAL = 60
MQTT_PUB_TOPIC = "htlstp/4BHIF/gruber"
MQTT_SUB_TOPICS = [
    "htlstp/4BHIF/led",
    "htlstp/4BHIF/colorInit",
    "htlstp/4BHIF/colorWave",
    "htlstp/4BHIF/speed",
    "htlstp/4BHIF/smile"
]
MQTT_USERNAME = "htlstp"
MQTT_PASSWORD = "nopass2day!"

sense = SenseHat()

latest_temperature = 0
latest_humidity = 0
latest_pressure = 0
initial_color = (0, 0, 0)
wave_color = (255, 255, 255)
wave_speed = 100

color_map = {
    "red": (255, 0, 0),
    "green": (0, 255, 0),
    "blue": (0, 0, 255),
    "yellow": (255, 255, 0),
    "purple": (160,32,240),
    "orange": (255,165,0),
    "pink":(255, 192, 203),
    "teal":(0,128,128),
    "grey":(190,190,190),
}

smile_grid = [
    [(255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0)],
    [(255, 0, 0), (255, 255, 0), (255, 0, 0), (255, 255, 0), (255, 255, 0), (255, 0, 0), (255, 255, 0), (255, 0, 0)],
    [(255, 0, 0), (255, 0, 0), (255, 0, 0), (255, 255, 0), (255, 255, 0), (255, 0, 0), (255, 0, 0), (255, 0, 0)],
    [(255, 255, 0), (255, 0, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 0, 0), (255, 255, 0)],
    [(255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0)],
    [(255, 82, 82), (255, 255, 0), (0, 0, 0), (255, 255, 255), (255, 255, 255), (0, 0, 0), (255, 82, 82), (255, 255, 0)],
    [(255, 255, 0), (255, 82, 82), (255, 255, 0), (0, 0, 0), (0, 0, 0), (255, 255, 0), (255, 255, 0), (255, 82, 82)],
    [(255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0), (255, 255, 0)]
]


def on_connect(client, userdata, flags, rc):
    print(f"Connected with result code {rc}")
    for topic in MQTT_SUB_TOPICS:
        client.subscribe(topic)


def on_message(client, userdata, msg):
    global initial_color, wave_color, wave_speed

    payload = msg.payload.decode()
    print(f"Message received on topic {msg.topic}: {payload}")

    if msg.topic == "htlstp/4BHIF/led":
        try:
            index = int(payload)
            if 0 <= index <= 63:
                wave_effect(index)
        except ValueError:
            print("Invalid message payload for LED topic")

    elif msg.topic == "htlstp/4BHIF/colorInit":
        initial_color = parse_color(payload)
        sense.clear(initial_color)

    elif msg.topic == "htlstp/4BHIF/colorWave":
        wave_color = parse_color(payload)

    elif msg.topic == "htlstp/4BHIF/speed":
        try:
            wave_speed = int(payload)
        except ValueError:
            print("Invalid message payload for speed topic")

    elif msg.topic == "htlstp/4BHIF/smile":
        sense.set_pixels([color for row in smile_grid for color in row])
    elif msg.topic == "htlstp/4BHIF/data":
        if payload ==  "1":
            wave_color = random_color()
            initial_color = random_color()
            

def random_color():
    r = random.randint(0, 255)
    g = random.randint(0, 255)
    b = random.randint(0, 255)
    return (r, g, b)

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


def parse_color(color_string):
    if color_string in color_map:
        return color_map[color_string]
    else:
        return color_map["blue"]


def wave_effect(start_index):
    sense.clear(initial_color)
    x_start = start_index % 8
    y_start = start_index // 8

    for radius in range(1, 9):
        color = wave_color
        for x in range(max(0, x_start - radius), min(8, x_start + radius + 1)):
            for y in range(max(0, y_start - radius), min(8, y_start + radius + 1)):
                if abs(x - x_start) == radius or abs(y - y_start) == radius:
                    sense.set_pixel(x, y, color)
        time.sleep(wave_speed / 1000.0)
        for x in range(max(0, x_start - radius), min(8, x_start + radius + 1)):
            for y in range(max(0, y_start - radius), min(8, y_start + radius + 1)):
                if abs(x - x_start) == radius or abs(y - y_start) == radius:
                    sense.set_pixel(x, y, initial_color)

    time.sleep(1)
    sense.clear(initial_color)

client.loop_start()

try:
    publish_sensor_data()
except KeyboardInterrupt:
    client.loop_stop()
    client.disconnect()
    print("Disconnected from MQTT broker")

"""
import time
import json
import paho.mqtt.client as mqtt
from sense_hat import SenseHat

MQTT_BROKER = "mqtt.htl.services"
MQTT_PORT = 1883
MQTT_KEEPALIVE_INTERVAL = 60
MQTT_PUB_TOPIC = "htlstp/4BHIF/gruber"
MQTT_SUB_TOPICS = [
    "htlstp/4BHIF/led",
    "htlstp/4BHIF/colorInit",
    "htlstp/4BHIF/colorWave",
    "htlstp/4BHIF/speed",
    "htlstp/4BHIF/smile"
]
MQTT_USERNAME = "htlstp"
MQTT_PASSWORD = "nopass2day!"

sense = SenseHat()

latest_temperature = 0
latest_humidity = 0
latest_pressure = 0
initial_color = (0, 0, 0)
wave_color = (255, 255, 255)
wave_speed = 100

# Define colors
yellow = (255, 255, 0)
red = (255, 0, 0)
red_accent = (255, 82, 82)
black = (0, 0, 0)
white = (255, 255, 255)

smile_grid = [
    [yellow, yellow, yellow, yellow, yellow, yellow, yellow, yellow],
    [red, yellow, red, yellow, yellow, red, yellow, red],
    [red, red, red, yellow, yellow, red, red, red],
    [yellow, red, yellow, yellow, yellow, yellow, red, yellow],
    [yellow, yellow, yellow, yellow, yellow, yellow, yellow, yellow],
    [red_accent, yellow, black, white, white, black, red_accent, yellow],
    [yellow, red_accent, yellow, black, black, yellow, red_accent, yellow],
    [yellow, yellow, yellow, yellow, yellow, yellow, yellow, yellow]
]


def on_connect(client, userdata, flags, rc):
    print(f"Connected with result code {rc}")
    for topic in MQTT_SUB_TOPICS:
        client.subscribe(topic)


def on_message(client, userdata, msg):
    global initial_color, wave_color, wave_speed

    payload = msg.payload.decode()
    print(f"Message received on topic {msg.topic}: {payload}")

    if msg.topic == "htlstp/4BHIF/led":
        try:
            index = int(payload)
            if 0 <= index <= 63:
                wave_effect(index)
        except ValueError:
            print("Invalid message payload for LED topic")

    elif msg.topic == "htlstp/4BHIF/colorInit":
        initial_color = parse_color(payload)
        sense.clear(initial_color)

    elif msg.topic == "htlstp/4BHIF/colorWave":
        wave_color = parse_color(payload)

    elif msg.topic == "htlstp/4BHIF/speed":
        try:
            wave_speed = int(payload)
        except ValueError:
            print("Invalid message payload for speed topic")

    elif msg.topic == "htlstp/4BHIF/smile":
        display_smile()


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


def parse_color(color_string):
    try:
        color_hex = color_string.split('Color (')[1].split(')')[0]
        color_int = int(color_hex, 16)
        r = (color_int >> 16) & 0xFF
        g = (color_int >> 8) & 0xFF
        b = color_int & 0xFF
        return (r, g, b)
    except (IndexError, ValueError):
        print("Invalid color format")
        return (0, 0, 0)


def wave_effect(start_index):
    sense.clear(initial_color)
    x_start = start_index % 8
    y_start = start_index // 8

    for radius in range(1, 9):
        color = wave_color
        for x in range(max(0, x_start - radius), min(8, x_start + radius + 1)):
            for y in range(max(0, y_start - radius), min(8, y_start + radius + 1)):
                if abs(x - x_start) == radius or abs(y - y_start) == radius:
                    sense.set_pixel(x, y, color)
        time.sleep(wave_speed / 1000.0)
        for x in range(max(0, x_start - radius), min(8, x_start + radius + 1)):
            for y in range(max(0, y_start - radius), min(8, y_start + radius + 1)):
                if abs(x - x_start) == radius or abs(y - y_start) == radius:
                    sense.set_pixel(x, y, initial_color)

    time.sleep(1)
    sense.clear(initial_color)


def display_smile():
    sense.clear()
    for y, row in enumerate(smile_grid):
        for x, color in enumerate(row):
            sense.set_pixel(x, y, color)


client.loop_start()

try:
    publish_sensor_data()
except KeyboardInterrupt:
    client.loop_stop()
    client.disconnect()
    print("Disconnected from MQTT broker")


"""