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

pyoxidizer_binary(
    name="storelistconv-bin",
    entry_point="storelistconv.main",
    dependencies=[":storelistconv-dist"],
)
