#take dir name as 1st argument which contains the verified sentences in usr.csv format and run all the user.csv files and stores the output in my_out file.
#To run:
# python runVerifiedSents.py verified_sent

import sys, commands, os
dire = sys.argv[1]
files = os.listdir(dire)

files.sort()
commands.getoutput('rm my_temp.txt')
for f in files :
    fw = open('my_temp.txt', 'a')
    fw.write("\nINPUT_SENTENCE: " + f +'\n')
    cmd = 'bash lc.sh ' + dire + '/' + f + ' jnk'
    sent = 'head -n 1 ' + dire + '/' + f 
    inpSent = commands.getoutput(sent)
    fw.write(inpSent + '\t')
    myout = commands.getoutput(cmd)
    fw.write(myout)
    fw.close()


fr = open('my_temp.txt', 'r')
flst = fr.readlines()
flag = 0
for l in flst:
    if "INPUT_SENTENCE: " in l:
        print
        flag = 1

    if '         CLIPS (Cypher Beta' in l or l.startswith('NOTE: '):
        flag = 0

    if flag == 1 and "The fact was already deleted" not in l and 'Creating  /home/' not in l and 'INPUT_SENTENCE:' not in l:
        print  l,

