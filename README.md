
# BrEdgeDeviceOpcUaLogger

This project enables data acquisition from a B&R PLC via OPC UA on an edge device (X20EDS410) with subsequent visualization in Grafana. The solution is based on a Docker environment running **InfluxDB**, **Telegraf**, and **Grafana**.

---

## 🧱 Project Structure

The project consists of two main components:

1. **Docker application on the edge device**
   - Data logging via Telegraf (OPC UA)
   - Storage in InfluxDB
   - Visualization with Grafana

2. **Demo PLC Project**
   - Platform: B&R Automation Studio V6.1
   - Simulated process data provided via OPC UA

---

## 🐳 Docker Setup

### 🔧 Requirements

- Docker & Docker Compose
- B&R Edge Device X20EDS410 (or compatible hardware)
- B&R PLC to simulate OPC-UA Data (or other OPC UA server)

### 📁 .env.sim (Example Variables)

The `.env.sim` file contains configuration values for Telegraf, InfluxDB, and Grafana.

```env
DOCKER_INFLUXDB_INIT_MODE=setup
DOCKER_INFLUXDB_INIT_USERNAME=admin
DOCKER_INFLUXDB_INIT_PASSWORD=test1234
DOCKER_INFLUXDB_INIT_ORG=CG-Automation
DOCKER_INFLUXDB_INIT_BUCKET=PlcData
DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=mysecrettoken
DOCKER_INFLUXDB_INIT_RETENTION=0s

# Telegraf
TELEGRAF_ENDPOINT_URI=opc.tcp://host.docker.internal:4840
# TELEGRAF_ENDPOINT_URI=opc.tcp://192.168.1.50:4840
TELEGRAF_OPCUA_USERNAME=telegraf
TELEGRAF_OPCUA_PASSWORD=1234

# Grafana
GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=test1234
GF_USERS_ALLOW_SIGN_UP=false
GF_USERS_ALLOW_ORG_CREATE=false
```

> 🔒 **Note:** Adjust this file before launching the stack and place it in the directory where your docker-compose.yaml is located.

---

### ▶️ Starting the Stack

```bash
docker compose up -d
```

After startup, the following services are available:

| Service     | Port   | Description                     |
|-------------|--------|---------------------------------|
| InfluxDB    | 8086   | Time-series database            |
| Telegraf    | 8125   | Data collector (OPC UA client)  |
| Grafana     | 3000   | Data visualization UI           |

---

## 🤖 Demo PLC Project

- Built with **B&R Automation Studio V6.1**
- Exposes simulated process data via **OPC UA Server**

---

## 📊 Dashboards

- Prebuilt dashboards are located under `./grafana/dashboards`
- Automatic provisioning through `./grafana/provisioning`

---

## 📂 Directory Structure

```bash
├── docker-compose.yaml
├── .env.sim
├── grafana/
│   ├── dashboards/
│   └── provisioning/
├── telegraf/
│   ├── telegraf.d/
│   │   ├── opcua.conf      # OPC UA specific config
│   │   └── general.conf    # General input/output settings
│   └── logs/
```

---

## ⚙️ Example OPC UA Configuration
The file `telegraf/telegraf.d/opcua.conf` contains the configuration for Telegraf’s OPC UA input plugin. Below is an example snippet to configure a single node
``` 
[[inputs.opcua.nodes]]
   name = "State"
   namespace = "5"
   identifier_type = "s"
   identifier = "::ProcCtrl:diState"
   default_tags = { tag1 = "ProcCtrl", tag2 = "State" }
```
| Field           | Description                                                                |
|----------------|----------------------------------------------------------------------------|
| `name`          | Label for the node (used as the field name in InfluxDB)  |
| `namespace`     | OPC UA namespace index (check OPC-UA Client) |
| `identifier_type` | Type of identifier (`s` = string, `i` = numeric, etc.)|
| `identifier`    | The actual NodeId identifier (check OPC-UA Client) |
| `default_tags`  | Optional tags for easier filtering and grouping in InfluxDB |


## 📜 License

- This project is licensed under the MIT License. Please verify the licensing conditions of any third-party tools used (e.g. Docker, Grafana, B&R software).
---


