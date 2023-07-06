#### GISC 422 T2 2023
# GISC 422 Spatial Analysis and Modelling
This class introduces key concepts and methods of spatial analysis. Practical deployment in the *R* statistical analysis software package is emphasised, although other tools will be surveyed.

<!--## COVID Alert level changes
If COVID alert levels change, the class will continue as follows:
+ **Level 1** Class as normal. Attendance in person preferred, streamed content will be available at the link posted on Blackboard. **Stay home if you are unwell**.
+ **Level 2** Room entry must be recorded using COVID app and/or the sign-in sheet. Sanitise hands on entry and exit from the lab. Wipe down your workstation (keyboard, mouse) with wipes provided at start and end of session. And, since the sessions are 3 hours long, wear a mask. As at other levels class will be streamed and recorded for those unwilling or unable to attend. Above all **stay home if you are unwell**.
+ **Level 3** or **Level 4** Class will be conducted solely over zoom with recordings available later for review.
-->

## Link to related video content
A consolidated list of relevant video content for this class is available on [this page](video-links.md).

## Important dates

Item | Dates
 -: | :-
Trimester | 10 July to 9 November 2023
Teaching period | 10 July to 13 October 2023
Mid-trimester break | 21 August to 1 September 2023
Last assessment item due (in this class) | TBA
Study period | NA
Examination period | NA
Withdrawal dates | See [Course additions and withdrawals](www.victoria.ac.nz/home/admisenrol/payments/withdrawalsrefunds)

If you cannot complete an assignment or sit a test or examination, refer to [Aegrotats](www.victoria.ac.nz/home/study/exams-and-assessments/aegrotat)

## Lecture and lab schedule
TBA

<!--Lectures are in Cotton 110 at 9AM on Mondays and will be followed immediately by related lab sessions in the same location. The combined session will last up to three hours, finishing before noon.-->

