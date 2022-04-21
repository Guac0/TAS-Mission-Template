#generates zips and pbos for release
#zips
Compress-Archive -LiteralPath "C:\Users\andre\Documents\Arma 3 - Other Profiles\Guac\mpmissions\Github\TAS-Mission-Template\TAS_MissionTemplate_5ManSquads.VR" -DestinationPath "C:\Users\andre\Documents\Arma 3 - Other Profiles\Guac\mpmissions\Github\TAS-Mission-Template\5ManTemplates\TAS_MissionTemplate_5ManSquads.VR.zip"
Compress-Archive -LiteralPath "C:\Users\andre\Documents\Arma 3 - Other Profiles\Guac\mpmissions\Github\TAS-Mission-Template\TAS_MissionTemplate_8ManSquads.VR" -DestinationPath "C:\Users\andre\Documents\Arma 3 - Other Profiles\Guac\mpmissions\Github\TAS-Mission-Template\5ManTemplates\TAS_MissionTemplate_8ManSquads.VR.zip"
Compress-Archive -LiteralPath "C:\Users\andre\Documents\Arma 3 - Other Profiles\Guac\mpmissions\Github\TAS-Mission-Template\TAS_MissionTemplate_10ManSquads.VR" -DestinationPath "C:\Users\andre\Documents\Arma 3 - Other Profiles\Guac\mpmissions\Github\TAS-Mission-Template\5ManTemplates\TAS_MissionTemplate_10ManSquads.VR.zip"
#pbos
MakePbo [-A] "C:\Users\andre\Documents\Arma 3 - Other Profiles\Guac\mpmissions\Github\TAS-Mission-Template\TAS_MissionTemplate_5ManSquads.VR"
MakePbo [-A] "C:\Users\andre\Documents\Arma 3 - Other Profiles\Guac\mpmissions\Github\TAS-Mission-Template\TAS_MissionTemplate_8ManSquads.VR"
MakePbo [-A] "C:\Users\andre\Documents\Arma 3 - Other Profiles\Guac\mpmissions\Github\TAS-Mission-Template\TAS_MissionTemplate_10ManSquads.VR"