# 🌦️ Smart Laundry Assistant – AWS + Terraform

A cloud-native project built with **AWS** and **Terraform** to help users (like my mom 😊) know if it’s safe to hang clothes outside.  
The app integrates **weather data, notifications, and geofencing** to prevent clothes from getting wet when it rains.

---

## Features
- **Weather & Precipitation Alerts**  
  Get real-time weather updates to decide if it’s safe to hang clothes outside.

- **Reminders & Notifications**  
  - Set reminders when clothes are outside.  
  - Receive alerts if it starts raining.  
  - Notify when leaving home if clothes are still hanging.  

- **Geofencing (Amazon Location Service)**  
  Detects when you leave home and sends a reminder about your laundry.  

- **AWS-Backed Notifications**  
  Uses **SNS** for push/email/SMS alerts.  

- **Secure & Automated Infra**  
  - **Terraform** to provision infra.  
  - **AWS Secrets Manager** for API keys.  
  - **CloudWatch** for monitoring.  

---

## Architecture
```mermaid
flowchart TD
    subgraph App["Mobile/Web App"]
        A1[React Frontend]
        A2[API Requests]
    end

    subgraph Backend["Backend"]
        B1[API Gateway]
        B2[Lambda - Weather API Fetch]
        B3[RDS - Reminders DB]
        B4[SNS Notifications]
        B5[Amazon Location Service]
    end

    subgraph Infra["AWS Infra (Terraform)"]
        C1[VPC + Subnets]
        C2[EC2 (Backend)]
        C3[ALB + Auto Scaling]
        C4[S3 Static Hosting]
    end

    App -->|calls| Backend
    Backend --> B2
    Backend --> B3
    Backend --> B4
    Backend --> B5
    Infra --> Backend
