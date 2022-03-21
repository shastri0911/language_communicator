# Written by Sukhada on 17/03/2019, Email: sukhada8@gmail.com, sukhada.hss@iitbhu.ac.in
# Objective: Convert the information given in Hindi  *_user.csv into CLIPS facts.
#   Input:  Hindi *_user.csv file
#   Output: Hindi *user.csv info converted into CLIPS facts
# To run: python3 usr_csv_to_clips_modified.py <_user.csv file> <output file>
#    Ex. python3 usr_csv_to_clips_modified.py rAma-ne-basa-adde-para-eka-acCe-hI-ladake-ke-sAWa-bAwa-kI_user.csv clips-facts.dat
######################################################################
import sys, re

fr = open(sys.argv[1], 'r')
hinUsrCsv = list(fr)
ans=open(sys.argv[2],'w+')

group = hinUsrCsv[1].strip().split(',')          # row 2: grouping/chunking
conceptDict = hinUsrCsv[2].strip().split(',')    # row 3: concept dict info
wid = hinUsrCsv[3].strip().split(',')            # row 4: group/chunk ids
pos = hinUsrCsv[4].strip().split(',')            # row 5: def/pos? info
gnp = hinUsrCsv[5].strip().split(',')            # row 6: GNP info
intraChunkRels = hinUsrCsv[6].strip().split(',') # row 7: intra chunk relations
interChunkRels = hinUsrCsv[7].strip().split(',') # row 8: inter chunk relations
discorseRel = hinUsrCsv[8].strip().split(',')    # row 9: discourse relations
speakerView = hinUsrCsv[9].strip().split(',')    # row 10: Speaker's view

def get_emphatic_word(s):
    ''' Given a string of a chunk/group, this function will return 
        the emphatic word present in that chunk.
        Assumption: a chunk would have only one emphatic word. Ex.
        >>>get_emphatic_word('eka@acCA*hI~ladakA_ke_sAWa')
        hI
        >>>get_emphatic_word('eka@acCA~ladakA_ke_sAWa*hI')
        hI
        >>>get_emphatic_word('eka@acCA~ladakA_ke_sAWa')
        None
    '''
    if '*' in s:
        emphMore = s.split('*')
        emph = re.split(r',', emphMore[1])
        return(emph[0])

# Creating viSeRya_ids and their vibhaktis
headIdPP={}
for i in range(len(group)-1):
    id = (i+1)*10000
    vib = ''
    if '_' in group[i] and '-' not in group[i]:
        PP = group[i].split('_')[1:]
        for w in PP:
            if '*' in w:  # eka@acCA~basa+addA_para*wo, eka@acCA*hI~ladakA_ke*hI_sAWa
                vib = vib + '_' + w.split('*')[0]
            else: # rAma_ne, kala_0, eka@acCA*hI~ladakA_ke_sAWa
                vib = vib + '_' + w
        headIdPP[id] = vib[1:]

# Writing viSeRya_id-viSeRya_vibhaktis
#for key in headIdPP.keys():
#    ans.write('(viSeRya-PSP\t'+ str(key) +'\t'+ headIdPP[key]+')\n')

#Creating viSeRya_ids and their TAMs
kriTAM = {}
for i in range(len(conceptDict)):
    id = (i+1)*10000
    if '-' in conceptDict[i]:
        TAM = conceptDict[i].split('-')[1]
        kriTAM[id] = TAM

# Writing viSeRya_ids and their TAM value
for key in kriTAM.keys():
    ans.write('(kriyA-TAM\t' + str(key) + '\t' + kriTAM[key] + ')\n')

# Creating id-concept_label dictionary
idConcept = {}
for i in range(len(conceptDict)):
    con = conceptDict[i]
    mycons = re.split(' ', con)
    mycons.reverse()
    c = 0
    for j in range(len(mycons)):
        if get_emphatic_word(con) != None and mycons[j] == get_emphatic_word(con): #Giving ids to emphatic markers as in eka@acCA~basa+addA_para*hI, eka@acCA*hI~ladakA_ke_sAWa, bAwa+kara*hI-0_rahA_WA
            strid = str(i+1) + '.' + str(c)
            myid = int(float(strid)*10000+100)
            idConcept[str(myid)] = mycons[j]
        elif '-' in mycons[j]:
            strid = str(i+1) + '.' + str(c)
            myid = int(float(strid)*10000)
            idConcept[str(myid)] = mycons[j].split('-')[0]	
            c = c+1
        else:
            strid = str(i+1) + '.' + str(c)
            myid = int(float(strid)*10000)
            idConcept[str(myid)] = mycons[j]
            c = c+1

# Writing id-concept_label 
for k in idConcept.keys():
    if '{' in idConcept[k]:
        #Computing constructions and concept labels from them
        constructions = idConcept[k].split('<')
        constructionTrigger =  idConcept[k].split('[')[1].split(']')[0]
        ans.write('(id-construction_trigger\t'+ k +'\t'+constructionTrigger+')\n')
        for i in constructions:
            if '>' in i:
                concept = i.split('>')[0]
                ans.write('(id-concept_label\t'+ k +'\t'+concept+')\n')
                ans.write('(id-construction\t'+ k +'\t'+idConcept[k]+')\n')
    else:
        ans.write('(id-concept_label\t'+ k +'\t'+idConcept[k]+')\n')

