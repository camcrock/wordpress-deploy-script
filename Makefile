.PHONY: dev deploy dbdeploy import dbimport help update

include envfile

help: ## Display the help
	@grep -E '^[a-zA-Z_-]+:.*? ## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

dev: ## Launch local dev server
	php -S $(localdev) -d display_errors=1

import: ## Import all files from server
	rsync -av $(ssh):$(path) ./ \
		--exclude wp-config.php \
		--exclude .htaccess \
		--exclude .htpasswd \
		--exclude .git

deploy: ## Deploy files to the server (exclude uploads)
	rsync -av ./ $(ssh):$(path) \
		--exclude Makefile \
		--exclude envfile \
		--exclude .DS_Store \
		--exclude .htaccess \
		--exclude .htpasswd \
		--exclude wp-config.php \
		--exclude .git \
		--exclude wp-content/uploads

dbdeploy: ## Send the database and replace the URLs
	wp db export --add-drop-table dump.sql
	rsync -av ./dump.sql $(ssh):$(path)
	ssh $(ssh) "cd $(path); $(phplive) $(wpclilive) db import dump.sql; $(phplive) $(wpclilive) search-replace '$(localdomain)' '$(livedomain)'; rm dump.sql"
	rm dump.sql

dbimport: ## Get the database from the server and replace the URLs
	ssh $(ssh) "cd $(path); $(phplive) $(wpclilive) db export --add-drop-table dump.sql"
	rsync -av $(ssh):$(path)dump.sql ./
	ssh $(ssh) "rm $(path)dump.sql"
	wp db import dump.sql
	wp search-replace '$(livedomain)' '$(localdomain)'
	rm dump.sql

update: ## Update local wordpress core and plugins
	wp core update
	wp plugin update --all
