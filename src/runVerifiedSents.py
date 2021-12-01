#take dir name as 1st argument which contains the verified sentences in usr.csv format and run all the user.csv files and stores the output in my_out file.
#To run:
# python3 runVerifiedSents.py verified_sent


import sys, subprocess, os
dire = sys.argv[1]
files = os.listdir(dire)

files.sort()
subprocess.run('rm my_temp.txt', shell=True)
fw = open('my_temp.txt', 'w')
for f in files :
    fw = open('my_temp.txt', 'a')
    sent = 'head -n 1 ' + dire + '/' + f 
    cmd = 'bash lc.sh ' + dire + '/' + f 
    inpSent = subprocess.run([sent], shell=True, stdout=fw, text=True)
    myout = subprocess.run([cmd], shell=True, capture_output=True, text=True)
    ot = subprocess.run(['grep', '-v', 'Creating'], stdout=fw, text=True, input=myout.stdout)
    fw.write('\n')
    fw.close()


"""
fw1 = open('my_temp1.txt', 'w')
cmnd = 'grep -v' + " Calling ACE parser for generating English " + 'my_temp.txt' + '>my-verified-out.txt'
myinpSent = subprocess.run([cmnd], shell=True, stdout=fw1, text=True)
"""

