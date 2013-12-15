del "doc/." /s /q
haxe --no-output -xml doc/at.xml build.hxml
haxelib run dox -r %~dp0doc -o doc/ -i doc
PAUSE