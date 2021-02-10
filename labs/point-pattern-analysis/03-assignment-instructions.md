#### GISC 422 T1 2021
# **The assignment: A point pattern analysis of the Auckland TB data**
Now you have a point pattern dataset to work with (`tb.pp`), you can perform point pattern analysis with it. You may need to [go back to the previous set of instructions](02-ppa-with-real-data.md) to get to this point.

## Assignment deliverables

The submission deadline is **19 April at 8:30AM**. A dropbox will be provided on Blackboard. Preferably do the analysis in an R Markdown file and output things to a PDF (you probably will have to go via Word to accomplish this)

You can assemble materials in a word processor (export images from *RStudio* to PNG format) and produce a PDF report as an alternative, but I recommend the R Markdown approach.

Avoid showing lots of irrelevant output with options like `message = FALSE` in the code chunk headers.

Include your name in the submitted filename for ease of identification. You should not need to write more than about 500 words, although your report should include a number of figures. Note that quality of cartography is not an important aspect of this assignment.

You need to do three things:

### First (25%)

Present kernel density surfaces of the tuberculosis data.

**You should present three different density surfaces, and explain which are likely to be the most useful in different contexts.**

Explain what bandwidths you have selected, and the basis for your choice. (Remember that the distance units are km.) Keep in mind that there is no absolute right answer, and that the various suggestions you can get from functions available (see the section about kernel density) are only suggestions. You might want to make selections close to these but rounded to more readily understood values, for example.

You will need to present maps of the density surfaces.

### Second (50%)

Conduct a point pattern analysis of the data and report the results.

You may use whatever methods from those available (quadrats, mean nearest neighbors, *G*, *F*, Ripley's *K*, the pair correlation function) that you find useful, and that you feel comfortable explaining and interpreting. You should use at least one of the simulation envelope based methods.

You will need to present graphs or other output on which your analysis is based.

### Third (25%)

Comment on what the principle drivers of the tuberculosis incidents might be. Consider how you might run point pattern analysis to take account of such factors. What might a better null model for the occurrence of incidents be in this case than the default of complete spatial randomness?

[**back to overview**](00-overview.md)
