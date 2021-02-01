#### GISC 422 T1 2021
# _R Markdown_
One further element of the _R_ and _RStudio_ ecosystem that we will touch on briefly this week, and will see more of through the semester is _R Markdown_.

_R Markdown_ files are a format that allow you to run code inside a document, and to combine the results of running that code into an output file in formats like HTML (for web pages) or Word documents and PDFs (for more conventional documents).

_R Markdown_ is an example of *literate computing* which is a more general move towards media that merge traditional documentation with interactive computing elements.

What does that mean?

Well a couple of things, but first we need to re-open this document in _RStudio_:

+ In _RStudio_ go to **File - Open File...** and navigate to the folder where you unpacked the lab `.zip` file
+ Open this file `r-markdown.md` (that's this file as it happens)
+ Now do **File - Save As...** and save the file but change the extension from `.md` to `.Rmd`

## Now what?
OK. Are you ready for this?!

This document is a combination of *markdown formatted text* (like this) which allows creation of simple structured documents with different heading levels and simple formatting such as *italics*, **bold** and `code` fonts. We can also include (and this is the clever part) *code chunks*. These begin and end with three backticks and an indication of what kind of code is included, in them. Here's a very simple example:

```{r}
x <- 5
y <- 6
x + y
```

What's special about these code chunks is that you can *run* them using the little 'play' arrow at the top right of the chunk, and when you do, you see the result. Try it now.

In effect, you are running an *R* session in pieces, inside a document that explains itself as it goes along.

# The really clever bit
That's pretty smart.

But the really clever part comes when you *knit* the document together into an output format. You do this in *RStudio* using the **Knit** button, which you'll see at the top of this panel in the interface. Click on the little down arrow and select **Knit to HTML**. [You may be asked to install some things: go ahead and say yes!]

*RStudio* should think for a bit, and will produce a HTML file that appears in the **Viewer** (at the bottom of the RStudio interface). You can also knit to a Word document (try it!). It likely won't work in Windows, but you can also knit to PDF format.

The document that is produced includes all the linking text, nicely formatted, and also the code chunks *and their outputs* nicely formatted. All that means that you can use this to produce a formatted report explaining a data analysis and how you produced it.

The first part of this week's assignment (this document) explains all this, before moving on to the statistical model building part. If you are feeling ambitious you are can produce your submission using Rmarkdown (although this is *not* required). Either way, the fact that the materials are presented this way, will save you a lot of typing. Just don't forget to *actually read the materials presented* so that you understand what's going on!

## Some notes on markdown formatting
Markdown is now a widely used format for document preparation. Details are available [here](https://daringfireball.net/projects/markdown/syntax). This section provides an outline so you can understand how the materials for this lab have been prepared, and also write your own Rmarkdown file if you wish.

### Document headings
Document header levels are denoted by hash signs (there are other ways to do this, but I like hash signs). One hash for level 1, two for level 2 and so on, like this:

# Level 1
## Level 2
### Level 3
#### and so on...

Plain text is just plain text. *Italics* are designated by single asterisks and **bold** by double asterisks. Code format text is designated by `backticks` (this obscure key is at the top-left of your keyboard).

And, crucially, code chunks appear, as you've seen above between **```{r}** and **```** markers. You can also have code blocks that don't run by leaving out the `{r}`. You won't need to make any Rmarkdown files for this lab, but this should be enough information so you can understand what is going on.

# **WARNING**
## Run everything in order!
One problem with this kind of file is that there is a temptation to jump ahead and run code chunks out of sequence. Usually this will cause bad things to happen, because variables end up containing information they are not expected to contain, or don't contain information they are expected to contain.

So... it pays to work through the document chunk by chunk, in sequence, reading the accompanying information so you understand what is happening. If things go haywire, it often pays to go back a few chunks and re-run them, in order. Avoid the temptation to jump around at random in documents!

OK on to the final [wrap up](wrapping-up.md)
