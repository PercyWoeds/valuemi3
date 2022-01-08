WAIT WINDOW "Generando archivo..." nowait 
SET DELETED ON
SET DATE BRITISH 
SET CENTURY on
SET SAFETY off
set excl off


USE x:\tirada
COPY TO c:\pventa\tiradax FOR fecha>= CTOD('16/12/2018') AND fecha <= CTOD('18/12/2018') 

USE y:\tirada
COPY TO tiraday FOR fecha>= CTOD('16/12/2018') AND fecha <= CTOD('18/12/2018') 
USE z:\tirada
COPY TO tiradaz FOR fecha>= CTOD('16/12/2018') AND fecha <= CTOD('18/12/2018') 

USE c:\pventa\tiradax
APPEND FROM tiraday
APPEND FROM tiradaz

CLOSE DATABASES all
