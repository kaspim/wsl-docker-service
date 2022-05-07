import sys
import subprocess

if __name__ == '__main__':
    command = ['wsl.exe', '-d', 'wsl-docker-service', 'docker-start;', 'docker']
    arguments = sys.argv

    if len(arguments) > 0:
        del arguments[0]

    try:
        proc = subprocess.Popen(command + arguments, shell=False, stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        stdout, stderr = proc.communicate()
        print(stdout.decode('utf-8'))
    except KeyboardInterrupt:
        proc.terminate()
