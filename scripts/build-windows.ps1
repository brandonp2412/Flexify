Remove-Item -Path flexify/* -Recurse -Force
cp -r -Force //host.lan/Data/flexify-source/* flexify
cd flexify
dart run msix:create
cp -r -Force build/windows/x64/runner/Release/* //host.lan/Data/flexify
