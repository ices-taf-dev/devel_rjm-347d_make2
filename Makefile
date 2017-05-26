RUN=Rscript --vanilla

# final output
all: upload/plot/dls.png

# db.R + [www] -> catch.csv + survey.csv + summary.csv
db/catch.csv: db.R
	$(RUN) db.R
db/survey.csv: db.R
	$(RUN) db.R
db/summary.csv: db.R
	$(RUN) db.R

# input.R + catch.csv + survey.csv -> input.RData
input/input.RData: input.R db/catch.csv db/survey.csv
	$(RUN) input.R

# model.R + input.RData -> dls.txt
model/dls.txt: model.R input/input.RData
	$(RUN) model.R

# output.R + dls.txt -> dls.txt
output/dls.txt: output.R model/dls.txt
	$(RUN) output.R

# upload.R + catch.csv + survey.csv + summary.csv + dls.txt
# ->         catch.csv + survey.csv + summary.csv + dls.txt
upload/input/catch.csv: upload.R db/catch.csv
	$(RUN) upload.R
upload/input/survey.csv: upload.R db/survey.csv
	$(RUN) upload.R
upload/input/summary.csv: upload.R db/summary.csv
	$(RUN) upload.R
upload/output/dls.txt: upload.R output/dls.txt
	$(RUN) upload.R

# xtra_plot.R + survey.csv + dls.txt -> dls.png
upload/plot/dls.png: xtra_plot.R upload/input/survey.csv upload/output/dls.txt
	$(RUN) xtra_plot.R

clean:
	$(RUN) -e "icesTAF::clean()"
