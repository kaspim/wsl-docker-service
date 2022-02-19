import sys
import subprocess

if __name__ == '__main__':
    command = ['wsl.exe', '-d', 'wsl-docker-service', 'docker-start;', 'docker-compose']
    arguments = sys.argv

    if len(arguments) > 0:
        del arguments[0]

    cp = subprocess.run(command + arguments, capture_output=True)
    print(cp.stdout.decode('utf-8'))
