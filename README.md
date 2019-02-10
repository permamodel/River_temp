# Rivertemp

River water temperature model 

The river water temperature model is mainly applied in the Arctic rivers. Heat energy transfers considered include surface net solar radiation, net longwave radiation, latent heat due to evaporation and condensation, convective heat and the riverbed heat flux. 

You can run the model with the River_temp_portal.

Please note that the default riverbed deposit is sand and gravel, users can change the sedimentary material with corresponding physical and thermal parameters. 

Inputs

His: incident solar (shortwave) radiation    ------------Mfile 

Hdl: Downward thermal (Longwave) radiation   ------------Mfile 

Ta: Air temperature                          ------------Mfile 

Uw: Wind speed                               ------------Mfile 

rh: Relative humidity                        ------------Mfile 

P: Surface pressure                          ------------Mfile 

h: River stage                               ------------Sfile 

rivericeoff: First day of river induation

rivericeon: Last day of river induation

Output

Tw: Water temperature



