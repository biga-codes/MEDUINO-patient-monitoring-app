
# MEDUINO – Remote Patient Health Monitoring System

INTRODUCTION: 
A Flutter-based application is developed to enable real-time remote health monitoring using IoT devices to
remote/rural areas with lack of accessibility to healthcare or proper ECG systems. The system focuses on
constant monitoring and early diagnosis of cardiovascular conditions by comparing real-time patient data with
baseline values. Itis specifically designed for remote and underserved regions to enhance healthcare
accessibility and efficiency.

SCOPE: 
The Remote Patient Health Monitoring Application is designed to provide continuous real-time health monitoring
using IoT-based wearable sensors. The system collects and analyzes vital health parameters such as heart
rate, oxygen saturation (SpO₂), ECG, and body temperature. The data is processed and stored securely using
Firebase, and the mobile application (developed using Flutter) allows patients, doctors, and caregivers to access
real-time health insights.

ABOUT MEDUINO: 
Our goal was to develop a accessible, cheap and
easy to use medical care interface that provides
patients from underserved areas access to quality
medical care with regard to abnormal
cardiovascular symptoms and rapid retrieval and
access of such health diagnostic information to the
nearest available medical facility. This helps make
healthcare more accessible and cheap in rural
areas.

---
## App Demo:


https://github.com/user-attachments/assets/b84e1051-0e43-4bcc-b0bb-71b78c6dd691



---
## Features

Remote Monitoring to detect health
abnormalities
Patient data access: Access Patient data
after authentication.
Patient Data Collection for Future access
Baseline Analysis: Comparison of real-time
data with predefined normal values for
cardiovascular health
User-Friendly Interface
'


---

## Scope

MEDUINO allows **continuous, real-time monitoring** of vital health parameters, including:

- Heart rate  
- Oxygen saturation (SpO₂)  
- ECG  
- Body temperature  

All data is **securely stored on Firebase**, allowing authorized users to access real-time insights and historical records.

---

## Hardware Components

- **ESP32 Microcontroller** – central unit for sensor data collection  
- **AD8232 ECG Sensor** – RA (Right Arm), LA (Left Arm), RL (Right Leg) electrodes  
- **MAX30102 Pulse Oximeter** – measures SpO₂ via I2C (SCL → GPIO22, SDA → GPIO21)  
- **DS18B20 Temperature Sensor** – single-wire connection (GPIO13) with 4.7kΩ pull-up resistor  
- **Power Supply:** 3.7V Li-ion battery powering the ESP32 and sensors  

**Connections:** Jumper wires distribute power and signals properly among components.

---

## ECG Signal Interpretation

- **P Wave:** Start of heartbeat (atrial depolarization)  
- **QRS Complex:** Ventricular contraction  
- **T Wave:** Ventricular recovery (repolarization)  
- **Intervals (PR, QT):** Timing between electrical signals  
- **1st-degree AV Block:** Slowed signal from atria to ventricles  
- **Bundle Branch Block:** Signal blocked or delayed in one ventricle causing asynchronous contraction  

---

## About MEDUINO

Our mission is to develop a **low-cost, accessible, and easy-to-use medical interface** that:

- Provides quality healthcare to underserved populations  
- Enables rapid retrieval and sharing of cardiovascular diagnostic data  
- Enhances accessibility and affordability of healthcare in rural areas  

---

## Tech Stack

- **Mobile App:** Flutter  
- **Backend / Database:** Firebase  
- **Microcontroller:** ESP32  
- **Sensors:** AD8232 (ECG), MAX30102 (Pulse Oximeter), DS18B20 (Temperature)  
- The ESP32 microcontroller acts as the central unit, collecting data from multiple sensors.
- The AD8232 ECG sensor is connected to the ESP32 with RA (Right Arm), LA (Left Arm), and RL (Right
Leg) electrodes for ECG signal acquisition.
- The ECG sensor's 3.3V and GND pins are connected to the ESP32 for power.
- The MAX30102 Pulse Oximeter is wired using the I2C protocol, where SCL (Clock) is connected to
ESP32’s GPIO22 and SDA (Data) to GPIO21.
- The pulse oximeter’s VCC (3.3V) and GND pins provide power.
- The DS18B20 Temperature Sensor uses a single-wire data connection (connected to GPIO13).
- A 4.7kΩ pull-up resistor is placed between the Data and 3.3V lines for stable communication.
- The ESP32 is powered by a 3.7V Li-ion battery, distributing power across the breadboard’s VCC and
GND rails.
- Various jumper wires ensure proper connections between components.
- The system enables real-time monitoring of heart rate, ECG signals, SpO₂ levels, and body
temperature

### ECG Monitoring System

The **ECG system** in MEDUINO uses the **AD8232 ECG sensor** connected to the **ESP32 microcontroller** to monitor the heart’s electrical activity in real time. Electrodes are placed on the **Right Arm (RA), Left Arm (LA), and Right Leg (RL)** to acquire accurate ECG signals. This setup enables remote monitoring of cardiovascular health, allowing early detection of abnormalities.

**ECG Signal Interpretation:**  
- **P Wave:** Start of a heartbeat (atrial depolarization).  
- **QRS Complex:** Ventricular contraction.  
- **T Wave:** Recovery after a heartbeat (ventricular repolarization).  
- **Intervals (PR, QT):** Show timing between electrical signals and heart conduction.  
- **1st-degree AV Block:** Slower signal transmission from atria to ventricles.  
- **Bundle Branch Block:** Signal delayed or blocked in one ventricle, causing asynchronous contraction.

**System Overview:**  
- **Microcontroller:** ESP32  
- **ECG Sensor:** AD8232  
- **Electrodes:** RA, LA, RL  
- **Purpose:** Real-time ECG monitoring with integration into the Flutter mobile app for remote access and early cardiovascular condition detection.


<img width="1092" height="616" alt="image" src="https://github.com/user-attachments/assets/a553675c-d0ce-4c06-b8f8-e7d3fce9c9a1" />
<img width="1092" height="616" alt="image" src="https://github.com/user-attachments/assets/0c66a815-92b2-4758-a01e-976d955c1622" />


