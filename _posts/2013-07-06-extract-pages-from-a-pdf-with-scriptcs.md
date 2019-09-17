---
layout: post
title: Extract Pages from a PDF Using Scriptcs
location: Zurich
tags:
- scripting
---

Today I needed to extract some pages from a large PDF file. One way of doing this would be to pay for a commercial PDF app (free versions don't have this feature).

I discovered a much nicer way.

<!--excerpt-->

1. `scriptcs -install iTextSharp`
1. Save [this method](http://www.jamesewelch.com/2008/11/14/how-to-extract-pages-from-a-pdf-document/) in `ExtractPages.csx` (shown at the bottom of this post)
1. `scriptcs`
1. `#load "ExtractPages.csx"`
1. `ExtractPages(@"C:\big.pdf", @"C:\small.pdf", 1, 3);` (pages 1-3)

Job done! [scriptcs](http://scriptcs.net/) FTW.

Thanks to [David Christiansen](https://twitter.com/dchristiansen "@dchristiansen") for recommending [iTextSharp](https://nuget.org/packages/iTextSharp/) over at [JabbR](https://jabbr.net/#/rooms/general-chat).

    // ExtractPages.csx
    // from http://www.jamesewelch.com/2008/11/14/how-to-extract-pages-from-a-pdf-document/
    using iTextSharp.text;
    using iTextSharp.text.pdf;
    
    public static void ExtractPages(string inputFile, string outputFile,
        int start, int end)
    {
        // get input document
        PdfReader inputPdf = new PdfReader(inputFile);
    
        // retrieve the total number of pages
        int pageCount = inputPdf.NumberOfPages;
    
        if (end < start || end > pageCount)
        {
            end = pageCount;
        }
    
        // load the input document
        Document inputDoc =
            new Document(inputPdf.GetPageSizeWithRotation(1));
    
        // create the filestream
        using (FileStream fs = new FileStream(outputFile, FileMode.Create))
        {
            // create the output writer 
            PdfWriter outputWriter = PdfWriter.GetInstance(inputDoc, fs);
            inputDoc.Open();
            PdfContentByte cb1 = outputWriter.DirectContent;
    
            // copy pages from input to output document
            for (int i = start; i <= end; i++)
            {
                inputDoc.SetPageSize(inputPdf.GetPageSizeWithRotation(i));
                inputDoc.NewPage();
    
                PdfImportedPage page =
                    outputWriter.GetImportedPage(inputPdf, i);
                int rotation = inputPdf.GetPageRotation(i);
    
                if (rotation == 90 || rotation == 270)
                {
                    cb1.AddTemplate(page, 0, -1f, 1f, 0, 0,
                        inputPdf.GetPageSizeWithRotation(i).Height);
                }
                else
                {
                    cb1.AddTemplate(page, 1f, 0, 0, 1f, 0, 0);
                }
            }
    
            inputDoc.Close();
        }
    }
