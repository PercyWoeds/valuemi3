SET EXCLUSIVE OFF
CLOSE DATABASES all

SELECT 0
USE x:\ma05
COPY TO c:\pventa\ma051


SELECT 0
USE y:\ma05
COPY TO c:\pventa\ma052

SELECT 0
USE z:\ma05
COPY TO c:\pventa\ma053

USE c:\pventa\ma051
APPEND FROM c:\pventa\ma052
APPEND FROM c:\pventa\ma053
COPY TO c:\pventa\ma05CLIENTES

USE
CLOSE DATABASES all


