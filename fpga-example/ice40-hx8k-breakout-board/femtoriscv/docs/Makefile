BASE_NAME=$(basename $f)

h: help

plantumlSVG:
	@echo "Generar svg desde código plantuml"
	@echo "usar f=file sin la extensión .pu"
	plantuml -tsvg $(BASE_NAME).pu

svgtopdf:
	inkscape $(BASE_NAME).svg --export-filename=$(BASE_NAME).pdf ||\
		inkscape $f --export-filename=$(BASE_NAME).pdf

rmsvg:
	@echo "remover $(BASE_NAME).svg"
	rm -f $(BASE_NAME).svg

plantumlPDF: plantumlSVG svgtopdf rmsvg	## Crear un PDF desde el f=plantuml.pu

rmpdf: ## Remover el pdf seleccionado con f=
	@echo "remover $f.pdf"
	rm -i $(BASE_NAME).pdf || rm -i $f

help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

