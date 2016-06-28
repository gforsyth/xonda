from setuptools import setup
from os import path

here = path.abspath(path.dirname(__file__))

with open(path.join(here, 'README.md'), 'r') as f:
    long_description = f.read()

name = "xonda"

setup(
    name=name,
    version="0.1.1",
    description="A xonsh wrapper around conda",
    long_description=long_description,
    packages=['xontrib'],
    package_dir={'xontrib': 'xontrib'},
    package_data={'xontrib': ['*.xsh']},
    author="Gil Forsyth",
    author_email="gilforsyth@gmail.com",
    include_package_data=True,
)
