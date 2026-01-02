# SystemHealthAnalyzer
A professional PowerShell module for comprehensive system health monitoring and reporting. Generate beautiful HTML and CSV reports with system metrics, disk usage, service health, and process analysis.


**Features**

1. Comprehensive System Analysis: OS info, memory usage, disk space, services, processes
2. Beautiful HTML Reports: Professional, responsive design with color-coded alerts
   a. Multiple Formats: HTML for visualization, CSV for data analysis
   b. Real-time Monitoring**: Live system metrics collection
   c. Alert System: Color-coded warnings for critical issues
   d. OS-platform: Works on Windows
3. Create output in HTML Report Preview and CSV file

**Report Contents**
1. System Information
- Computer name and OS version
- Memory usage (total/free/percentage)
- System uptime and last boot time
- Processor information

2. Disk Health Analysis
- Drive letters and labels
- Total, used, and free space
- Percentage free with color coding:
  - 🟢 Green: > 20% free
  - 🟡 Yellow: 10-20% free (Warning)
  - 🔴 Red: < 10% free (Critical)

3. Service Health
- Automatic services not running
- Service display names and status
- Startup type verification

4. Process Analysis
- Top 10 processes by CPU usage
- Memory consumption per process
- Process responsiveness status

**Configuration**

Default Settings
- Output Path: “C:\System-Health-Report”
- Report Format: HTML + CSV
- Service Check: Automatic services only
- Process Limit: Top 10 by CPU


**Quick Start**
**Installion**: 
Method 1: Clone Repository
1. Run Powershell 
2. Clone the Repository by copy and pasting the the command below in the PowerShell:
      git clone https://github.com/ZyanAzad69/SystemHealthAnalyzer.git
3. Go to the cloned directory with the below:
      cd .\SystemHealthAnalyzer\
4. Import the module 
      import-module .\SystemHealthReporter
5. To get your System report run the command:
   Get-SystemHealthReport

Method 2: Manual Installation
1. Download the repository form this github link:
  https://github.com/ZyanAzad69/SystemHealthAnalyzer.git
2. Extract the zip file on the desktop(for user ease)
3. Now run PowerShell
4. Run the command below to navigate to the module directory:
   cd $env:USERPROFILE\Desktop\SystemHealthAnalyzer-main\
5. Import the module 
      import-module .\SystemHealthReporter
   **If you get any error while Importing the module run the following command and again import the module one more time:
   Set-ExcutionPolicy Unrestrited -Scope CurrentUser -Force
7. To get your System report run the command:
   Get-SystemHealthReport

