HOCKING-angular-kernel.pdf: HOCKING-angular-kernel.tex figure-angles-layouts.tex figure-features.tex figure-distance-funs.tex figure-svm.tex
	rm -rf *.log *.bbl *.aux
	pdflatex HOCKING-angular-kernel
	pdflatex HOCKING-angular-kernel
nodes2.RData: nodes2.R
	R --no-save < $<
nodes2.features.RData: nodes2.features.R nodes2.RData 
	R --no-save < $<
figure-angles-layouts.tex: figure-angles-layouts.R tikz.R nodes2.RData nodes2.features.RData
	R --no-save < $<
figure-features.tex: figure-features.R tikz.R nodes2.features.RData
	R --no-save < $<
figure-distance-funs.tex: figure-distance-funs.R tikz.R nodes2.features.RData
	R --no-save < $<
figure-svm.tex: figure-svm.R tikz.R nodes2.features.RData
	R --no-save < $<
clean:
	rm -f *.RData *~ *.aux *.log *.bbl *.pdf figure-*.tex tikzMetrics
