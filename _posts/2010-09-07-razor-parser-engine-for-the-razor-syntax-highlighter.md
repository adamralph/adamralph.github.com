---
layout: post
title: Razor parser engine for the razor syntax highlighter
---

Here's my Razor Parser class that I use in my <a href='/razor-syntax-highlighter'>Razor Syntax Highlighter</a>. I'm going to post later about how I integrate this into Visual Studio using the <a href='http://www.microsoft.com/downloads/details.aspx?FamilyID=47305cf4-2bea-43c0-91cd-1b853602dcc5&displaylang=en' target='&#95;new'>Visual Studio SDK</a>.

    public IList<Token> Parse(ITextBuffer buffer) {
        List<Token> tokens = new List<Token>();
        CodeLanguageService languageService = CodeLanguageService.GetServiceByExtension(".cshtml");

        InlinePageParser parser = new InlinePageParser(languageService.CreateCodeParser(), new HtmlMarkupParser());

        consumer = new RazorParserConsumer();
        consumer.OnSpanStart += delegate(object s, ParsedSpanEventArgs span) {
            switch (span.span.Type) {
                case SpanType.Code:
                    tokens.AddRange(RazorCSharpCodeParser.Parse(span.span.Start.AbsoluteIndex, span.span.Content).ToArray());

                    if (span.span.Content.Trim().Length != 0) {
                        tokens.Add(new Token(TokenType.CodeBlock, new Span(span.span.Start.AbsoluteIndex, span.span.Length)));
                    }
                    break;
                case SpanType.MetaCode:
                case SpanType.Transition:
                    tokens.Add(new Token(TokenType.CodeStart, new Span(span.span.Start.AbsoluteIndex, span.span.Length)));
                    break;

                case SpanType.Markup:
                    break;
            }
        };

        MemoryStream ms = new MemoryStream(System.Text.ASCIIEncoding.ASCII.GetBytes(buffer.CurrentSnapshot.GetText()));
        using (System.IO.StreamReader reader = new System.IO.StreamReader(ms)) {
            parser.Parse(reader, consumer);
        }

        return tokens;
    }


The ITextBuffer parameter of the Parse() method is pass from Visual Studio using the EditorClassifier project. This gives us access to the text content within the editor.

There are 4 different types of blocks returned to us via the InlinePageParser: Code, Markup, MetaCode, Transitions.

##Transitions

Simply escaping from html into the code world. In the case of razor that's one of several sets of characters @, @:, @<, and &lt;text&gt;

##MetaCode

These are characters that define a block of code. These include () and {}. for example

    @{
        View.Title = "Your Title Here";
        LayoutPage = "~/Views/Shared/&amp;#95;Layout.cshtml";
    }


or

    @("The title of this page is " + View.Title)

##Code

This specifies that the block of text is actually code and not markup or a transition. I've just used basic keyword matching and a bit of magic to add syntax highlighting. It was very basic and not intended to be a full source highlighter.

##Markup

We don't care about markup here in that we're letting the Visual Studio default html classifiers here syntax highlight that.

##Token Types

We're only interested in a few token types to highlight cshtml to the point where it's basically usable.

    public enum TokenType {
        CodeBlock,
        CodeStart,
        Unknown,
        WhiteSpace,
        CSharpObject,
        CSharpKeyword,
        CSharpString,
        CSharpComment
    }


This gives us our basic Content Types.
1. CodeBlock gives us the background color for the code.
2. CodeStart is the transition colors.
3. Unknown/Whitespace are currently unused. (Whitespace was used in a previous implementation)
4. CSharp[x] is just some very basic c# color coding

This is the heart of the Razor Syntax Highlighter. It works reasonably well. I'm sure there are lots of improvements to be made regarding the c# highlighter and the highlighter's overall performance. 

In my next post I'll explain how I integrate the parser with the editor classifier though I'm sure several of you will already have figured it out and will be working on your own soon.

###-Ben