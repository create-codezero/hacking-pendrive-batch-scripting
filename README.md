# 🚀 Automated System Audit & Data Management Utility

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PowerShell](https://img.shields.io/badge/PowerShell-%23217346.svg?style=flat&logo=powershell&logoColor=white)](https://github.com/PowerShell/PowerShell)
[![Batch](https://img.shields.io/badge/Shell-Batch-blue.svg)](https://en.wikipedia.org/wiki/Batch_file)

A specialized scripting suite designed to demonstrate automated data backup and system diagnostic gathering. This project explores how Batch and PowerShell scripts interface with removable storage to automate the collection of system metadata and specific file types for recovery or forensic auditing.

---

## 🛠 Project Components

The suite consists of a central launcher and modular PowerShell sub-scripts:

* **`runMe.bat`**: The master execution script that manages environment checks and triggers sub-modules silently.
* [cite_start]**`downloadsPicturesDocuments.ps1`**: Automates the backup of user media and documents (JPG, PDF, DOCX, etc.) to connected removable drives and generates hardware/network diagnostic reports.
* **`cookieWA.ps1`**: A module focused on application data, demonstrating how to programmatically interface with browser directories (Chrome/Edge) and desktop application states like WhatsApp and Instagram.

---

## ✨ Key Features

* [cite_start]**Automated Drive Detection**: Dynamically identifies removable disks (DriveType 2) as backup destinations.
* [cite_start]**System Diagnostics**: Generates a `netinfo_[timestamp].txt` report including:
    * [cite_start]OS Version, CPU Model, RAM capacity, and Screen Resolution.
    * [cite_start]Network Configuration (IP, MAC Address, Default Gateway).
    * [cite_start]Active Wi-Fi SSID.
* **Silent Execution**: Utilizes `-WindowStyle Hidden` and `-ExecutionPolicy Bypass` to ensure background processing.
* [cite_start]**Smart Filtering**: Categorizes data into specific sub-folders (e.g., `_img` vs `_docs`) based on file extensions.
* [cite_start]**Profile Safeguards**: Includes logic to prevent execution on specific administrative profiles (e.g., "amit").

---

## 📁 Repository Structure

```text
├── runMe.bat                # Main Entry Point
└── subParts/                # PowerShell Modules
    ├── cookieWA.ps1         # Browser & App Data Auditor
    └── downloadsPicturesDocuments.ps1  # Media & Info Gatherer
