import nmap
import sys

def detect_os(ip):
    try:
        nm = nmap.PortScanner()
        nm.scan(ip, arguments='-O')
        os_info = nm[ip]['osmatch']
        if os_info:
            for os in os_info:
                if 'windows' in os['name'].lower():
                    return '\e[9;32mWINDOWS\e[9;38m'
                elif 'linux' in os['name'].lower():
                    return '\e[9;32mLINUX\e[9;38m'
            return '\e[9;31mSISTEMA OPERATIVO NO IDENTIFICADO\e[9;38m'
        else:
            return '\e[9;31mSISTEMA OPERATIVO NO IDENTIFICADO\e[9;38m'
    except Exception as e:
        return str(e)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Uso: python script.py <dirección_IP>")
        sys.exit(1)

    ip_objetivo = sys.argv[1]
    resultado = detect_os(ip_objetivo)
    print(resultado)
