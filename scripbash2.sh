#!bin/bash

#descargar archivo
curl -s https://archive.ics.uci.edu/ml/machine-learning-databases/tic-mld/tic.tar.gz > tic.tar.gz

#descomprimir
tar -xvzf tic.tar.gz

#número de líneas
cat ticdata2000.txt | wc -l
cat ticeval2000.txt | wc -l

#número de columnas
head -1 ticdata2000.txt | tr "\t" "\n" | wc -l
head -1 ticeval2000.txt | tr "\t" "\n" | wc -l

#convertir archivos, porque si no no me sale nada :/
dos2unix TicDataDescr.txt dictionary.txt ticdata2000.txt ticeval2000.txt tictgts2000.txt

#agregar encabezados
egrep --binary-files=text "^[0-9]+\s[A-Z][A-Z]+" TicDataDescr.txt | cut -d' ' -f2 | paste -sd '\t' > nomcolent.txt
cp nomcolent.txt nomcolpru.txt
sed -i s/'\t\w*$'// nomcolpru.txt
cat nomcolent.txt ticdata2000.txt | tr '\t' '|' > ticdatah.txt
cat nomcolpru.txt ticeval2000.txt | tr '\t' '|' > ticevalh.txt

#variables categóricas
sed -n '208,248p;249q' TicDataDescr.txt | cut -f2-3 --output-delimiter='|' | header -a 'MOSTYPE|MOSTYPECAT' > catL0.txt

sed -n '252,262p;263q' TicDataDescr.txt | cut -d' ' -f2-3 > auxcat1.txt
sed -n '252,262p;263q' TicDataDescr.txt | cut -d' ' -f1 > auxcat2.txt
paste -d'|' auxcat2.txt auxcat1.txt | sort -t '|' | head -n 6 | header -a 'MGEMLEEF|MGEMLEEFCAT' > catL1.txt

sed -n '268,286p;287q' TicDataDescr.txt | cut -d' ' -f2-5 > auxcat1.txt
sed -n '268,286p;287q' TicDataDescr.txt | cut -d' ' -f1 > auxcat2.txt
paste -d'|' auxcat2.txt auxcat1.txt | sort -t '|' -k 1n | tail -n 10 | header -a 'MOSHOOFD|MOSHOOFDCAT' > catL2.txt

sed -n '292,310p;311q' TicDataDescr.txt | cut -d' ' -f2-5 > auxcat1.txt
sed -n '292,310p;311q' TicDataDescr.txt | cut -d' ' -f1 > auxcat2.txt
paste -d'|' auxcat2.txt auxcat1.txt | sort -t '|' | head -n 10 | header -a 'MGODRK|MGODRKCAT' > catL3.txt

sed -n '316,334p;335q' TicDataDescr.txt | cut -d' ' -f2-5 > auxcat1.txt
sed -n '316,334p;335q' TicDataDescr.txt | cut -d' ' -f1 > auxcat2.txt
paste -d'|' auxcat2.txt auxcat1.txt | sort -t '|' | head -n 10 | header -a 'PWAPART|PWAPARTCAT' > catL4.txt

