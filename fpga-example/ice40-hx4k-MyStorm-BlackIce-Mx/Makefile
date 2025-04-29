d=
e=tar.gz

help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

clean: ## Borrar paquete
	rm $d.$e

pack:
	tar -czvf $d.$e $d

encrypt: pack ## Encriptar y empaquetar
	gpg --output $d.$e.gpg --symmetric $d.$e

unpack: decrypt ## Desncriptar y desempaquetar
	tar -xzf $d.$e

decrypt:
	gpg --output $d.$e --decrypt $d.$e.gpg

clean-cache: ## Limpiar la caché del gpg-agent responsable de guardar constraseñas en el mismo equipo
	gpg-connect-agent reloadagent /bye
	# Ver el estado del agente
	# gpgconf --list-options gpg-agent
