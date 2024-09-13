<div align="center">

  <a href="">![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)</a>
  <a href="">![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)</a>
  <a href="">![Version](https://img.shields.io/github/v/release/AndySharp44s/AutoPwn?style=for-the-badge)</a>

</div>

# AutoPwn
This script is my first experience with bash. It is designed to generate an msf exploit for both Windows and Linux, scan the entire Wi-Fi network, detect the operating systems in use, infect them, and receive the connections, all in a fully automated manner. I learned bash the day before creating this script, so it's quite rudimentary, but it has worked for me in all cases. You are free to use it as you wish.

## Customize it
Remember to edit and customize everything according to your needs before executing it.

## Features

- You can choose which IPs not to attack to ensure there is no unwanted damage.
- Detect if root access is possible with the given credentials.
- In addition to an msf console, also open an SSH connection.
- Add persistence for both Windows and Linux (in Windows, it will start on reboot, and in Linux, every time a console is opened).
- Automatically updates [Duck DNS](https://www.duckdns.org) data when started.
- Change the working directory, i.e., where the exploits will be downloaded on the victim's machine.
- Automatically updates itself.
- It saves a log to the path AutoPWN/ROOTlog.txt.

## Dependencies

They should be installed automatically.

## Credits

Completely programmed by me. This is a self-learning project, so I researched a lot and learned a great deal during this project that took a couple of days.

## Usage
```
sudo apt update && sudo apt upgrade && sudo apt install mousepad && sudo apt install git && git clone https://github.com/AndySharp44s/AutoPwn && cd AutoPwn && chmod 777 autopwn.sh && mousepad autopwn.sh && echo execute the script with ./autopwn.sh
```
#### I would greatly appreciate any help to improve it. I'm not very focused on it since I stopped using it months ago, so I haven't improved it even though I now have more knowledge of bash. However, if any bugs or ideas come up, I will implement them without any issues :3