## Contact details
### Lecturer/coordinator
**Prof. [David O'Sullivan](mailto:david.osullivan@vuw.ac.nz)**
**Office** CO227 **Extn.** 6492 **Office hours preferably by appointment** [click here](http://calendly.com/dosullivan) but direct message me on [the Slack](https://vuwgisc2021.slack.com) and we can arrange contact. The office phone system is not a good way to reach me.

### GIS Technician
NA
<!--**[Andrew Rae](mailto:andrew.rae@vuw.ac.nz)**
**Office** CO502 **Office hours** 1-3PM Mondays
-->

## Lab and lecture timetable
Here's the trimester schedule we will aim to follow. **Bolded labs** have an associated assignment that must be submitted and contributes the indicated percentage of the course credit. General instructions for the labs are [here](labs/README.md).  Relevant materials (lecture slides, lab scripts and datasets) are linked below, when available.

Week# | Date | Lecture | Lab | Notes | [Videos](video-links.md)
:-: | :-: | :-- | :-- | :-- | :--
1 | 10 Jul | Course overview | [*R* and *RStudio* computing environment and Markdown documents](labs/intro-to-R-and-friends/README.md) | | [Practical](video-links.md#introducing-r-and-friends)
2 | 17 Jul | [Why &lsquo;spatial is special&rsquo;](https://southosullivan.com/gisc422/spatial-is-special/) | [Making maps in *R*](labs/making-maps-in-r/README.md) | | [Lecture](video-links.md#lecture-on-spatial-is-special)<br />[Practical](video-links.md#practical-materials-on-making-maps-in-r)
3 | 24 Jul | [Spatial processes](https://southosullivan.com/gisc422/spatial-processes/) | [Introducing `spatstat`](labs/introducing-spatstat/README.md) | | [Lecture](video-links.md#lecture-on-the-idea-of-a-spatial-process)<br />[Practical](video-links.md#practical-materials-on-spatial-processes)
4 | 31 Jul | [Point pattern analysis](https://southosullivan.com/gisc422/point-pattern-analysis/) | [**Point pattern analysis**](labs/point-pattern-analysis/README.md) (15%) | Due 4 Sep | [Lecture](video-links.md#lecture-on-point-pattern-analysis)<br />[Practical](video-links.md#overview-of-lab-on-point-pattern-analysis)
5 | 7 Aug | [Measuring spatial autocorrelation](https://southosullivan.com/gisc422/spatial-autocorrelation/) | [**Moran's *I***](labs/spatial-autocorrelation/README.md) (15%) | Due 11 Sep | [Lecture](video-links.md#lecture-on-spatial-autocorrelation)<br />[Practical](video-links.md#overview-of-lab-on-spatial-autocorrelation)
6 | 14 Aug | [Spatial interpolation](https://southosullivan.com/gisc422/interpolation/) | ['Simple' interpolation in R](labs/interpolation/README.md) | | [Lecture](video-links.md#lecture-on-simple-interpolation-methods)
| | **SEMESTER BREAK** | **NO TEACHING**
7 | 4 Sep | [Geostatistics](https://southosullivan.com/gisc422/geostatistics/) | [**Interpolation**](labs/interpolation/README.md) (15%) | Due 25 Sep | [Lecture](video-links.md#lecture-on-geostatistical-methods)
8 | 11 Sep | Multivariate methods | [**Geodemographics**](labs/multivariate-analysis/README.md) (15%)| Due 9 Oct | [Lecture](video-links.md#week-9-multivariate-analysis)
9 | 18 Sep | Overlay, regression models and related methods | [Lab content](labs/statistical-models/README.md) |
10 | 25 Sep | [Cluster detection](https://southosullivan.com/gisc422/cluster-detection/) | TBD |
11 | 2 Oct | [Network analysis](https://southosullivan.com/gisc422/network-analysis/) | [Tools for network analysis](labs/network-analysis/README.md)
12 | 9 Oct | TBD | TBD

## Lectures
NA

### Readings
The most useful materials are

+ Bivand R, Pebesma E and Gómez-Rubilio V. 2013. [*Applied Spatial Data Analysis with R*](https://link-springer-com.helicon.vuw.ac.nz/book/10.1007%2F978-1-4614-7618-4) 2nd edn. Springer, New York.
+ O'Sullivan D and D Unwin. 2010. [*Geographic Information Analysis*](http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470288574.html) 2nd edn. Wiley, Hoboken, NJ.

The first of these is freely available as a full PDF download from the library, so where possible I will emphasise materials in that book. 

I wrote the second book and will provide pre-publication manuscript chapters where needed.

A third book:

  + Brunsdon C and L Comber. 2019. [*An Introduction to R for Spatial Analysis and Mapping*](https://au.sagepub.com/en-gb/oce/an-introduction-to-r-for-spatial-analysis-and-mapping/book258267 "Brunsdon and Comber Introduction to R book") 2nd edn. Sage, London.

is more recent and is reasonably affordable, so you might consider purchasing it as a general reference and reminder of topics covered in the class.

There are also many useful online resources that cover topics that are the subject of this class. For example:

+ [*Geocomputation with R*](https://geocompr.robinlovelace.net/) by Lovelace, Novosad and Muenchow, 2019
+ [*Spatial Data Science*](https://r-spatial.org/book/) a book in preparation from Bivand and Pebesma
+ [Course materials for Geographic Data Science](http://darribas.org/gds15/) by Daniel Arribas-Bel at University of Liverpool
+ [*Geospatial Analysis*](https://www.spatialanalysisonline.com/HTML/index.html) by deSmith, Longley and Goodchild

For the final assignment you will need to do your own research and assemble materials concerning how spatial analysis has been applied in specific areas of study.

## Labs
NA
<!--Lab sessions follow the lecture sessions and will cover related practical topics. Lab materials will generally be found [here](labs/). Only four sessions have an associated assessed assignment, but you should attend all labs and particpate fully to broaden your knowledge of GIScience methods and tools as any of the approaches covered may prove useful for you in other parts of the program. (Note also that a portion of the course credit is for participation in all aspects of the course.)-->

### Software
Most of the lab work will be completed in the [*R*](https://www.r-project.org/) programming language for statistical computing, using various packages tailored to spatial analysis work. *R*

We will use *R* from the [*RStudio*](https://www.rstudio.com/) environment which makes managing work more straightforward.

Both *R* and *RStudio* are freely downloadable for use on your own computer (they work on all three major platforms). I can take a look if you are having issues with your installation, but are likely to suggest that you uninstall and reinstall. <!--In some cases problems might arise from different versions of key packages, in which case you will have to work with the lab machine versions as we can't support multiple versions across different platforms.-->

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

Assessments to be submitted by email. I will aim to return coursework within 3 weeks. <!--Extensions should be requested from the SGEES administration office. If you anticipate problems come and talk to me.-->

<!--### Late submission penalties
All assignments must be handed in by their due dates. Non-submission  by the required date will result in a 5% penalty off your grade for that assignment for each day or part thereof that the coursework is late.  No submissions will be accepted more than 5 days after the due date.

Computer crash or similar excuses are not acceptable. Save your material and make sure you have something to submit by the due date.

### Non-assessed lab work
Note that there are also non-assessed lab sessions. These will be important for your ability to complete the final assignment effectively and to your all-around training in GIScience, so it is vital that you take them seriously as part of the course.

## Additional information
The primary mode of communication for the course will be via Blackboard, so please ensure that your contact details there are up to date and are regularly checked (note that Blackboard defaults to your myvuw email address).

### Class representatives
A volunteer is need to act as class representative. If you are interested let me know. Further information about the role is available [here](https://www.vuwsa.org.nz/class-representatives/).

### Other useful resources
+ [Academic Integrity and Plagiarism](https://www.wgtn.ac.nz/home/study/plagiarism)
+ [Aegrotats](https://www.wgtn.ac.nz/home/study/exams-and-assessments/aegrotat)
+ [Academic Progress](https://www.wgtn.ac.nz/home/study/academic-progress) (including restrictions and non-engagement)
+ [Dates and deadlines](https://www.wgtn.ac.nz/home/study/dates)
+ [Grades](https://www.wgtn.ac.nz/home/study/exams-and-assessments/grades)
+ [Resolving academic issues](https://www.wgtn.ac.nz/home/about/avcacademic/publications2#grievances)
+ [Special passes](https://www.wgtn.ac.nz/home/about/avcacademic/publications2#specialpass)
+ [Statutes and policies including the Student Conduct Statute](https://www.wgtn.ac.nz/home/about/policy)
+ [Student support](https://www.wgtn.ac.nz/home/viclife/studentservice)
+ [Students with disabilities](https://www.wgtn.ac.nz/st_services/disability)
+ [Student Charter](https://www.wgtn.ac.nz/learning-teaching/partnership/student-charter)
+ [Student Contract](https://www.wgtn.ac.nz/home/admisenrol/enrol/studentcontract)
+ [Turnitin](http://www.cad.vuw.ac.nz/wiki/Turnitin.html)
+ [VUWSA](https://www.vuwsa.org.nz)
-->