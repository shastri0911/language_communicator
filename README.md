#Language Communicator 
#New version of communicator tool 

#Readme to generate english sentence using a CHL input 
-------------------------------------------------------

Pre-requisites:
--------------
1. pydelphin needs to be installed in $HOME/
2. Ace parser 0.24 version in $HOME/
	(Note:  Link: http://sweaglesw.org/linguistics/ace/download/
	        download ace-0.9.24-x86-64.tar.gz and erg-1214-x86-64-0.9.24.dat.bz2 from the above link. 
  		Keep erg-1214-x86-64-0.9.24.dat.bz2 in ACE directory.
	)
3. Clips
    1. Download zip file : (https://sourceforge.net/projects/clipsrules/files/CLIPS/6.40_Beta_1/clips_core_source_640.zip/download)
    2. copy zip file in language_communicator folder
    3. unzip clips_core_source_640.zip

 
#To Set path::
-------------
Set pydelphin and language_communicator path in ~/.bashrc:
------------------------------------------------------------

1. Copy below lines in end of ~/.bashrc

	export PYDELPHIN=$HOME/pydelphin
	export lang_comm=$HOME/language_communicator
	export PATH=$lang_comm/bin:$PATH

2. Save and quit the above file 
3. In terminal run below command.
	source ~/.bashrc

Compile:
-----------

a. cd $lang_comm/clips_core_source_640/core
b. make -f makefile
c. mv clips $lang_comm/bin/


4. RUN:
--------
How to Run:
1) generate a user csv for a sentence manually.
	{NOTE:THE FILES H_concept-to-mrs-rels.dat AND mrs-rel-features.dat SHOULD HAVE THE NECESSARY INFORMATION) 

2) run the shell file lc.sh in the terminal. Command for the same is:

	bash lc.sh <path of the user_csv> 
		(Note: user csv filenames are stored as numbers)
	Example:
	bash lc.sh $HOME/language_communicator/verified_sent/1
	
	NOTE:
	**	Output is stored in the file name dir present inside tmp_dir
		(Ex: Output is stored in $HOME/language_communicator/tmp_dir/1/)
