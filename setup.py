from setuptools import setup

setup(
    name="hokiestalker",
    packages=["hokiestalker"],
    scripts=["hs"],
    version="2.0",
    description="Query the Virginia Tech people search service for information about a person.",
    license="ISC",
    author="mutantmonkey",
    author_email="hokiestalker@mutantmonkey.in",
    url="https://github.com/mutantmonkey/hokiestalker",
    install_requires=["lxml>=3.2.3"]
)
