powershell -Command "(gc cmdRallypoint.sqf) -replace 'Cmd', 'Alpha' | Out-File -encoding ASCII alphaRallypoint.sqf"
powershell -Command "(gc cmdRallypoint.sqf) -replace 'Cmd', 'Bravo' | Out-File -encoding ASCII bravoRallypoint.sqf"
powershell -Command "(gc cmdRallypoint.sqf) -replace 'Cmd', 'Charlie' | Out-File -encoding ASCII charlieRallypoint.sqf"
powershell -Command "(gc cmdRallypoint.sqf) -replace 'Cmd', 'Delta' | Out-File -encoding ASCII deltaRallypoint.sqf"
powershell -Command "(gc cmdRallypoint.sqf) -replace 'Cmd', 'Echo' | Out-File -encoding ASCII echoRallypoint.sqf"
powershell -Command "(gc cmdRallypoint.sqf) -replace 'Cmd', 'Foxtrot' | Out-File -encoding ASCII foxtrotRallypoint.sqf"