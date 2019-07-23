# IP-Changer
Administration tool for remote IP address change within domain network.

Program is developed for completing a huge task(still in progress) within my company where my department has to change hundreds of production PC-s IP configurations (IP, MASK, GATEWAY, DNS) along with other networking tasks.

HOW TO USE THE SOFTWARE?
1. Copy all files to your PC
2. Set Username and Password(must be admin on remote PC)
3. Set domain name: File->Domain
4. Type remote PC name or IP address
5. Get data for all remote PC interfaces
6. Select interface and set new IP address
7. Upload new IP
8. Upload DNS1 and DNS2 if neccessary (set manually in settings.ini file), required if setup static IP from DHCP address

Requirements:
WindowsXP and up (tested on Windows7 and Windows 10)

Program uses PSTools suite for remote commands execution by Mark Russinovich https://docs.microsoft.com/en-us/sysinternals/downloads/pstools
