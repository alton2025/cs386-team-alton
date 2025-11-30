# cs386-team-alton
Demostration of a Linux Automation system where reads a csv file of groups and users, and then scripts automate paths to web directory using Apache.

## Files in Repository
- **sort.sh** – Main Bash automation script.
- **CS 386 Project DATA sheet.csv** – Input CSV file containing username–group relationships.
- **group_report-team alton.pdf** – Full group report describing project design, experiment, and results.
- **README.md** – Project documentation.

## Setup Instructions
1. Make the script executable:
   chmod +x sort.sh
2. Run the script with sudo:
   sudo ./sort.sh
3. Open Apache UserDir pages using:
   http://<server-ip>/~<username>
4. If the CSV files contain the names and groups-sarah,dev
john,design
bob,security
The script will:
- Create groups `dev`, `design`, `security`
- Create Linux users Sarah, John, Bob
- Create `/home/<user>/www`
- Generate SSH keys in `/home/<user>/.ssh/`
