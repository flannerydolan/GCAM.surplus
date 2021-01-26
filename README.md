# GCAM.surplus
Code for the figures and analysis in the Dolan et al. 2021 paper "Evaluating the economic impact of water scarcity in a changing world."

This work used the Global Change Analysis Model (GCAM) to simulate thousands of future scenarios and obtain estimates of future water supply and demand. We calculated the change in economic surplus between scenarios with an unlimited supply of water and their corresponding scenarios with physical constraints on water availability. We find the drivers of economic impact in different basins using the CART algorithm.

This work can be replicated using the following approach. 

The GCAM is an open source model available at https://github.com/JGCRI/gcam-core/releases. 
This work used a private branch of the model, but version 5.1.1 should yield similar if not identical results. 

Many of the input files used in the experiment are not available in the public release version but are available by request. 

Configuration files were generated using ElementTree in Python and using nested loops to generate a full factorial sampling of all of the factors varied. These files (for both experimental and unlimited scenarios) are all available in the `data/config_files` folder. Importantly, the supplyDemandCurves bool must be set to 1 for the curves to write out. Each configuration file should contain a xml that outlines what markets to generate supply/demand curves for and how those curves should be generated (i.e., using absolute or relative prices). The file used in this experiment, `supply_demand_curves.xml`, is included in the `data` folder.

The scenarios were then run in a HPC environment and queried using the `rgcam` package (available at https://github.com/JGCRI/rgcam). The queries used in this experiment include `runoff.xml`, `water_withdrawals_basin.xml`, `price_water.xml`, and `land-allocation.xml`. These files are available in the `data` folder. The script `R/price_water.R` provides an example of how to run a batch query. The resulting raw files for all scenarios run are also included to generate the figures in the paper. The files `supply.rda` and `with.rda` contain information for all basins while the files beginning with `ap_` and `indus_` contain data for the Arabian Peninsula and the Indus River Basin respectively. 

The raw supply and demand curve files are available upon request. These files were processed by pairing the necessary unlimited water and constrained water scenario files and using the `calc_net_surplus.R` function within the `R` folder on every market and in every timestep. The resulting change in surplus file is `data/sur.rda`. This data may be analyzed as is, but users should note that the units are in billions of 1975 USD. The figure-generating scripts convert to 2020 USD. 

We used the `rpart` implementation of the CART algorithm to find influential factors driving high magnitudes of economic impact. We used both the classification (`method='class'`) and regression (`method='anova'`) approaches at different stages in the analysis. The script `R/bagged_CART.R` gives an example of how to generate a CART tree in a basin with bagging. 

All requests for additional data should be made to flannery.dolan@tufts.edu.
