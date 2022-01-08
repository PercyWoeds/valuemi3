para namereport
@ lin,0  say chr(15)+nom_copy+"-"+namereport+"-"+upper(ini_user)
@ lin,180 say " FECHA : "+DTOC(DATE())
lin=lin+1
@ lin,0 say maes015.nom_emp
@ lin,180 say chr(15)+'PAG.  : '+TRANS(pag,'999')
lin=lin+1
@ lin,180 say chr(15)+'HORA  : '+TIME()
lin=lin+1