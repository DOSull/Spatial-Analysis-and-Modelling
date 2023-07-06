#### GISC 422 T2 2023
# Wrapping up
The aim of this session had been to get a feel for things. Don't panic if you don't completely understand everything that is happening. The important thing is to realize
+ You make things happen by typing commands in the console
+ Commands either cause things to happen (like plots) or they create new variables (data with a name attached), which we can further manipulate using other commands. Variables and the data they contain remain in memory (you can see them in the **Environment** tab) and can be manipulated as required.
+ *RStudio* remembers everything you have typed (check the **History** tab if you don't believe this!)
+ All the plots you make are also remembered (mess around with the back and forward arrows in the plot display).

The **History** tab is particularly useful. If you want to run a command again, find it in the list, select it and then select the **To Console** option (at the top). The command will appear in the console at the current prompt, where you can edit it to make any desired changes and hit `<RETURN>` to run it again. You can also get the same history functionality using the up arrow key in the console, which will bring previous commands back to the console line for you to reuse. But this gets kind of annoying once you have run many commands.

Another way to rerun things you have done earlier is to save them to a script. The easiest way to do this is to go to the history, select any commands you want, and then select **To Source**. This will add the commands to a new file in the upper left panel, and then you can save them to a `.R` script file to run all at once. For example, in the history, find the command used to open the data file, then the one used to attach the data, then one that makes a complicated plot. Add each one in turn to the source file (in the proper order). Then from the scripts area, select **File – Save As...** and save the file to some name (say `test.R`). What you have done is to write a short program! To run it go to **Code – Source File...** navigate to the file, and click **OK**. All the commands in the file should then run in one go.

## Do try to get through all the steps in these instructions
I suggest making time to work through all of the instructions in this session. It's a lot all at once if you haven't used *R* before, and it won't all make sense right away, but getting comfortable with the tools will be important, and will set you up well for the semester ahead.

## Additional resources
*R* is really a programming language as much as it is a piece of software, there is a lot more to learn about it than is covered here, or will be covered in this course. If you want to know more about *R* as a general statistics environment there is a [good online guide here](https://cran.r-project.org/doc/contrib/Verzani-SimpleR.pdf) which is worth looking at if you want a more detailed introduction.

For the purposes of this course, the commands you really need to get a handle on are explored in the corresponding weekly labs.
