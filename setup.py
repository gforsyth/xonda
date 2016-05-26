try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

name = "xonda"

setup(
    name = name,
    version = "0.1.0",
    description = "A tool to easily switch between conda environments",
    packages=['xontrib'],
    package_dir={'xontrib': 'xontrib'},
    package_data={'xontrib': ['*.xsh']},
    include_package_data=True,
)
