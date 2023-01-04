python_sources(name="libstorelistconv", sources=["**/*.py"])

python_requirements(name="reqs")

python_distribution(
    name="storelistconv-dist",
    dependencies=[":libstorelistconv"],
    wheel=True,
    sdist=False,
    provides=setup_py(
        name="storelistconv-dist",
        version="0.0.1",
        description="A distribution for the storelist converter library.",
    ),
)

pex_binary(
  name="storelistconverter",
  entry_point="storelistconv/main.py",
)
