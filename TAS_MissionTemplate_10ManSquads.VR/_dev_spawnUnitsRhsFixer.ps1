# If you are using RHS with spawnUnits.sqf and get errors, run this file using powershell to attempt automatic fixing of various known issues.
# You may need to go in manually and do additional fixes yourself, especially for example if you change the decals on vehicles in their attributes ("parseNumber -1" in the code below will instead be a different number depending on the decal)
# Note that it will create a backup spawnUnits.sqf.backup without any changes applied in case something goes wrong.

Copy-Item "spawnUnits.sqf" -Destination "spawnUnits.sqf.backup"
(gc "spawnUnits.sqf") -replace "!= 'NoChange'", "isNotEqualTo 'NoChange'" | Set-Content -Path "spawnUnits.sqf"
(gc "spawnUnits.sqf") -replace "parseNumber -1 >= 0", "parseNumber '-1' >= 0" | Set-Content -Path "spawnUnits.sqf"
(gc "spawnUnits.sqf") -replace "[_this,0] call rhs_fnc_lockTop", "[_this,true] call rhs_fnc_lockTop" | Set-Content -Path "spawnUnits.sqf"
(gc "spawnUnits.sqf") -replace "[_this,1] call rhs_fnc_lockTop", "[_this,false] call rhs_fnc_lockTop" | Set-Content -Path "spawnUnits.sqf"
Read-Host -Prompt "Press Enter to exit"