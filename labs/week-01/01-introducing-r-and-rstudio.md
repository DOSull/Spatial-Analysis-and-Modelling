#### GISC 422 T1 2019
# Introducing *R* and *RStudio*
This lab will introduce you to the statistical analysis and programming environment *R*, running in *RStudio* (which makes it a bit easier to deal with). *R* has become one of the standard tools for statistical analysis particularly in the academic research community, but [increasingly also in commercial and other work settings](https://statfr.blogspot.com/2018/08/r-generation-story-of-statistical.html). It is well suited to this environment for a number of reasons, particularly

1. it is free [as in beer];
2. it is easily extensible; and
3. because of 1 and 2, many new methods of analysis first become available in *packages* contributed to the *R* ecosystem by researchers in the field.

We are using *R* for spatial analysis as part of this course for all of these reasons.

Like any good software, versions of *R* are available for MacOS, Windows and Linux so you can install a copy on your own computer and work on this lab in your own time---you don't need to be at the timetabled lab sections to complete the assignment, although you will find it helpful to attend to get assistance from the course instructors, and also from one another. To get up and running on your own computer, you will need to download and install *R* itself, from [here](http://cran.r-project.org/) and also, optionally, (**but highly recommended**) install *RStudio* from [here](http://www.RStudio.com/products/RStudio/download/).

Installation is pretty straightforward on all platforms. When you are running *R* you will want a web connection to install any additional packages called for in lab instructions below. You will also find it useful to have a reasonably high resolution display (an old 1024&times;768 display will not be a lot of fun to work on, but high pixel density modern displays, such as 4K, can be a bit painful also, without tweaking the display settings). For this reason, if no other, you may find it good to work on the lab machines.

### *DON'T PANIC!*
This lab introduces *R* by just asking you to get on with it, without stopping to explain too much, at least not at first. This is because it's probably better, to just do things with *R* to get a feel for what it's about without thinking too hard about what is going on; kind of like learning to swim by jumping in at the deep end. You may sometimes feel like you are drowning. Try not to worry too much and stick with it, and bear in mind that the assignments will not assume you are some kind of *R* guru (I'm no R guru, I know enough to be dangerous, but am only just competent). Ask questions, confer with your fellow students, consult Google (this [cartoon](https://xkcd.com/627/) is good advice).

## Getting started with R
We're using *R* inside a slightly friendlier 'front-end' called *RStudio*, so start that program up in whatever platform you are running on. You should see something like the display below (without all the text which is from an open session on my machine).

<img src="images/rstudio.png">

I have labeled four major areas of the interface, these are
+ **Console** this is where you type commands and interact directly with the program
+ **Scripts and other files** is where you can write *scripts* which are short programs consisting of a series of commands that can all be run one after another. This is more useful as you become proficient with the environment, but if you have previous programming experience you may find it useful. You can also get tabular views of open datasets in this panel. Note that this window may not appear, particularly at initial startup, in which case the console will extend the whole height of the window on the left.
+ **Environment/History** here you can examine the data currently in your session (*environment*) more closely, or if you switch to the history tab, see all the commands you have issued in the session.
+ **Various outputs** are displayed in this area – mostly these will be plots, but perhaps also help information about commands.

Before going any further, it makes sense to do some clearing out, since the lab machines are shared computers, there may be data sitting around from the previous session. Use the 'broom' buttons in the **Environment** and **Output** panes to clear these out. Clear the console of previous commands by clicking in the console and selecting **Edit – Clear Console** and then click the X buttons on any open files or datasets in the upper left pane. Alternatively **Session - New Session** will accomplish the same thing.

Now you have cleaned house, we have to ensure that all the machines have installed a package that we will be using all semester, so on to the [next document](02-installing-packages.md).
