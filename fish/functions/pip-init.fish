function pip-init
  echo -e "\e[36m[pip-init]] update pip and setuptools\e[m"
  pip install -U pip setuptools

  echo -e "\e[36m[pip-init]] update jedi, pynvim, nose, and ptpython\e[m"
  pip install jedi pynvim nose ptpython

  if test -e "setup.py"
    echo -e "\n\e[36m[pip-init] install this package with editable mode\e[m"
    pip install -e .
  end

  if test -e "requirements-dev.txt"
    echo -e "\n\e[36m[pip-init] install dev requirements\e[m"
    pip install -r "requirements-dev.txt"
  else if test -e "requirements.txt"
    echo -e "\n\e[36m[pip-init] install project requirements\e[m"
    pip install -r "requirements.txt"
  end
end