# Writing gender,number,person:
for i in range(len(gnp)):
    if gnp[i] !='':
        ans.write('(id-gen-num-pers\t' + str((i+1)*10000) + '\t' + gnp[i][1:-1] + ')\n')

# Writing POS values
for i in range(len(wid)):
    if pos[i] != '':

#        for j in 
        ans.write('(id-'+pos[i]+'\t' + str((i+1)*10000) + '\t' + 'yes)\n')

# Writing intra-chunk relations
for i in range(len(intraChunkRels)):
    if intraChunkRels[i] != '':
        idsRels = re.split(';', intraChunkRels[i])
        idsRels.reverse()
        for j in range(len(idsRels)):
            idrel = idsRels[j].split(':')      
            visheshyaId = str(int(float(idrel[0]))*10000)
            viNaId = str(int(float(idrel[0]))) + '.' + str(j+1)
            visheshanaId = str(int(float(viNaId)*10000))
            myrel = 'rel_name-ids ' + idrel[1].replace('-', '_')
            ans.write('('+ myrel + '\t' + visheshyaId + '\t' + visheshanaId + ')\n')

# Writing inter chunk relations
for i in range(len(interChunkRels)):
    if interChunkRels[i] != '':
        idsRels = re.split('[@~\*]+', interChunkRels[i])
        if 'samAnAXi' in idsRels: # Assmption: there would be only two occurences of samAnAXi in a sentence. This part of program would generate two samAnAXi facts, one of them would be duplicate which will be deleted automatically by CLIPS while loading the facts' file.
             sam1 = [i for i, n in enumerate(interChunkRels) if n == 'samAnAXi'][0]
             sam2 = [i for i, n in enumerate(interChunkRels) if n == 'samAnAXi'][1]
             ans.write('(rel_name-ids\tsamAnAXi\t' + str(((sam1+1)*10000)) + '  ' + str(((sam2+1)*10000)) + ')\n' )
        elif 'AXAra' in idsRels: #
             AXAra = [i for i, n in enumerate(interChunkRels) if n == 'AXAra'][0]
             AXeya = [i for i, n in enumerate(interChunkRels) if n == 'AXeya'][0]
             ans.write('(rel_name-ids\tAXAra-AXeya\t' + str(((AXAra+1)*10000)) + '  ' + str(((AXeya+1)*10000)) + ')\n' )
        elif 'AXeya' in idsRels:
             pass
        elif 'anuBAvya' in idsRels: #
             anuBava = [i for i, n in enumerate(interChunkRels) if n == 'anuBava'][0]
             anuBAvaka = [i for i, n in enumerate(interChunkRels) if n == 'anuBAvaka'][0]
             anuBAvya = [i for i, n in enumerate(interChunkRels) if n == 'anuBAvya'][0]
             ans.write('(rel_name-ids\tanuBava-anuBAvaka-anuBAvya\t' + str(((anuBava+1)*10000)) + '  ' + str(((anuBAvaka+1)*10000)) + ' ' + str(((anuBAvya+1)*10000)) + ')\n' )
        elif 'anuBava' in idsRels and 'anuBAvya' not in interChunkRels:
             anuBava = [i for i, n in enumerate(interChunkRels) if n == 'anuBava'][0]
             anuBAvaka = [i for i, n in enumerate(interChunkRels) if n == 'anuBAvaka'][0]
             ans.write('(rel_name-ids\tanuBava-anuBAvaka\t' + str(((anuBava+1)*10000)) + '  ' + str(((anuBAvaka+1)*10000)) + ')\n' )
        elif 'anuBAvaka' in idsRels:
            pass
 
        elif 'possessed' in idsRels: #
             possessed = [i for i, n in enumerate(interChunkRels) if n == 'possessed'][0]
             possessor = [i for i, n in enumerate(interChunkRels) if n == 'possessor'][0]
             ans.write('(rel_name-ids\tpossessed-possessor\t' + str(((possessed+1)*10000)) + '  ' + str(((possessor+1)*10000)) + ')\n' )
        elif 'possessor' in idsRels:
            pass
        else:     
            for j in range(len(idsRels)):
                idrel = idsRels[j].split(':')
                try:
                    kriId = str(int(float(idrel[0]))*10000)
                    karakaId = str((i+1)*10000)
                    myrel = 'rel_name-ids ' + idrel[1].replace('-', '_')
                    ans.write('('+ myrel + '\t' + kriId + '\t' + karakaId + ')\n')
                except:
                    print('Sukhada Warning: Value Error')

# Writing emphetic information
for i in range(len(discorseRel)):
    if discorseRel[i] != '':
        idrel = discorseRel[i].split(':')
        headId = str(int(float(idrel[0]))*10000)
        depId = str((i+1)*10000)
        ans.write('(rel_name-ids ' +idrel[1]+ ' ' + headId + '\t' + depId + ')\n')

for k in idConcept.keys():
    if k.endswith('100'):
        ans.write('(viSeRya-emp\t'+ str(int(k)-100) +'\t'+ k +')\n')

# Writing Speaker's View values
for i in range(len(wid)):
    if speakerView[i] != '':
        ans.write('(id-'+speakerView[i]+'\t' + str((i+1)*10000) + '\t' + 'yes)\n')


# writing sentence type
ans.write('(sentence_type\t' + hinUsrCsv[10].strip() + ')\n')
