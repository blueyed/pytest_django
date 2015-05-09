.PHONY: docs test clean isort

export DJANGO_SETTINGS_MODULE?=pytest_django_test.settings_sqlite_file

VIRTUALENV:=build/venv

testenv: $(VIRTUALENV)/bin/py.test

test: $(VIRTUALENV)/bin/py.test
	$(VIRTUALENV)/bin/pip install -e .
	$(VIRTUALENV)/bin/py.test tests

$(VIRTUALENV)/bin/python $(VIRTUALENV)/bin/pip:
	virtualenv $(VIRTUALENV)

$(VIRTUALENV)/bin/py.test: $(VIRTUALENV)/bin/python requirements.txt
	$(VIRTUALENV)/bin/pip install -Ur requirements.txt
	touch $@

$(VIRTUALENV)/bin/sphinx-build: $(VIRTUALENV)/bin/pip
	$(VIRTUALENV)/bin/pip install sphinx

docs: $(VIRTUALENV)/bin/sphinx-build
	SPHINXBUILD=../$(VIRTUALENV)/bin/sphinx-build $(MAKE) -C docs html

# See setup.cfg for configuration.
isort:
	find pytest_django tests -name '*.py' -exec isort {} +

clean:
	rm -rf pytest_django.egg-info/ build/
