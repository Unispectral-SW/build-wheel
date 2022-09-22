#!/bin/bash
python3 setup.py bdist --cythonize
unzip -q -d ../prefix ./dist/*.whl