# Replication package for Jensen and Weigel (2025, JEL)

## Replication instructions

### Suggested folder structure for replication

replication_package
    data
	raw
	intermediate
	final
    figures 

## Data Availability and Provenance

We certify that we have legitimate access to and permission to use all data used in this manuscript. We further certify that we have permission to redistribute/publish the data contained within this replication package.

All of the data used is publicly available. We provide links below. We have adjusted the format of some of the raw data for easier input into the analysis (see remarks below for details).

### Data citations and availability statements

'UNU-WIDER Government Revenue Dataset'. Version 2023. https://doi.org/10.35188/UNU-WIDER/GRD-2023. There are no access modalities/restrictions and all data is available for free and public download at the provided links. [Downloaded on May 22, 2024]

'Varieties of Democracy (V-Dem) Project'. Version Country-Date: V-Dem version 14 https://www.v-dem.net/data/the-v-dem-dataset/country-date-v-dem-v14/; Coppedge, Michael, John Gerring, Carl Henrik Knutsen, Staffan I. Lindberg, Jan Teorell, David Altman, Fabio Angiolillo, Michael Bernhard, Cecilia Borella, Agnes Cornell, M. Steven Fish, Linnea Fox, Lisa Gastaldi, Haakon Gjerløw, Adam Glynn, Ana Good God, Sandra Grahn, Allen Hicken, Katrin Kinzelbach, Joshua Krusell, Kyle L. Marquardt, Kelly McMann, Valeriya Mechkova, Juraj Medzihorsky, Natalia Natsika, Anja Neundorf, Pamela Paxton, Daniel Pemstein, Josefine Pernes, Oskar Ryd´en, Johannes von R¨omer, Brigitte Seim, Rachel Sigman, Svend-Erik Skaaning, Jeffrey Staton, Aksel Sundstr¨om, Eitan Tzelgov, Yi-ting Wang, Tore Wig, Steven Wilson and Daniel Ziblatt. 2024. ”V-Dem [Country-Year/Country-Date] Dataset v14” https://doi.org/10.23696/mcwt-fr58. [Downloaded on May 27, 2024] There are no access modalities/restrictions and all data is available for free and public download at the provided links.

'World Bank GDP per capita constant 2015 US$'. Indicator NY.GDP.PCAP.KD https://data.worldbank.org/indicator/NY.GDP.PCAP.KD [Downloaded on August 8, 2024] There are no access modalities/restrictions and all data is available for free and public download at the provided links.

CIAT, IMF, IOTA and OECD, 'International Survey on Revenue Administration' 2020, 2021, 2022, 2023 
https://data.rafit.org/?sk=e1ed4b20-815e-4e76-bc6d-9032fc89f4f4&sId=1698171617143 [Downloaded on May 22, 2024 ] There are no access modalities/restrictions and all data is available for free and public download at the provided links.

'World Bank GDP per capita constant 2015 US$'. Indicator NY.GDP.PCAP.KD https://data.worldbank.org/indicator/NY.GDP.PCAP.KD [Downloaded on August 8, 2024] There are no access modalities/restrictions and all data is available for free and public download at the provided links.

### Remarks on data sources

- We are using a pre-processed version of the V-DEM dataset in the building code for computational reasons, where we removed the vast majority of variables (no further changes made). The raw V-DEM dataset is also attached under 'data\raw' with the name 'V-Dem-CY-Full+Others-v14' as a CSV file. The accompanying R-file 'vdem_keep_relevant_variables_only.R' is used to extract the relevant variables.
- We are using the following tables from the ISORA data.
    - 14 Derived indicators revenue (D5, population and labor force).
    - 12 Stakeholder interactions return (A88).
    - 15 Derived indicators staff (D10, D14).
- To load the ISORA data, we have pre-processed the table format in the excel sheets.

### Content of replication package
This package contains a README file, the do-files required for replication, the final figures, and the raw, intermediate and final datasets used to produce the figures.

### Software and hardware used
This replication package can be run with stats.camp. The replication package was run on a computer 12th Gen Intel(R) Core(TM) i7-1280P, 1.80 GHz, 32 GB of RAM, 1.86GB of storage. The entire package took less than 5 minutes to run.

### Steps needed for replication
Please run the code in the following order
1. 01_build_data.do
2. 02_figures.do

To execute the codes, set the path for 'global replication_package' in both scripts to the 'replication_package' folder. The remaining globals for specific folders follow the above structure. Please use "/" rather than "\" to ensure the code runs on all operating systems.

### Mapping from programs to output
All of the figures in the paper are produced in the 02_figures.do do-file.

### Remarks on figures
While the replication package was being reviewed, it came to our attention that Figure 1c, as reproduced using the package, may differ very slightly from the figure in the main text. Specifically, the figure produced using the replication package has two additional data points located with a value between -0.5 and 0 in the x axis and values slightly above 30 in the y axis. There are no differences to the pattern in the figure, including the fitted line and its 95% confidence interval.
