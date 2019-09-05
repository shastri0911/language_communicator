;generates output file "id-concept_label-mrs_concept.dat" which contains id,hindi concept label, and MRS concept for the hindi user csv by matching concepts from hindi clips facts from the file hin-clips-facts.dat.

(defglobal ?*mrsCon* = mrs-file)
(defglobal ?*mrs-dbug* = mrs-dbug)

;(matches concept from hin-clips-facts.dat)
(defrule mrs-rels
;(declare (salience 100))
(id-concept_label       ?id   ?conLabel)
(concept_label-concept_in_Eng-MRS_concept ?conLabel ?enCon ?mrsConcept)
=>
(assert (id-hin_concept-MRS_concept ?id ?conLabel ?mrsConcept))
)
;Deletes the MRS concept fact of stative verb "be" if Predicative adjective exists.
;e.g #rAma acCA hE. (Rama is good).
(defrule del-state-adj
(id-concept_label       ?id   state)
(id-guNavAcI    ?id1   yes)
?f<-(id-hin_concept-MRS_concept ?id ?conLabel ?mrsConcept)
=>
(retract ?f)
;(printout ?*mrsCon* "(id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values del-state-adj id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf))

(defrule print-mrs-rels
;(declare (salience 100))
?f<-(id-hin_concept-MRS_concept ?id ?conLabel ?mrsConcept)
=>
(retract ?f)
(printout ?*mrsCon* "(id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
(printout ?*mrs-dbug* "(rule-rel-values print-mrs-rel id-hin_concept-MRS_concept "?id " " ?conLabel " " ?mrsConcept ")"crlf)
)



