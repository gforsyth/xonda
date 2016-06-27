try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

name = "xonda"

setup(
    name = name,
    version = "0.1",
    description = "A xonsh wrapper around conda",
    packages=['xontrib'],
    package_dir={'xontrib': 'xontrib'},
    package_data={'xontrib': ['*.xsh', '*.py']},
    author="Gil Forsyth",
    author_email="gilforsyth@gmail.com",
    include_package_data=True,
)
