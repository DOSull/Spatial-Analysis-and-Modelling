# GISC 422 Spatial Analysis and Modelling
This class introduces key concepts and methods of spatial analysis. Practical deployment in the `R` statistical analysis software package is emphasised, although other tools will be surveyed.

## Important dates
Item | Dates
 -: | :-
Trimester | 4 March to 29 June 2019
Teaching period | 4 March to 7 June 2019
Mid-trimester break | 15 April to 29 April 2019
Last assessment item due | 14 June 2019
Study period | NA
Examination period | NA
Withdrawal dates | See [Course additions and withdrawals](www.victoria.ac.nz/home/admisenrol/payments/withdrawalsrefunds)

If you cannot complete an assignment or sit a test or examination, refer to [Aegrotats](www.victoria.ac.nz/home/study/exams-and-assessments/aegrotat)

## Lecture and lab schedule
Lectures are in Cotton 110 at 10AM on Mondays and will be followed immediately by related lab sessions in the same location. The combined session will last two hours, finishing up before noon.

## Contact details
### Lecturer/coordinator
**Prof. [David O'Sullivan](mailto:david.osullivan@vuw.ac.nz)**
**Office** CO227 **Extn.** 6492 **Office hours by appointment** [click here](http://calendly.com/dosullivan)

### GIS Technician
**[Andrew Rae](mailto:andrew.rae@vuw.ac.nz)**
**Office** CO502 **Office hours** TBD

## Lab and lecture timetable
Here's the trimester schedule we will aim to follow. **Bolded labs** have an associated assignment that must be submitted and contributes the indicated percentage of the course credit.  Relevant materials (lecture slides, lab scripts and datasets) are linked below, when available.

Week# | Date | Lecture | Lab | Notes
 :-: | :-: | :-- | :-- | :--
 1 | 4 Mar | Course overview | [*R* and *RStudio* computing environment](labs/week-1/introducing-r-and-rstudio.md) |
2 | 11 Mar | [Why &lsquo;spatial is special&rsquo;](https://southosullivan.com/gisc422/spatial-is-special/) | [Making maps in *R*](labs/week-2/making-maps-in-r.md) |
3 | 18 Mar | [Spatial processes](https://southosullivan.com/gisc422/spatial-processes/) | [Introducing `spatstat`](labs/week-3/introducing-spatstat.md) |
4 | 25 Mar | [Point pattern analysis](https://southosullivan.com/gisc422/point-pattern-analysis/) | [**Point pattern analysis**](labs/week-4/assignment-1-ppa-in-spatstat.md) (10%) | Due 8 Apr
5 | 1 Apr | [Cluster detection](https://southosullivan.com/gisc422/cluster-detection/) | Survey of other tools |
6 | 8 Apr | [Measuring spatial autocorrelation](https://southosullivan.com/gisc422/spatial-autocorrelation/) | [**Moran's *I***](labs/week-6/assignment-2-spatial-autocorrelation.md) (10%) | Due 29 Apr
&nbsp; | Break | &nbsp; | &nbsp; | &nbsp;
7 | 29 Apr | [Spatial interpolation](https://southosullivan.com/gisc422/interpolation/) | ['Simple' interpolation in R](labs/week-7/interpolation.md) |
8 | 6 May | [Geostatistics](https://southosullivan.com/gisc422/geostatistics/) | [**Interpolation**](labs/week-8/geostatistics.md) (10%) | Due 20 May
9 | 13 May | Recap | [Exploratory spatial data analysis (ESDA)](labs/week-9/esda.md) |
10 | 20 May | Multivariate methods | [**Geodemographics**](labs/week-10/multivariate-analysis.md) (10%)| Due 4 Jun
11 | 27 May | [Network analysis](https://southosullivan.com/gisc422/network-analysis/) | [Tools for network analysis](labs/week-11/network-analysis.md) |
12 | 3 Jun | **No class** Queen's Birthday | &nbsp; |

## Lectures
Lectures will generally consist of around an hour of presented material, and around 30 minutes of more open-ended discussion and Q&A based on the materials and on reading which students will have been expected to do ahead of class.

### Readings
Details of any required readings will be provided ahead of class and where possible either publicly available, or linked from [Blackboard](https://blackboard.vuw.ac.nz/). Most readings will be from one or the other of

+ Bivand R, Pebesma E and Gómez-Rubilio V. 2013. [*Applied Spatial Data Analysis with R*](https://link-springer-com.helicon.vuw.ac.nz/book/10.1007%2F978-1-4614-7618-4) 2nd edn. Springer, New York.
+ O'Sullivan D and D Unwin. 2010. [*Geographic Information Analysis*](http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470288574.html) 2nd edn. Wiley, Hoboken, NJ.

The first of these is freely available as a full PDF download from the library, so where possible I will emphasise materials in that book. I wrote the second book and will provide pre-publication manuscript chapters where needed.

A third book:

+ Brunsdon C and L Comber. 2018. [*An Introduction to R for Spatial Analysis and Mapping*](https://au.sagepub.com/en-gb/oce/an-introduction-to-r-for-spatial-analysis-and-mapping/book241031) 2nd edn. Sage, London.

is more recent and is reasonably affordable, so you might consider purchasing it as a general reference and reminder of topics covered in the class.

There are also many useful online resources that cover topics that are the subject of this class. For example:

+ [*Spatial Data Science*](https://keen-swartz-3146c4.netlify.com/intro.html) a book in preparation from Bivand and Pebesma
+ [Course materials for Geographic Data Science](http://darribas.org/gds15/) by Daniel Arribas-Bel at University of Liverpool
+ [*Geospatial Analysis*](https://www.spatialanalysisonline.com/HTML/index.html) by deSmith, Longley and Goodchild

For the final assignment you will need to do your own research and assemble materials concerning how spatial analysis has been applied in specific areas of study.

## Labs
Lab sessions follow the lecture sessions and will cover related practical topics. Lab materials will generally be found [here](labs/). Only four sessions have an associated assessed assignment, but you should attend all labs and particpate fully to broaden your knowledge of GIScience methods and tools as any of the approaches covered may prove useful for you in other parts of the program. (Note also that a portion of the course credit is for participation in all aspects of the course.)

### Software
Most of the lab work will be completed in the [*R*](https://www.r-project.org/) programming language for statistical computing, using various packages tailored to spatial analysis work. *R*

We will use *R* from the [*RStudio*](https://www.rstudio.com/) environment which makes managing work more straightforward.

Both *R* and *RStudio* are available on the lab computers. Both are freely downloadable for use on your own computer (they work on all three major platforms). We can take a look if you are having issues with your installation, but are likely to suggest that you uninstall and reinstall. In some cases problems might arise from different versions of key packages, in which case you will have to work with the lab machine versions as we can't support multiple versions across different platforms.

## Course learning objectives (CLOs)
1. Articulate the theoretical and practical considerations in the application of spatial analysis methods and spatial modelling
2. Prepare, manipulate, analyse, and display spatial data
3. Apply existing tools to derive meaningful spatial models
4. Identify and perform appropriate spatial analysis

## Assessment
This course is 100% internally assessed.  Assessment is based on four lab assignments worth 12.5% of overall course credit each, and a final assignment worth 50% of course credit due in the exam period.

Assessment item | Credit | Due date | CLOs
:- | :-: | :-: | :-:
Spatial autocorrelation | 10% | 1 April | 2 3 4
Point pattern analysis | 10% | 29 April | 2 3 4
Spatial interpolation | 10% | 13 May | 2 3 4
Geodemographic analysis | 10% | 4 June | 2 3 4
Written report on application of spatial analysis in a particular topic area | 50% | 18 June | 1
Participation (including non-assessed labs) | 10% | NA | 1 2 3 4

Some guidance on the written report assignment expectations is provided [here](report/README.md).

Assessments are submitted electronically via dropbox on [Blackboard](https://blackboard.vuw.ac.nz/). I will aim to return coursework within 3 weeks. Extensions should be requested from the SGEES administration office. If you anticipate problems come and talk to me.

### Late submission penalties
All assignments must be handed in by their due dates. Non-submission  by the required date will result in a 5% penalty  off your grade for that assignment for each day or part thereof that the coursework is late.  No submissions will be accepted more than 5 days after the due date.

Computer crash or similar excuses are not acceptable. Save your material and make sure you have something to submit by the due date.

### Non-assessed lab work
Note that there are also non-assessed lab sessions. These will be important for your ability to complete the final assignment effectively and to your all-around training in GIScience, so it is vital that you take them seriously as part of the course.

## Additional information
The primary mode of communication for the course will be via Blackboard, so please ensure that your contact details there are up to date and are regularly checked (note that Blackboard defaults to your myvuw email address).

### Class representatives
Since this is a relatively small graduate class, I expect that it will not be a problem to raise any issues or concerns directly with me, or with the GIS technician.

### Other useful resources
+ [Academic Integrity and Plagiarism](http://www.victoria.ac.nz/home/study/plagiarism)
+ [Aegrotats](http:\\www.victoria.ac.nz/home/study/exams-and-assessments/aegrotat)
+ [Academic Progress](http:\\www.victoria.ac.nz/home/study/academic-progress) (including restrictions and non-engagement)
+ [Dates and deadlines](http:\\www.victoria.ac.nz/home/study/dates)
+ [Grades](http:\\www.victoria.ac.nz/home/study/exams-and-assessments/grades)
+ [Resolving academic issues](http:\\www.victoria.ac.nz/home/about/avcacademic/publications2#grievances)
+ [Special passes](http:\\www.victoria.ac.nz/home/about/avcacademic/publications2#specialpass)
+ [Statutes and policies including the Student Conduct Statute](http:\\www.victoria.ac.nz/home/about/policy)
+ [Student support](http:\\www.victoria.ac.nz/home/viclife/studentservice)
+ [Students with disabilities](http:\\www.victoria.ac.nz/st_services/disability)
+ [Student Charter](http:\\www.victoria.ac.nz/home/viclife/student-charter)
+ [Student Contract](http:\\www.victoria.ac.nz/home/admisenrol/enrol/studentcontract)
+ [Turnitin](http:\\www.cad.vuw.ac.nz/wiki/index.php/Turnitin)
+ [University structure](http:\\www.victoria.ac.nz/home/about)
+ [VUWSA](http:\\www.vuwsa.org.nz)
