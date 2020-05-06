import sys
import subprocess

check = True
commandList = []
executeName = 'run'

if sys.argv[5] == 'multi':
    commandList.extend(["".join("cd ./" + sys.argv[1] + " ; build.sh 2> error.txt ; echo $?")])    
    commandList.extend(["".join("cd " + sys.argv[1] + " ; ulimit -Ss 7000 ; ulimit -Sn 4; timeout " + sys.argv[4] + "s ./"+ sys.argv[2])])
    
else:
    commandList.extend(["".join("test -f ./" + sys.argv[1] + "/run ; echo $?")])
    commandList.extend(["".join("gcc -o ./" + sys.argv[1] + "/run ./" + sys.argv[1] + "/" + sys.argv[2] + " 2> ./" + sys.argv[1] + "/error.txt ; echo $?")])
    commandList.extend(["".join(["mkdir ./", sys.argv[1], "/userAnswer"])])
    commandList.extend(["".join("cd " + sys.argv[1] + " ; ulimit -Ss 7000 ; ulimit -Sn 4; timeout " + sys.argv[4] + "s ./run")])

if sys.argv[5] == 'multi':
    for j in range(0,2):
        if j == 0:
            result = subprocess.check_output (commandList[j], universal_newlines=True, shell=True)
            if result == '1\n':
                sys.exit(-1)
        if j == 1:
            result = subprocess.check_output (commandList[j], universal_newlines=True, shell=True)
            if result == '\n':
                sys.exit(0)
            else:
                sys.exit(1)

else:
    for j in range(0, 4):
        if j == 0:
            result = subprocess.check_output (commandList[j], universal_newlines=True, shell=True)
            if result == '0\n':
                check = False
        elif j == 1 and check:
            result = subprocess.check_output (commandList[j], universal_newlines=True, shell=True)
            if result == '1\n':
                sys.exit(1)
        elif j == 2:
            subprocess.call (commandList[j], shell=True)
        elif j == 3:
            output = open(sys.argv[1] + "/userAnswer/userAnswer" + sys.argv[3] + ".txt", 'w')
            input = open("".join(sys.argv[1] + "/input/input" + sys.argv[3] + ".txt"), 'r')
            result = subprocess.Popen(commandList[j], stdin=input, stdout=output, shell = True)
            result.communicate()
            if result.returncode == 124:
                sys.exit(124)
            elif result.returncode == 139:
                sys.exit(139)
            f = open(sys.argv[1] + "/userAnswer/userAnswer" + sys.argv[3] + ".txt", "r")
            lines = f.readlines()
            f.close()
            while(1) :
                if(lines[-1] == '\n'):
                    lines.pop()
                else:
                    lines[-1] = lines[-1].rstrip()
                    break
            f = open(sys.argv[1] + "/userAnswer/userAnswer" + sys.argv[3] + ".txt", "w")
            f.write("".join(lines))
            f.close()
        
        
            

