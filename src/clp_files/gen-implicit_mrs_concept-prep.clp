;generate output file "mrs_info-prep.dat" and gives id and MRS concept for prepositions

(defglobal ?*mrsdef* = mrs-def-fp)
(defglobal ?*defdbug* = mrs-def-dbug)

;Rule for prepositions : if (kriyA-k*/r* ?id1 ?id2) and is present in "karaka_relation_preposition_default_mapping.dat", generate (id-MRS_Rel ?id ?respective preposition_p)
;Ex-Apa kahAz rahawe hEM?  Where do you live? ,baccA somavAra ko Pala KAwA hE babies eat fruits on monday,baccA baccA  janavarI meM Pala KAwA hE Babies eat fruits in january
(defrule mrsPrep
(rel_name-ids ?rel ?kri ?k-id)
(Karaka_Relation-Preposition    ?karaka  ?prep)
(not (id-concept_label	?k-id	?hiConcept&kahAz_1|kaba_1|somavAra|janavarI|ParavarI|mArca|aprELa|maI|jUna|juLAI|agaswa|siwaMbara|aktUbara|navaMbara|xisaMbara|maMgalavAra|buXavAra|guruvAra|SukravAra|SanivAra|ravivAra|Aja_1|kala_1|kala_2)) 
(test (eq (sub-string (+ (str-index "-" ?rel)1) (str-length ?rel) ?rel) (implode$ (create$ ?karaka))))
=>
(bind ?myprep (str-cat "_" ?prep "_p"))
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?k-id 1) " " ?myprep")"crlf)
(printout ?*defdbug* "(rule-rel-values mrsPrep id-MRS_concept " (+ ?k-id 1) " " ?myprep")"crlf)
)

;
(defrule on_p_temp
(dofw  ?vaar     ?day)
(id-concept_label ?id	?vaar) 
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?id 1) " _on_p_temp)"crlf)
(printout ?*defdbug* "(rule-rel-values on_p_temp  id-MRS_concept " (+ ?id 1) " _on_p_temp)"crlf)
)

;
(defrule in_p_temp_month
(mofy  ?mahInA    ?month)
(id-concept_label ?id	?mahInA) 
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?id 1) " _in_p_temp)"crlf)
(printout ?*defdbug* "(rule-rel-values in_p_temp_month  id-MRS_concept " (+ ?id 1) " _in_p_temp)"crlf)
)

;Written by sakshi yadav date -13.06.19
;Ex-Rama reads two books in 2019.
(defrule in_p_temp
(id-concept_label	?k-id  ?num)
(rel_name-ids kriyA-k7t	?kri ?k-id)
(not (id-concept_label  ?k-id   ?hiConcept&kahAz_1|kaba_1|Aja_1|kala_1|kala_2))
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?k-id 1) " _in_p_temp)"crlf)
(printout ?*defdbug* "(rule-rel-values in_p_temp  id-MRS_concept " (+ ?k-id 1) " _in_p_temp)"crlf)
)

;Written by Shastri --date-- 12/06/19
;Rule for inserting MRS concept "_by_p" when karwA is present in passive sentences.
;e.x. rAvaNa rAma ke xvArA mArA gayA.
(defrule passive_by
(rel_name-ids kriyA-k1 ?kri ?k1)
(sentence_type  pass-assertive)
=>
(printout ?*mrsdef* "(MRS_info id-MRS_concept " (+ ?k1 1) " _by_p)"crlf)
(printout ?*defdbug* "(rule-rel-values passive_by id-MRS_concept "  (+ ?k1 1) " _by_p)"crlf)
)
