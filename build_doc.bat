@IF "%1"=="" (
call build_doc.bat %~dp0doc 
EXIT )
@echo doc-directory: %1

del "doc/." /s /q
haxe --no-output -xml doc/at.xml build.hxml
haxelib run dox -r %1 -o doc/ -i doc
PAUSE