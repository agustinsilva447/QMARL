from setuptools import setup, find_packages

__VERSION__ = '0.99a'
__NAME__ = 'udma'

with open('README.md') as readme_file:
    README = readme_file.read()

with open('LICENSE') as license_file:
    LICENSE = license_file.read()

setup(
    name=__NAME__,
    python_requires='>=3.6',
    author='MLAB-ICTP Team',
    version= __VERSION__,
    author_email='wflorian@ictp.it',
    description='Automatic and platform-independent CLI communication system via ethernet \n with ComBlock support.',
    long_description=README,
    long_description_content_type='text/markdown',
    url='https://gitlab.com/brunovali/udma',
    packages=find_packages(),
    license= LICENSE,
    install_requires=[
        'cmd2',
        'appdirs',
        'tqdm'
    ],
    entry_points={
        'console_scripts': ['udma=src.udma:main']
    }
)
