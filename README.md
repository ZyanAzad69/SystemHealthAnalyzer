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
2. Extract the zip file to the desktop
3. Run PowerShell
4. Run the command below to navigate to the Module directory
   cd $env:USERPROFILE\Desktop\\SystemHealthAnalyzer-main\SystemHealthAnalyzer-main\

Method 2: Manual Installation
1. Download the repository from the link below:
  https://github.com/ZyanAzad69/SystemHealthAnalyzer.git
2. Extract the zip file on the desktop(for user ease)
3. Now run PowerShell
4. Run the command below to navigate to the module directory:
   cd $env:USERPROFILE\Desktop\SystemHealthAnalyzer-main\SystemHealthAnalyzer-main\
