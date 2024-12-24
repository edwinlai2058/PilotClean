# **PilotClean: The Ultimate FPGA Dual-Mode Cleaning Robot**
[![PilotClean](https://raw.githubusercontent.com/vaclisinc/PilotClean/81a0a1877479b63e9bfe3edfffe1963ba99842c9/bg.jpg)](https://github.com/vaclisinc/PilotClean/blob/main/slide.pdf)
*Click on the picture to view our full presentation PDF*

## **Overview**
PilotClean is a dual-mode cleaning robot designed and developed by Team 23 in Hardware Design and Lab, a class in NTHU. It leverages FPGA technology to combine the **flexibility of manual control** with the **efficiency of automatic cleaning**, addressing limitations in existing robot vacuums. The system integrates hardware and software innovations, including remote control functionality, infrared obstacle detection, and customizable speed settings.

---

## **Features**
1. **Dual Cleaning Modes**:
   - **Remote Control Mode**: Operate the robot directly using a mobile app for precise spot cleaning.
   - **Random Mode**: Automatically clean using a Linear Feedback Shift Register (LFSR) for generating diverse random paths.

2. **Infrared Sensors**:
   - Prevent collisions and getting stuck during cleaning.

3. **Mobile App Control**:
   - Adjust robot settings, including:
     - Mode selection
     - Direction control
     - Power on/off
     - Suction control

4. **Speed Settings**:
   - Three adjustable speed levels for different cleaning needs.

5. **Dust Collection System**:
   - Powered by an **8x8 12V square fan**, optimized for effective suction.
   - Retains a protective masking layer to prevent dust intrusion while enhancing airflow.

6. **Trash Disposal Method**:
   - Manual return-to-home functionality allows the robot to deposit trash at a base station for easier maintenance.

---

## **System Specifications**
- **Power Supply**: Three 18650 lithium-ion batteries connected in series, delivering a maximum voltage of 12V.
- **Processing Unit**: FPGA board with a complex Dupont wiring setup.
- **Communication**: Bluetooth modules (HC-05/HC-06) using the UART protocol.
- **Motor Control**: Speed and direction adjustments using infrared sensors.

---

## **Challenges Overcome**
1. **Dust Management**:
   - Removed the filter paper layer to improve suction while keeping an outer masking cover to block large debris.
2. **Signal Stability**:
   - Implemented OnePulse technology to stabilize UART communication and prevent repeated signals.
3. **Random Walk Generation**:
   - Redesigned the LFSR logic to include all bits and improved the initial seed for better randomness.

---

## **Experimental Results**
- **Suction Performance**: Removing the filter paper layer increased airflow significantly.
- **Path Randomness**: Enhanced LFSR logic resulted in more diverse cleaning paths.
- **Power Limitation**: Tests revealed that 12V power is slightly underpowered, indicating potential for future optimization.

---

## **Future Improvements**
- Upgrade power system for higher performance.
- Implement fully autonomous return-to-home functionality.
- Enhance app features for greater user convenience.
- Add more advanced sensors for improved obstacle detection and navigation.

---

## **Usage**
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/PilotClean.git
   ```
2. Navigate to the project directory:
   ```bash
   cd PilotClean
   ```
3. Feel free to use the source code:
   - The source code files are located in the `source_code` folder. 
   - The constraints file and pin design picture are located in the `xdc` folder.

---

## **Team Members**
- **Song-Ze, Yu**
- **Yun-Zhong, Lai**

---

## **License**
This project is licensed under the MIT License. See the `LICENSE` file for details.
