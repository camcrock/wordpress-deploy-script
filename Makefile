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
	wp db export --add-drop-table localdump.sql
	rsync -av ./localdump.sql $(ssh):$(path)
	ssh $(ssh) "cd $(path); $(phplive) $(wpclilive) db export --add-drop-table livedump.sql; mkdir -p ../_dbbackups; gzip -c livedump.sql > ../_dbbackups/live-$(shell date +%Y%m%d-%H%M%S).sql.gz; rm livedump.sql"
	ssh $(ssh) "cd $(path); $(phplive) $(wpclilive) db import localdump.sql; $(phplive) $(wpclilive) search-replace '$(localdomain)' '$(livedomain)'; rm localdump.sql"
	rm localdump.sql

dbimport: ## Get the database from the server and replace the URLs
	ssh $(ssh) "cd $(path); $(phplive) $(wpclilive) db export --add-drop-table livedump.sql; gzip -c livedump.sql > ../_dbbackups/live-$(shell date +%Y%m%d-%H%M%S).sql.gz"
	rsync -av $(ssh):$(path)livedump.sql ./
	ssh $(ssh) "rm $(path)livedump.sql"
	wp db export --add-drop-table localdump.sql
	mkdir -p ../_dbbackups
	gzip -c localdump.sql > ../_dbbackups/local-$(shell date +%Y%m%d-%H%M%S).sql.gz
	rm localdump.sql
	wp db import livedump.sql
	wp search-replace '$(livedomain)' '$(localdomain)'
	rm livedump.sql

update: ## Update local wordpress core and plugins
	wp core update
	wp plugin update --all
