# Raspberry Pi Python <-> MQTTBroker <-> Flutter
## Beschreibung
Dieses Projekt besteht aus einer Kommunikationspipeline zwischen einem Raspberry Pi, 
einem MQTT-Broker und einer Flutter-Anwendung. 
Die Verbindung ermöglicht die bidirektionale Datenübertragung 
zwischen dem Raspberry Pi und der Flutter-App über den MQTT-Broker.

## Voraussetzungen
Raspberry Pi mit Python-Umgebung und SenseHat
Ein MQTT-Broker (z. B. Mosquitto)
Flutter-Entwicklungsumgebung

## Installation
### Raspberry Pi Python Setup:

Stellen Sie sicher, dass Ihr Raspberry Pi einsatzbereit ist und über eine Python-Umgebung und den SenseHat verfügt.
Installieren Sie das MQTT-Bibliothek für Python, apt install python3-paho-mqtt

### MQTT-Broker Setup:

Installieren und konfigurieren Sie einen MQTT-Broker wie Mosquitto auf einem Server oder einem geeigneten Gerät.
Konfigurieren Sie den Broker gemäß Ihren Anforderungen (z. B. Authentifizierung, Zugriffssteuerung).

### Flutter Setup:

Richten Sie Ihre Flutter-Entwicklungsumgebung ein, wenn Sie dies noch nicht getan haben.

## Konfiguration

### Raspberry Pi Python Konfiguration:

Konfigurieren Sie die Verbindungsparameter für den MQTT-Broker (z. B. Hostname, Port, Anmeldeinformationen).

### MQTT-Broker Konfiguration:

Konfigurieren Sie den MQTT-Broker entsprechend Ihren Sicherheits- und Netzwerkanforderungen.

### Flutter Konfiguration:

Konfigurieren Sie den MQTT-Client in Ihrer Flutter-App mit den gleichen Verbindungsparametern wie auf dem Raspberry Pi.

## Verwendung

### Starten Sie den MQTT-Broker:

Starten Sie Ihren MQTT-Broker (z. B. Mosquitto) auf dem entsprechenden Gerät oder Server.

### Starten Sie den Raspberry Pi Code:

Führen Sie Ihren Python-Code auf dem Raspberry Pi aus, der die MQTT-Kommunikation implementiert.

### Starten Sie die Flutter-App:

Starten Sie Ihre Flutter-App auf einem kompatiblen Gerät oder Emulator.

### Interagieren Sie mit der App:

Senden und empfangen Sie Daten zwischen der Flutter-App und dem Raspberry Pi über die definierten MQTT-Themen.
