# Rivertemp

River water temperature model 

The river water temperature model is designed to be applied in Arctic rivers (although it may be applicable for other settings). Heat energy transfers considered include surface net solar radiation, net longwave radiation, latent heat due to evaporation and condensation, convective heat and the riverbed heat flux. 

You can run the model with the River_temp_portal.

Please note that the default riverbed deposit is sand and gravel, users can change the sedimentary material with alternative soil/substrate physical and thermal parameters. 

Inputs

His: Incident solar (shortwave) radiation    ------------Mfile 

Hdl: Downward thermal (longwave) radiation   ------------Mfile 

Ta: Air temperature                          ------------Mfile 

Uw: Wind speed                               ------------Mfile 

rh: Relative humidity                        ------------Mfile 

P: Surface pressure                          ------------Mfile 

h: River stage                               ------------Sfile 

rivericeoff: First day of river induation

rivericeon: Last day of river induation

Output

Tw: Water temperature

The underlying theory and assumptions of this model are published in JGR-ES: Changing Arctic River Dynamics Cause Localized Permafrost Thaw, Lei Zheng Irina Overeem Kang Wang Gary D. Clow, 2019. Journal of Geophysical Research - Earth Surface. https://doi.org/10.1029/2019JF005060

