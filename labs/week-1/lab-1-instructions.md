# GISC 422 Lab 1: introducing R
## Introduction
This lab will introduce you to the statistical analysis and programming environment *R*, running in *RStudio* (which makes it a bit easier to deal with). *R* has become one of the standard tools for statistical analysis particularly in the academic research community, but [increasingly also in commercial and other work settings](https://statfr.blogspot.com/2018/08/r-generation-story-of-statistical.html). It is well suited to this environment for a number of reasons, particularly

1. it is free [as in beer];
2. it is easily extensible; and
3. because of 1 and 2, many new methods of analysis first become available in *packages* contributed to the *R* ecosystem by researchers in the field.

The last point is why we are using *R* for spatial analysis as part of this course.

Like any good software, versions of R are available for Mac OSX, Windows and Linux so you can install a copy on your own computer and work on this lab in your own time---you don’t need to be at the timetabled lab sections to complete the assignment, although you will find it helpful to attend to get assistance from the course instructors, and also from one another. To get up and running on your own computer, you will need to download and install *R* itself, from [here](http://cran.r-project.org/) and also, optionally, (**but highly recommended**) install *RStudio* from [here](http://www.rstudio.com/products/rstudio/download/).

Installation is pretty straightforward on all platforms. When you are running *R* you will want a web-connection to install any additional packages called for in lab instructions below. You will also find it useful to have a reasonably high resolution display (an old 1024 $\times$ 768 display will not be a lot of fun to work on, but high pixel density modern displays, such as 4K, can be a bit painful also, without tweaking the display settings). For this reason alone, you may find it good to work on the lab machines.

### DON’T PANIC!
This lab introduces *R* by just asking you to get on with it, without stopping to explain too much, at least not at first. This is because it’s probably better, to just do things with *R* to get a feel for what it’s about without thinking too hard about what is going on; kind of like learning to swim by jumping in at the deep end. You may sometimes feel like you are drowning. Try not to worry too much and stick with it, and bear in mind that the assignments will not assume you are some kind of *R* guru (I'm no R guru, I know enough to be dangerous, but am only just competent). Ask questions, confer with your fellow students, consult Google (this [cartoon](https://xkcd.com/627/) is good advice).

## Getting started with R
We’re using *R* inside a slightly friendlier ‘front-end’ called RStudio, so start that program up in whatever platform you are running on. You should see the display below (without all the text which is from an open session on my machine). I have labeled four major areas of the interface, these are:
Console this is where you type commands and interact directly with the program
Scripts and other files is where you can write ‘scripts’ which are short programs consisting of a series of commands that can all be run one after another. This is more useful as you become proficient with the environment, but if you have previous programming experience you may find it useful. You will also get tabular views of open datasets in this panel. Note that this window may not appear, particularly at initial startup, in which case the console will extend the whole height of the window on the left.
Environment / History here you can examine the data currently in your session (‘environment’) more closely, or if you switch to the history tab, see all the commands you have issued in the session.
Various outputs are displayed in this area – mostly these will be plots, but perhaps also help information about commands.
Before going any further, it makes sense to do some clearing out, since the lab machines are shared computers, there may be data sitting around from the previous session. Use the ‘broom’ buttons in the Environment and Output panes to clear these out. Clear the console of previous commands by clicking in the console and selecting Edit – Clear Console and then click the ‘x’ buttons on any open files or datasets in the upper left pane.
Now you have cleaned house, we are ready to go.
        The command line…
The key thing to understand about R is that it is a command-line driven tool. That means you issue typed commands to tell R to do things (this was a normal way to interact with a computer and get work done before the early 1990s, and is making a comeback, like vinyl, but even geekier). There are some menus and dialog boxes in R-Studio to help you manage things, but mostly you interact with R by typing commands at the > prompt in the console window. To begin, we’ll load up a dataset, just so you can see how things work and to help you get comfortable. As with most computer-related stuff, you should experiment: you will learn a lot more that way.
First, open up a data file. Go to the Environment tab (upper-right panel) and click on Import Dataset. Select the From CSV... option and navigate to the earthquakes.csv file provided (download it from https://github.com/DOSull/gisc-422/labs/week-1/earthquakes.csv. In the window that appears navigate to the file provided. You will get a preview of the data that is to be imported. You have some options at this point. One that is worth setting is the Name of the variable that these data will be imported to. Since you may be typing it a lot, you might want to set a shorter name than the default choice, such as ‘quakes’. Then click Import to open it. A references to the dataset should appear in the Environment pane, and also a table view of it in the upper left pane.
These are data concerning earthquakes recorded in the months after the 7.1 earthquake in Christchurch in September 2010 (see this website for more http://www.christchurchquakemap.co.nz/).
When you click Import you will see lines appear in the console, something like
> View(earthquakes)
> library(readr)
> quakes <- read_csv("path_to/earthquakes.csv")
Parsed with column specification:
cols(
CUSP_ID = col_integer(),
NZMGE = col_integer(),
NZMGN = col_integer(),

[There will be more than this snippet.]
You should see also see a data table appear in the upper left panel. The data appear very similar to a spreadsheet. In R, data tables are known as dataframes and each column is an attribute or variable. The various variables that appear in the table are
CUSP_ID a unique identifier for each earthquake or aftershock event
NZMGE and NZMGN are New Zealand Map Grid Easting and Northing coordinates
ELAPSED_DAYS is the number of days after September 3, 2010, when the big earthquake was recorded
MAG is the earthquake or aftershock magnitude
DEPTH is the estimate depth at which the earthquake or aftershock occurred
YEAR, MONTH, DAY, HOUR, MINUTE, SECOND provide detailed time information
Now, if we want to use R to do some statistics, these data are stored in a variable named quakes (in my example, you may have called it something different). I can refer to columns in the dataframe by calling them quakes$MAG (note the $ sign). So for example, if I want to know the mean magnitude of the aftershocks in this dataset I type
> mean(quakes$MAG)
or the mean northing coordinate
> mean(quakes$NZMGN)
and R will return the value in response. Probably more informative is a boxplot or histogram, try:
> boxplot(quakes$MAG)
or
> hist(quakes$MAG)
and you should see statistical plots as shown at right.
It gets tedious typing quakes all the time, so you can attach the dataframe so that the variable names are directly accessible without the quakes$ prefix by typing
> attach(quakes)
and then
> hist(MAG)
will plot the specified variable. Be careful using attach as it may lead to ambiguity about what you are plotting if you are working with different datasets that include variables with the same names.
Try the above commands just to get a feel for things.
You can make a simple map of all the data by plotting the NZMGE variable as the x (i.e. horizontal axis) and NZMGN as the y axis of a scatterplot:
> plot(NZMGE, NZMGN)
Because R is not a GIS it doesn’t automatically know about things like projections, so this is a very crude map. For example, if you resize the plot window it independently rescales the east-west and north-south directions, which is not helpful for a map. To prevent it doing this we can specify an option to the plot command requiring the aspect-ratio to be fixed at 1:
> plot(NZMGE, NZMGN, asp=1)
There are R packages to handle geographical data better than this (we will see more of those in the next lab) but for now don’t worry about it too much. To see if there is a relationship between earthquake depth and magnitude, try this:
> plot(DEPTH, MAG)
and because R is a statistics package, we can easily fit and plot a simple regression model to the data:
> regmodel <- lm(MAG ~ DEPTH)
> abline(regmodel, col='red')
Note here the use of <- to assign the model, made by the ‘linear model’ lm() command to a new variable, called regmodel. You can get more details of this model by typing regmodel or summary(regmodel). If you know anything about regression models, these may be of interest to you. Also note how, I’ve requested that the line be plotted in red (col=’red’), so it can be seen more easily.
We can make more complex displays. For example
> plot(ELAPSED_DAYS, MAG)
Shows how the magnitude of the aftershocks changed in the days after the initial large earthquake, with a second large event happening around 6 months (180 days) later [this was the more dangerous event as it happened during the working day, while the original event was on a Sunday afternoon.] A more complicated plot still would be
> boxplot(MAG ~ cut(ELAPSED_DAYS, seq(0,200,20)))
Give that a try and see what you get. To label the chart more informatively we need to add information for x and y axis labels
> boxplot(MAG ~ cut(ELAPSED_DAYS, seq(0,200,20)), xlab="Days after Sept 3, 2010", ylab="Magnitude")
The aim here is just to get a feel for things. Don’t panic if you don’t completely understand what is happening. The important thing is to realize:
• You make things happen by typing commands in the console
• Commands either cause things to happen (like plots) or they create new variables (data with a name attached), which we can further manipulate using other commands. Variables and the data they contain remain in memory (you can see them in the ‘Environment’ tab) and can be manipulated as required.
• R-Studio remembers everything you have typed (check the History tab if you don’t believe this!)
• All the plots you make are also remembered (mess around with the back and forward arrows in the plot display).
The History tab is particularly useful. If you want to run a command again, find it in the list, select it and then select the ‘To Console’ option (at the top). The command will appear in the console at the current prompt, where you can edit it to make any desired changes and hit <RETURN> to run it again. You can also get the same history functionality using the up arrow key in the console, which will bring previous commands back to the console line for you to reuse. But this gets kind of annoying once you have run many commands.
Another way to rerun things you have done earlier is to save them to a script. The easiest way to do this is to go to the history, select any commands you want, and then select ‘To Source’. This will add the commands to a new file in the upper left panel, and then you can save them to a .R script file to run all at once. For example, in the history, find the command used to open the data file, then the one used to attach the data, then one that makes a complicated plot. Add each one in turn to the source file (in the proper order). Then from the scripts area, select File – Save As… and save the file to some name (say test.R). What you have done is to write a short program! To run it go to Code – Source File… navigate to the file, and click OK. All the commands in the file should then run in one go.
Since R is really a programming language as much as it is a piece of software, there is a lot that we could look at than cannot easily be covered in a couple of labs. If you want to know more about R as a general statistics environment there is a good online guide at
https://cran.r-project.org/doc/contrib/Verzani-SimpleR.pdf
which is worth looking at if you want a more detailed introduction. For the purposes of this lab, the commands you really need to get a handle on are explored in the next section.
    Point processes in R: the spatstat package
The major strength of R is the wide range of packages that have been developed for performing specialized statistical analysis (like spatial analysis). For point patterns, the go-to package is spatstat. To use spatstat you must first install it. If someone else has already worked on this lab on the computer you are on, you may not need to do this. You can try loading spatstat either by typing
> library(spatstat)
at the console prompt, or by checking under the packages tab (lower right panel) to see if it is in the list of installed packages. If it is, you simply click the checkbox. If it is not listed, then go to the Tools – Install Packages… menu and in the dialog that appears type ‘spatstat’ making sure to select the ‘Install dependencies’ option. Then click Install. It will take a little while, but R should issue the necessary commands in the console window, download what it needs and install all the necessary components.
Once spatstat is installed, you can load it with the library() command mentioned above
So what is spatstat? A short introduction is available via the R help system. Type
> help.start()
and navigate to package spatstat and open the ‘User guides, package vignettes and other documentation’ link, then select the ‘Getting Started’ document, which provides a quick overview. An introduction is available at http://www.stats.uwo.ca/faculty/kulperger/S9934a/Papers/SpatStatIntro.pdf. For our purposes, what you really need to know is that spatstat is the most powerful tool around for doing point pattern analysis.
Consequently you can use spatstat to generate a wide variety of point patterns using a range of point processes. Among these are the following R commands
rpoint() – generates a specified number of random uniform distributed points
rpoispp() – generates random points distributed according to some specified intensity pattern (which may be uniform)
rThomas() – generates clustered points via a ‘parent-child’ process
rSSI() – generates points that exclude one another from being with some specified distance of each other
and many others. You can see the full list in the general help page for the package in the subsection entitled To simulate a random point pattern.
The package also provides a number of sample datasets to experiment with. To get started we will load one of these. Type
> data(redwoodfull)
This creates a new point pattern dataset called redwoodfull. Information about the source of these data is available from the help
> ?redwoodfull
You can see what it looks like with
> plot(redwoodfull)
You can also find out more about the point pattern with
> summary(redwoodfull)
which will tell you the number of points (events) in the pattern, and also the ‘window’ or study area which is applied. For these data it is a rather artificial unit square from coordinates (0, 0) to (1, 1). To plot the density of the points you can do
> plot(density(redwoodfull))
and then
> plot(redwoodfull, add=T)
to add the points on top (add=T sets the add ‘flag’ to ‘True’ telling R to add what you asked to be plotted to an already existing plot). The colors are not ideal (see below for better colors). Also (we’ll look at this in more detail in lectures) the density uses a particular distance range to perform the calculation – think of this as a smoothing factor. We can specify a different range for the density calculation, by setting an option ‘lambda’ that controls the smoothing distance, when we run the density command:
> plot(density(redwoodfull, sigma=0.05))
If you run the density plot with default settings then with ‘sigma’ set to 0.05 and then set to 0.2 you will see the difference it makes. You can store the density surface created each time as a new variable
> d05 <- density(redwoodfull, sigma=0.05)
> d1 <- density(redwoodfull, sigma=0.1)
> d2 <- density(redwoodfull, sigma=0.2)
which might save time if you want to come back and compare different density maps later. You can look at older plots easily with the ‘back’ button in the plot tab. Another option is to setup the plot display to receive more than one plot. You do this by setting plot parameters with
> par(mfrow=c(1, 3))
The numbers in parentheses are the number of ‘rows’ then ‘columns’ you want, so in this case there will be 1 row and 3 columns. Now, if you do
> plot(d05)
> plot(redwoodfull, add=T)
> plot(d1)
> plot(redwoodfull, add=T)
> plot(d2)
> plot(redwoodfull, add=T)
you will see all three density plots in one display. [You need to set things back to normal if you want just a single plot, using par(mfrow=c(1, 1)).
Better colors
The density map colors are not ideal. There is a package for generating better color ramps. It is called RColorBrewer (the capitalization is important) and you can install it and set it going in the same way you did with spatstat. Once it is running, then you can do this to make better colors:
> plot(density(redwoodfull), col=brewer.pal(9, "Reds"))
Consult the help on this (?brewer.pal) to find out more about the color options you can use with this package. Color ramps in a range of colors are available, simply by changing the name “Reds” part of the above code.
    Making point patterns
The point (ahem) of this lab is to make some point patterns using spatstat’s commands, to examine them, and to comment on them. To support this aim, you might find it useful to plot densities, with the points superimposed on top, as in the previous section. To make the point patterns use the commands mentioned above and further explained below. You will also need to experiment to get the patterns to illustrate what you want to say.
Anyway, here is a quick go through of the main point processes available.
The Independent Random Process (aka Complete Spatial Randomness)
There are options here. rpoint() or rpoispp() will each produce point patterns of this type, where there is no bias in where point events occur (no first order effects) and no interactions between events (no second order effects). For example
> plot(rpoint(100))
will produce a pattern with 100 events of the required kind. You are guaranteed to get the requested number of events.
> plot(rpoispp(100))
will produce a similar pattern, but in this case the pattern intensity will be 100, and it is not guaranteed that there will actually be 100 events. Sometimes you might get 94 events, or 107, or whatever – close to 100, but not exactly 100. This is a Poisson point process, with uniform intensity. It’s different from the other process because you can actually specify a variable intensity field, which will give different effects (discussed in the next section).
It is worth noting that if you want to include density maps in your plots, you will need to save the patterns you make as variables, like this:
> pp1 <- rpoint(100)
> plot(density(pp1))
> plot(pp1, add=T)
This is worth doing so you can experiment with what plots work best to illustrate your answers.
        First order effects: an inhomogenous Poisson process
To introduce first order effects, we change the intensity of a Poisson point process from a fixed value to one that varies across the space as the x and y coordinates vary. Doing this is a little tricky because there are an infinite number of ways for the intensity to vary across the space, and so we must specify exactly what we want. This requires us to write a simple R function, which also demonstrates a bit more of how R works. You need to make a function that will return a different result, based on x and y coordinate values supplied to it. Here is an example:
> myslope <- function(x, y) { return( 100 * x + 100 * y ) }
The punctuation is important (the right kinds of brackets and the placement of the comma and so on, so type carefully or copy and paste from this document). This creates a new R function or command, which I’ve called myslope. This function expects to be supplied with x and y values, and will return a value given by the equation, which in this case will be 100 times x plus 100 times y. If you try
> myslope(10, 10)
and experiment with some other values, you should see how it is working. You should also try rewriting the equation so that your ‘slope’ function is different than this one. For example, think about how to make an intensity function that is highest in the middle of the unit square, or which is highest in the corners.
Now, if when you run a Poisson point process you provide a function to the rpoispp() command in place of a fixed intensity, it will generate a realization of the Poisson point process where the intensity of the events generated is controlled by the function, and is no longer a fixed value. This means the intensity will vary from the bottom left (x, y coordinates 0, 0) to the top right (x, y coordinates 1, 1). Give it a try:
> pp_myslope <- rpoispp(myslope)
> plot(density(pp_myslope))
> plot(pp_myslope, add=T)
You should get a picture similar to the one shown. It won’t be identical because your realization of the process will be a different unique one from mine, but the bottom-left to top-right increase in intensity of the pattern should be apparent. This is an example of an inhomogeneous Poisson point process.
        Patterns with second order interactions
I am not going to explain these in detail. The two examples for you to consider are the Thomas process and the Sequential Spatial Inhibition process (SSI). The respective R commands are rThomas() and rSSI(). You should take a look at the help
> ?rThomas
> ?rSSI
The gist of it is:
• The Thomas process takes three parameters. The first specifies the intensity of a Poisson process that generates ‘parent’ events, the second specifies a distance that ‘child’ events will be scattered away from their parents, and the third specifies the average number of children that each parent will produce.
• SSI has two parameters. The first is an inhibition distance within which new events are not placed closer to existing events, and the second is the number of events that the process will attempt to randomly place given the inhibition constraint.
Here are some example plots:

There are other processes available in spatstat and there is no reason not to use these in preparing your answer to this assignment, or at least experiment with them a little. You will find more details in the package help.

OK… on to the assignment!
    Assignment deliverables
You need to do just two things:
FIRST make three or four plots to show patterns with (i) no first and second order effects, (ii) clear first order effects, and (iii) clear second order effects. Make sure that your plots show the details of the process you used, or take care to include this information in captions for your plots.
NOTE: to get plots out of R-Studio, use the Export – Save Plot As Image… option (save it as a .png file) in the plot window, or Copy Plot To Clipboard… option. You can then insert the image file into a Word document, either as an image file, or by pasting from the clipboard.
SECOND make two plots where a point process generates a pattern that seems atypical for the process. Of course, if you are able to make such a plot, then it would suggest the pattern is not atypical of the process! What I mean is this: make plots of patterns that you know to have first or second order effects in operation, but where how those effects act produces patterns that don’t obviously exhibit those effects. For example, see if you can make the Thomas process produce patterns that don’t appear clustered, or if you can get realizations of a simple random process that appear to include clusters, or a trend. Again, document what the processes are in your plots, and also explain why you think the examples you present are instances of such ‘contradictory’ or atypical patterns.
Prepare a short report that fulfills the above requirements. Your report should include 5 or 6 images of patterns (they might be organized using the mfrow option into a smaller number of actual images) and just a few lines of explanation. As I noted at the start, this lab is primarily intended to give you a basic level of comfort using R, spatstat and R-Studio, before we do more complicated analysis using these tools in Lab 3.
Make sure your name is on your answer document, and upload it using the bCourses submission box for this course. The submission deadline is February 20 at 11:59PM.


David O’Sullivan
January 30, 2017
