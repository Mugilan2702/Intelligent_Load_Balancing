# ⚡ Smart Balance — Intelligent Load Balancing System

> A final year B.E./B.Tech project — an AI-assisted web application that intelligently classifies uploaded data and distributes tasks across servers based on content sensitivity and priority.

---

## 📌 Project Overview

**Smart Balance** is a full-stack Java EE web application that automates server load balancing using real-time data classification. When a user uploads a file, the system analyzes its content, determines whether it contains sensitive data or signs of a cyber attack, and routes the task to the most appropriate server (High Security, High Speed, or Normal) with the least current load.

---

## 🚀 Key Features

- 🔍 **Intelligent Data Classification** — Scans uploaded `.txt` files for sensitive keywords (e.g., `password`, `bank`, `aadhaar`) and attack indicators (e.g., `malware`, `ddos`, `sql injection`)
- 🧠 **Smart Server Selection** — Routes tasks automatically to the optimal server based on data type and priority using `SmartBalancer`
- 🛡️ **Security-First Routing** — Sensitive and attack-flagged data is always routed to `HIGH_SECURITY` servers
- 📊 **Admin Dashboard** — Real-time view of server load, task allocation, and system health
- 🚨 **Attack Monitor** — Dedicated panel to track detected threats
- 🌓 **Dark/Light Theme** — Toggle-able UI with a modern glassmorphism design
- 🔐 **User & Admin Authentication** — Separate login flows with session management

---

## 🏗️ Tech Stack

| Layer | Technology |
|---|---|
| Backend | Java EE (Jakarta Servlets) |
| Frontend | JSP, HTML5, CSS3, JavaScript |
| Database | MySQL |
| Build Tool | Maven |
| Server | GlassFish 7 / Payara |
| ORM/Persistence | JPA (persistence.xml) |
| Libraries | Apache POI, Commons IO, MySQL Connector |

---

## 🗂️ Project Structure

```
Intelligent_Load_Balancing/
├── src/
│   └── main/
│       ├── java/com/
│       │   ├── db/
│       │   │   └── DBConnection.java          # Database connection utility
│       │   ├── model/
│       │   │   ├── DataAnalyzer.java           # Keyword-based file classifier
│       │   │   └── SmartBalancer.java          # Server selection logic
│       │   └── servlet/
│       │       ├── TaskServlet.java            # Handles file upload & task routing
│       │       ├── LoginServlet.java           # User login
│       │       ├── AdminLoginServlet.java      # Admin login
│       │       └── RegisterServlet.java        # User registration
│       ├── resources/
│       │   └── META-INF/persistence.xml
│       └── webapp/
│           ├── home.jsp                        # Landing page
│           ├── login.jsp / register.jsp
│           ├── admin_login.jsp
│           ├── dashboard.jsp                   # User dashboard
│           ├── admin_dashboard.jsp             # Admin control panel
│           ├── server_status.jsp               # Live server load monitor
│           ├── attack_monitor.jsp              # Threat detection panel
│           ├── commondashboard.jsp
│           ├── sidebar.jsp
│           ├── theme.css / dashboard.css
│           ├── theme.js
│           └── WEB-INF/
│               ├── web.xml
│               ├── glassfish-web.xml
│               └── beans.xml
└── pom.xml
```

---

## ⚙️ Classification Logic

```
Uploaded File
     │
     ▼
DataAnalyzer.analyze()
     │
     ├── Contains sensitive keywords? → SENSITIVE
     ├── Contains attack keywords?    → ATTACK
     ├── Contains both?               → BOTH
     └── Neither?                     → NORMAL
     │
     ▼
SmartBalancer.selectServer()
     │
     ├── SENSITIVE / ATTACK / BOTH → HIGH_SECURITY server (least load)
     ├── Priority = HIGH           → HIGH_SPEED server (least load)
     └── NORMAL                   → NORMAL server (least load)
```

---

## 🗄️ Database Setup

```sql
-- Create database
CREATE DATABASE load_balancing_db;
USE load_balancing_db;

-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255)
);

-- Servers table
CREATE TABLE servers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    category ENUM('HIGH_SECURITY', 'HIGH_SPEED', 'NORMAL'),
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    current_load INT DEFAULT 0
);

-- Tasks table
CREATE TABLE tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    task_name VARCHAR(200),
    data_type VARCHAR(50),
    priority VARCHAR(20),
    assigned_server VARCHAR(100),
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seed servers
INSERT INTO servers (name, category) VALUES
('SecureServer-1', 'HIGH_SECURITY'),
('SecureServer-2', 'HIGH_SECURITY'),
('SpeedServer-1',  'HIGH_SPEED'),
('SpeedServer-2',  'HIGH_SPEED'),
('NormalServer-1', 'NORMAL'),
('NormalServer-2', 'NORMAL');
```

---

## 🔧 Installation & Setup

### Prerequisites
- Java 11+
- Maven 3.6+
- MySQL 8.x
- GlassFish 7 or Payara Server

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/Intelligent_Load_Balancing.git
cd Intelligent_Load_Balancing

# 2. Set up the database
# Run the SQL script above in MySQL Workbench or CLI

# 3. Configure DB credentials
# Edit: src/main/java/com/db/DBConnection.java
#   → Update URL, username, password

# 4. Build the project
mvn clean package

# 5. Deploy the WAR file
# Copy target/Intelligent_Load_Balancing-1.0-SNAPSHOT.war
# to GlassFish's autodeploy/ folder

# 6. Access the app
# http://localhost:8080/Intelligent_Load_Balancing-1.0-SNAPSHOT/home.jsp
```

---

## 📸 Screenshots

> *(Add screenshots of Home page, Dashboard, Admin panel, and Attack Monitor here)*

---

## 👨‍💻 Team

> *(Add your team member names and roll numbers here)*

---

## 📄 License

This project was built for academic purposes as part of the final year curriculum. All rights reserved by the authors.
