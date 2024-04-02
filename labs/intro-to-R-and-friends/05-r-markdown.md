# _R Markdown_
One further element of the _R_ and _RStudio_ ecosystem that we will touch on briefly this week, and will see more of through the semester is _R Markdown_.

_R Markdown_ files are a format that allow you to run code inside a document, and to combine the results of running that code into an output file in formats like HTML (for web pages) or Word documents and PDFs (for more conventional documents).

_R Markdown_ is an example of *literate computing* which is a more general move towards media that merge traditional documentation with interactive computing elements.

What does that mean?

Well a couple of things, but first we need to re-open **this** document (the one you are reading now) in _RStudio_:

+ In _RStudio_ go to **File - Open File...** and navigate to the folder where you unpacked the lab `.zip` file
+ Open the file `r-markdown.md` (i.e., this file)
+ Now do **File - Save As...** and save the file but _change the extension from_ `.md` _to_ `.Rmd` (if you can't see file extensions on your computer ask about this).

## Now what?
That should mean you are now looking at a slightly different version of the file, in plain text, but with formatting marks also included.

The document is a combination of *markdown formatted text* (like this) which allows creation of simple structured documents with different heading levels and simple formatting such as *italics*, **bold** and `code` fonts. It also includes (and this is the really clever part) *code chunks*. These begin and end with three backtick symbols and an indication of what kind of code is included, in them. Here's a very simple example:

```{r}
x <- 5
y <- 6
x + y
```

You can *run* these code chunks using the little 'play' arrow at the top right of the chunk, and when you do, you see the result it outputs. Try it on the code chunk above now.

In effect, you are running an *R* session in pieces, inside a document that explains itself as it goes along.

# The really clever bit
That's pretty smart (I think it is anyway). But there's more.

## Viewing the document as formatted output
First, you can also view the document in a nicely formatted display mode. To do this find the drop-down list next to the little 'gear wheel' icon at the top of the file viewing tab. Select the **Use Visual Editor** option. After a pause, you should see the file display change to a nicely formatted output combining formatted explanatory text, and code chunks.

In this view you will also find controls to allow you to edit markdown in the same way you might write a word processed document. This is all fairly intuitive, so I'll let you figure that all out for yourself. It's helpful as you explore to switch back to the non-Visual editing mode to see how changes you make alter the markdown materials.

## Compiling the document to an output document
But the _really_ clever part comes when you *knit* the document together into an output file. You do this in *RStudio* using the **Knit** button, which you'll see at the top of the file panel in the interface. Click on the little down arrow and select **Knit to HTML**. First time you do this, you will probably be asked if you want to install some packages: go ahead and say yes!

Once you've done that **Knit to HTML** again and *RStudio* should think for a bit, and will produce a HTML file that appears in the **Viewer** panel (at the bottom right of the RStudio interface) or perhaps as a document in a new window (you control where with the **Preview in Viewer Pane** or **Preview in Window** setting). You can also knit to a Word document (try it!) if it is installed on the machine you are using. You can also knit to PDF, although this will likely won't work in Windows.

Either way, the document that is produced includes all the linking text, nicely formatted based on the markdown, and also the code chunks *and their outputs* nicely formatted.

You can use this to produce a formatted report explaining a data analysis and how you produced it.

The remainder of this document provides a (tiny!) bit more detail on this. Ideally, you should complete assignments for this class using _R Markdown_, so pay attention (but know that it will be another couple of weeks before you need to do this for real, so you have time to get used to it).

## Some notes on markdown formatting
Markdown is now a widely used format for document preparation. Details are available [here](https://daringfireball.net/projects/markdown/syntax). This section provides an outline so you can understand how the materials for this lab have been prepared, and also write your own Rmarkdown file if you wish.

### Document headings
Document header levels are denoted by hash signs (there are other ways to do this, but I like hash signs). One hash for level 1, two for level 2 and so on, like this:

# Level 1
## Level 2
### Level 3
#### and so on...

Plain text is just plain text. *Italics* are designated by single asterisks and **bold** by double asterisks. Code format text is designated by `backticks` (this obscure key is at the top-left of your keyboard).

## Code chunks
Code chunks appear, as you've seen above like this:

```{r}
# This is a code chunk
x <- 5
```

You can have code chunks that don't run (but are formatted to look like code) by leaving out the `{r}`. You can also control what output a code chunk produces with a number of option settings. For example

```{r message = FALSE}
# This code won't show any messages
```

Some of the option settings are explained in [this document](https://rmarkdown.rstudio.com/lesson-3.html).

# Running labs in _R Markdown_
It's worth noting that any lab instructions pages for this class provided as `.md` files (which most of them are) can be converted to `.Rmd` format in exactly the way described above. This means that they can be run conveniently, without much typing.

If you do this (I am OK with you doing so), there are a couple of things to keep in mind:

+ don't forget to *actually read the materials presented* so that you understand what's going on!
+ don't forget to try changing parameters in the commands so that you learn how you can do analyses differently

And perhaps most importantly: **run everything in order!**. A problem with this kind of file is that it's tempting to jump around and run code chunks out of sequence. This often causes bad things to happen. Variables end up containing information they are not expected to, or don't contain information they are expected to, or required libraries have not been loaded, and so on. So... it pays to work through the document chunk by chunk, _in order_, reading the accompanying information so you understand what is happening.

And if things go haywire, it often pays to go back a few chunks and re-run them, in order.

OK on to the final [wrap up](06-wrapping-up.md)
