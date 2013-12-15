del "doc/." /s /q
haxe --no-output -xml doc/at.xml build.hxml
haxelib run dox -r doc/.. -o doc/ -i doc
PAUSE