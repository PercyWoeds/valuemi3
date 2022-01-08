local rutaawinzip,CDIRRED,FRASE
CDIRRED="C:\SCG\SCG1"
CDIRRED1="C:\SCG\PTIENDA"
FRASE=SPAC(254)

rutaawinzip="C:\Archivos de programa\WinZip\WINZIP32.EXE"

Frase="/N1 "+rutaawinzip +" -a -r "+alltrim(cdirred)+"\copias\"+;
"SINVFTES.zip "+alltrim(CDIRRED1)+"\*.SC?  *.VC? *.H *.PRG *.MN?  PTIENDA.*  *.JPG  *.BMP"
!&FRASE
FRASE=SPAC(254)
Frase="/N1 "+rutaawinzip +" -a -r "+alltrim(cdirred)+"\copias\"+;
"SINVDB.zip "+alltrim(cdirred1)+"\*.DBF"
!&FRASE