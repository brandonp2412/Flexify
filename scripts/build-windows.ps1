Remove-Item -Path flexify/* -Recurse -Force
robocopy //host.lan/Data/flexify-source flexify /E /Z /R:3 /NFL /NDL /NP /XD build*
cd flexify
dart run msix:create
robocopy build/windows/x64/runner/Release //host.lan/Data/flexify /E /Z /R:3 /NFL /NDL /NP /XD build*
