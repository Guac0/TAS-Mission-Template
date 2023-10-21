#generates zips and pbos for release
#zips
Compress-Archive -LiteralPath "C:\Users\Guac\Documents\Arma 3\mpmissions\Github\TAS-Mission-Template\TAS_MissionTemplate_6ManSquads.VR" -DestinationPath "C:\Users\Guac\Documents\Arma 3\mpmissions\Github\TAS-Mission-Template\Release_Files\TAS_MissionTemplate_6ManSquads.VR.zip"
Compress-Archive -LiteralPath "C:\Users\Guac\Documents\Arma 3\mpmissions\Github\TAS-Mission-Template\TAS_MissionTemplate_8ManSquads.VR" -DestinationPath "C:\Users\Guac\Documents\Arma 3\mpmissions\Github\TAS-Mission-Template\Release_Files\TAS_MissionTemplate_8ManSquads.VR.zip"
Compress-Archive -LiteralPath "C:\Users\Guac\Documents\Arma 3\mpmissions\Github\TAS-Mission-Template\TAS_MissionTemplate_10ManSquads.VR" -DestinationPath "C:\Users\Guac\Documents\Arma 3\mpmissions\Github\TAS-Mission-Template\Release_Files\TAS_MissionTemplate_10ManSquads.VR.zip"
#pbos are a mess, i can get them to work but they dont fully build due to not liking KP and they exclude .bat, so just do them manually
#MakePbo "C:\Users\Guac\Documents\Arma 3\mpmissions\Github\TAS-Mission-Template\" "C:\Users\Guac\Documents\Arma 3\mpmissions\Github\TAS-Mission-Template\Release_Files\TAS_MissionTemplate_6ManSquads.VR.pbo"
#MakePbo "C:\Users\Guac\Documents\Arma 3\mpmissions\Github\TAS-Mission-Template\" "C:\Users\Guac\Documents\Arma 3\mpmissions\Github\TAS-Mission-Template\Release_Files\TAS_MissionTemplate_8ManSquads.VR.pbo"
#MakePbo "C:\Users\Guac\Documents\Arma 3\mpmissions\Github\TAS-Mission-Template\" "C:\Users\Guac\Documents\Arma 3\mpmissions\Github\TAS-Mission-Template\Release_Files\TAS_MissionTemplate_10ManSquads.VR.pbo"
pause