head -n 1 ticdatah.txt > auxnomcol.txt
cat ticdatah.txt | header -d | sort -t '|' -k 1n > auxinfo.txt
cat auxnomcol.txt auxinfo.txt > auxdata.txt
join auxdata.txt catL0.txt --header -1 1 -2 1 -t '|' -a 1 > auxdata0.tx
awk -F'|' '{t = $1; $1 = $4; $4 = t; print; }' OFS='|' auxdata0.txt | sort -t '|' -k 1n > auxdata.txt
join auxdata.txt catL1.txt --header -1 1 -2 1 -t '|' -a 1 > auxdata1.txt
awk -F'|' '{t = $1; $1 = $5; $5 = t; print; }' OFS='|' auxdata1.txt | sort -t '|' -k 1n > auxdata.txt
join auxdata.txt catL2.txt --header -1 1 -2 1 -t '|' -a 1 > auxdata2.txt
awk -F'|' '{t = $1; $1 = $6; $6 = t; print; }' OFS='|' auxdata2.txt | head -n 1 > auxnomcol.txt
awk -F'|' '{t = $1; $1 = $6; $6 = t; print; }' OFS='|' auxdata2.txt | header -d | sort -t '|' -k 1n > auxinfo.txt 
cat auxnomcol.txt auxinfo.txt > auxdata.txt
join auxdata.txt catL3.txt --header -1 1 -2 1 -t '|' -a 1 > auxdata3.txt
awk -F'|' '{t = $1; $1 = $44; $44 = t; print; }' OFS='|' auxdata3.txt | head -n 1 > auxnomcol.txt
awk -F'|' '{t = $1; $1 = $44; $44 = t; print; }' OFS='|' auxdata3.txt | header -d | sort -t '|' -k 1n > auxinfo.txt
cat auxnomcol.txt auxinfo.txt > auxdata.txt
join auxdata.txt catL4.txt --header -1 1 -2 1 -t '|' -a 1 > auxdata4.txt
< auxdata4.txt cut -d'|' -f2-3,7-43,45- > ticdata.txt

head -n 1 ticevalh.txt > auxnomcol.txt
cat ticevalh.txt | header -d > auxinfo.txt
cat auxnomcol.txt auxinfo.txt > auxevalp.txt
cat tictgts2000.txt | header -a 'CARAVAN' > colCARAVAN.txt
paste -d'|' auxevalp.txt colCARAVAN.txt > auxeval.txt
head -n 1 auxeval.txt > auxnomcol.txt
cat auxeval.txt | header -d | sort -t '|' -k 1n > auxinfo.txt
cat auxnomcol.txt auxinfo.txt > auxeval.txt
join auxeval.txt catL0.txt --header -1 1 -2 1 -t '|' -a 1 > auxeval0.txt
awk -F'|' '{t = $1; $1 = $4; $4 = t; print; }' OFS='|' auxeval0.txt | sort -t '|' -k 1n > auxeval.txt 
join auxeval.txt catL1.txt --header -1 1 -2 1 -t '|' -a 1 > auxeval1.txt
awk -F'|' '{t = $1; $1 = $5; $5 = t; print; }' OFS='|' auxeval1.txt | sort -t '|' -k 1n > auxeval.txt 
join auxeval.txt catL2.txt --header -1 1 -2 1 -t '|' -a 1 > auxeval2.txt
awk -F'|' '{t = $1; $1 = $6; $6 = t; print; }' OFS='|' auxeval2.txt | head -n 1 > auxnomcol.txt
awk -F'|' '{t = $1; $1 = $6; $6 = t; print; }' OFS='|' auxeval2.txt | header -d | sort -t '|' -k 1n > auxinfo.txt
cat auxnomcol.txt auxinfo.txt > auxeval.txt
join auxeval.txt catL3.txt --header -1 1 -2 1 -t '|' -a 1 > auxeval3.txt
awk -F'|' '{t = $1; $1 = $44; $44 = t; print; }' OFS='|' auxeval3.txt | head -n 1 > auxnomcol.txt
awk -F'|' '{t = $1; $1 = $44; $44 = t; print; }' OFS='|' auxeval3.txt | header -d | sort -t '|' -k 1n > auxinfo.txt
cat auxnomcol.txt auxinfo.txt > auxeval.txt
join auxeval.txt catL4.txt --header -1 1 -2 1 -t '|' -a 1 > auxeval4.txt
< auxeval4.txt cut -d'|' -f2-3,7-43,45- > ticeval.txt


#analisis de variables
chmod +x analisisdata.R
chmod +x analisiseval.R
./analisisdata.R > analisisdata.txt
./analisisdata.R > analisisdata.txt



