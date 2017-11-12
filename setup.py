from setuptools import setup

name = 'xonda'

setup(
    name=name,
    version='0.2',
    license='MIT',
    url='https://github.com/gforsyth/xonda',
    description='A xonsh wrapper around conda',
    packages=['xontrib'],
    package_dir={'xontrib': 'xontrib'},
    package_data={'xontrib': ['*.xsh']},
    author='Gil Forsyth',
    author_email='gilforsyth@gmail.com',
    zip_safe=False,
)
