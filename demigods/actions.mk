.PHONY: init create delete reload ping check-ready check-live

SOLR_CORE_HOME:=/var/solr/data


CONFIG_SET:=drupal
CONFIG_HOST:=localhost
CONFIG_CORE:=${PROJECT_NAME}
CONFIG_INSTANCE_DIR=${SOLR_CORE_HOME}/${CONFIG_CORE}

max_try ?= 1
wait_seconds ?= 1
delay_seconds ?= 1

init:
	init_solr

# We don't use solr CLI because it does not create configs out of config set.
create:
	curl -sIN "http://${CONFIG_HOST}:8983/solr/admin/cores?action=CREATE&name=${CONFIG_CORE}&configSet=${CONFIG_SET}&instanceDir=${CONFIG_INSTANCE_DIR}" \
		| head -n 1 | awk '{print $$2}' | grep -q 200

delete:
	echo "Deleting core ${CONFIG_CORE}"
	curl -sIN "http://${CONFIG_HOST}:8983/solr/admin/cores?action=UNLOAD&core=${CONFIG_CORE}&deleteIndex=true&deleteDataDir=true&deleteInstanceDir=true" \
		| head -n 1 | awk '{print $$2}' | grep -q 200
	rm -rf "{CONFIG_INSTANCE_DIR}"

reload:
	echo "Reloading core ${CONFIG_CORE}"
	curl -sIN "http://${CONFIG_HOST}:8983/solr/admin/cores?action=RELOAD&core=${CONFIG_CORE}" \
		| head -n 1 | awk '{print $$2}' | grep -q 200

ping:
	echo "Pinging core ${CONFIG_CORE}"
	curl -sIN "http://${CONFIG_HOST}:8983/solr/${CONFIG_CORE}/admin/ping" \
		| head -n 1 | awk '{print $$2}' | grep -q 200

check-ready:
	wait_solr $${CONFIG_HOST} $(max_try) $(wait_seconds) $(delay_seconds)

check-live:
	@echo "OK"
