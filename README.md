# Spatial Analysis and Modelling
These pages outline a one semester (36 contact hours) class in spatial analysis and modelling that was last taught at Victoria University of Wellington as GISC 422 in the second half of 2023.

I am still in the process of cleaning the materials up for potential conversion into training materials. For the time being the materials are provided _gratis_ with no warrant as to their accuracy as a guide to spatial in _R_ but you may still find them useful all the same!

## Link to related video content
A consolidated list of relevant video content for this class is available on [this page](video-links.md).

## Lab and lecture timetable
Here's a 12 week schedule schedule we will aim to follow. **Bolded labs** have an associated assignment that must be submitted and contributes the indicated percentage of the course credit. General instructions for the labs are [here](labs/README.md).  Relevant materials (lecture slides, lab scripts and datasets) are linked below, when available.

Week# | Lecture | Lab | [Videos](video-links.md)
:-: | :-- | :-- | :--
1 | Course overview | [*R* and *RStudio* computing environment and Markdown documents](labs/intro-to-R-and-friends/README.md) | [Practical](video-links.md#introducing-r-and-friends)
2 | [Why &lsquo;spatial is special&rsquo;](https://southosullivan.com/gisc422/spatial-is-special/) | [Making maps in *R*](labs/making-maps-in-r/README.md) | [Lecture](video-links.md#lecture-on-spatial-is-special)<br />[Practical](video-links.md#practical-materials-on-making-maps-in-r)
3 | [Spatial processes](https://southosullivan.com/gisc422/spatial-processes/) | [Introducing `spatstat`](labs/introducing-spatstat/README.md) | [Lecture](video-links.md#lecture-on-the-idea-of-a-spatial-process)<br />[Practical](video-links.md#practical-materials-on-spatial-processes)
4 | [Point pattern analysis](https://southosullivan.com/gisc422/point-pattern-analysis/) | [**Point pattern analysis**](labs/point-pattern-analysis/README.md) (15%) | [Lecture](video-links.md#lecture-on-point-pattern-analysis)<br />[Practical](video-links.md#overview-of-lab-on-point-pattern-analysis)
5 | [Measuring spatial autocorrelation](https://southosullivan.com/gisc422/spatial-autocorrelation/) | [**Moran's *I***](labs/spatial-autocorrelation/README.md) (15%) | [Lecture](video-links.md#lecture-on-spatial-autocorrelation)<br />[Practical](video-links.md#overview-of-lab-on-spatial-autocorrelation)
6 | [Spatial interpolation](https://southosullivan.com/gisc422/interpolation/) | ['Simple' interpolation in R](labs/interpolation/README.md) | [Lecture](video-links.md#lecture-on-simple-interpolation-methods)
7 | [Geostatistics](https://southosullivan.com/gisc422/geostatistics/) | [**Interpolation**](labs/interpolation/README.md) (15%) | [Lecture](video-links.md#lecture-on-geostatistical-methods)
8 | Multivariate methods | [**Geodemographics**](labs/multivariate-analysis/README.md) (15%) | [Lecture](video-links.md#week-9-multivariate-analysis)
9 | Overlay, regression models and related methods | [Lab content](labs/statistical-models/README.md) |
10 | [Cluster detection](https://southosullivan.com/gisc422/cluster-detection/) | |
11 | [Network analysis](https://southosullivan.com/gisc422/network-analysis/) | [Tools for network analysis](labs/network-analysis/README.md)
12 | | 

### Readings
The most useful materials are

+ Bivand R, Pebesma E and Gómez-Rubilio V. 2013. [*Applied Spatial Data Analysis with R*](https://link-springer-com.helicon.vuw.ac.nz/book/10.1007%2F978-1-4614-7618-4) 2nd edn. Springer, New York.
+ O'Sullivan D and D Unwin. 2010. [*Geographic Information Analysis*](http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470288574.html) 2nd edn. Wiley, Hoboken, NJ.
+ Brunsdon C and L Comber. 2019. [*An Introduction to R for Spatial Analysis and Mapping*](https://au.sagepub.com/en-gb/oce/an-introduction-to-r-for-spatial-analysis-and-mapping/book258267 "Brunsdon and Comber Introduction to R book") 2nd edn. Sage, London.

There are also many useful online resources that cover topics that are the subject of this class. For example:

+ [*Geocomputation with R*](https://geocompr.robinlovelace.net/) by Lovelace, Novosad and Muenchow, 2019
+ [*Spatial Data Science*](https://r-spatial.org/book/) a book in preparation from Bivand and Pebesma
+ [Course materials for Geographic Data Science](http://darribas.org/gds15/) by Daniel Arribas-Bel at University of Liverpool
+ [*Geospatial Analysis*](https://www.spatialanalysisonline.com/HTML/index.html) by deSmith, Longley and Goodchild

For the final assignment you will need to do your own research and assemble materials concerning how spatial analysis has been applied in specific areas of study.

### Software
Most of the lab work will be completed in the [*R*](https://www.r-project.org/) programming language for statistical computing, using various packages tailored to spatial analysis work. *R*

We will use *R* from the [*RStudio*](https://posit.co/) environment which makes managing work more straightforward.

Both *R* and *RStudio* are freely downloadable for use on your own computer (they work on all three major platforms). I can take a look if you are having issues with your installation, but are likely to suggest that you uninstall and reinstall.

## Course learning objectives (CLOs)
1. Articulate the theoretical and practical considerations in the application of spatial analysis methods and spatial modelling
2. Prepare, manipulate, analyse, and display spatial data
3. Apply existing tools to derive meaningful spatial models
4. Identify and perform appropriate spatial analysis

## Assessment
This course is 100% internally assessed.  Assessment is based on four lab assignments worth 15% of overall course credit each, and a final assignment worth 30% of course credit which is due in the exam period.

Assessment item | Credit | Due date | CLOs
:- | :-: | :-: | :-:
Point pattern analysis | 15% | 4 September | 2 3 4
Spatial autocorrelation | 15% | 11 September | 2 3 4
Spatial interpolation | 15% | 25 September | 2 3 4
Geodemographic analysis | 15% | 9 October | 2 3 4
Written report on application of spatial analysis in a particular topic area | 30% | 20 October | 1
Participation (including non-assessed labs) | 10% | NA | 1 2 3 4

Some guidance on the written report assignment expectations is provided [here](report/README.md).
