---
layout: post
title: Managed extensibility framework and visual studio 2010 editor classifiers
---

##Few things first

Few things to keep in mind when starting this. Visual Studio 2010 uses the Managed Extensibility Framework to handle it's extensions. Some of the important attributes you'll need to remember/keep an eye on in order to make sure it works properly is the ExportAttribute.

    [Export(typeof(IClassifierProvider))]
    internal class EditorClassifier1Provider : IClassifierProvider {
        ....
    }


The parameter in the export specifies what type of contract it is. In this particular case it will be an IClassifierProvider. If no type is provided the type will be determined by looking at the class/method type. This will tell Visual Studio that we have an IClassifierProvider class that we want it to know about and load.

The ImportAttribute is the opposite. This will tell Visual Studio what we need set by it in order to work. 

    [Import]
    internal IClassificationTypeRegistryService ClassificationRegistry = null; // Set via MEF

Here we need the collection that contains all the classification types registered with Visual Studio.

##Starting

Create a new project and use the EditorClassifier provided by the Visual Studio SDK. First, create a ContentTypeDefinition for our new editor. I'm going to use the Razor extension as an example.

    [Export]
    [Name("razor")]
    [DisplayName("Razor")]
    [BaseDefinition("html")]
    public static ContentTypeDefinition RazorContentType = null;

    [Export]
    [ContentType("code")]
    [FileExtension(".cshtml")]
    public static FileExtensionToContentTypeDefinition cshtmlFileExtension = null;

I chose the BaseDefinition of my classification as <em>html</em> to tell Visual Studio to base my new content type on the existing html type. This will give us all the highlighting necessary for html - thank goodness for that! 

I've modified the default created classes below to get across what needs to be changed.

    [Export(typeof(IClassifierProvider))]
    [ContentType("text")]
    internal class EditorClassifier1Provider : IClassifierProvider {
        [Import(typeof(IClassificationTypeRegistryService))]
        internal IClassificationTypeRegistryService ClassificationRegistry = null; // Set via MEF

        public IClassifier GetClassifier(ITextBuffer buffer) {
            return buffer.Properties.GetOrCreateSingletonProperty<EditorClassifier1>(delegate { return new EditorClassifier1(buffer, ClassificationRegistry); });
        }
    }

    class EditorClassifier1 : IClassifier {
        IClassificationTypeRegistryService classificationRegistry;
        ITextBuffer buffer;

        public RazorClassifier(ITextBuffer buffer, IClassificationTypeRegistryService classificationRegistry) {
            this.classificationRegistry = classificationRegistry;
            this.buffer = buffer;

            this.buffer.Changed += BufferChanged;
        }

        void BufferChanged(object sender, TextContentChangedEventArgs e) {
            foreach (var change in e.Changes) {
            SnapshotSpan paragraph = new SnapshotSpan(e.After, change.NewSpan);

            var temp = this.ClassificationChanged;
            if (temp != null)
                temp(this, new ClassificationChangedEventArgs(paragraph));
            }
        }


        public IList<ClassificationSpan> GetClassificationSpans(SnapshotSpan span) {
            ...
        }

        #pragma warning disable 67
        public event EventHandler<ClassificationChangedEventArgs> ClassificationChanged;
        #pragma warning restore 67
    }


Modify the constructor for EditorClassfier1 and add an ITextBuffer and an IClassificationTypeRegistryService parameter. This will give us access to the list of classification types and raw access to the cshtml file. We also want to monitor for changes to the buffer so that we can update our syntax highlighting.

    public IList<ClassificationSpan> GetClassificationSpans(SnapshotSpan span) {
        IList<ClassificationSpan> spans = new List<ClassificationSpan>();

        foreach (var token in new RazorParser().Parse(buffer)) {
            IClassificationType type = GetClassificationTypeRazorToken(token.TokenType);

            int start = token.Span.Start;
            int end = token.Span.Length;

            spans.Add(
                new ClassificationSpan(
                   new SnapshotSpan(
                       new SnapshotPoint(span.Snapshot, start), end
                   ), type
                )
            );
        }

        return spans;
    }


    IClassificationType GetClassificationTypeRazorToken(TokenType tokenType) {
        string classificationType;
        if (!tokenToClassificationType.TryGetValue(tokenType, out classificationType))
            throw new ArgumentException("Invalid TokenType: " + tokenType.ToString(), "tokenType");

        return classificationRegistry.GetClassificationType(classificationType);
    }

    static Dictionary<TokenType, string> tokenToClassificationType = new Dictionary<TokenType, string>() {
        { TokenType.CodeBlock, "razor.codeblock" },
        { TokenType.CodeStart, "razor.codestart" },
        { TokenType.CSharpKeyword, "razor.keyword" },
        { TokenType.CSharpString, "razor.string" },
        { TokenType.CSharpObject, "razor.object" },
        { TokenType.CSharpComment, "razor.comment" }
    };

This method will call our <a href='http://buildstarted.com/2010/09/07/razor-parser-engine-for-the-razor-syntax-highlighter/'>Parser</a> and loop through the returned tokens. Then, based on those tokens, it will get the ClassificationTypes and create the highlight spans for Visual Studio. Here's an example classification type. We're exporting an EditorFormatDefinition with a name so <em>GetClassificationTypeRazorToken</em> method above knows which one to use. I've created a dictionary to map the tokens to the classication name. After we've gotten our proper name for the classification type we then return the ClassificationRegistry entry based on that type. The classificationRegistry is populated from Visual Studio and is filled with our export below. Each highlight type requires it's own classification type entry

    [Export(typeof(EditorFormatDefinition))]
    [ClassificationType(ClassificationTypeNames = "razor.codestart")]
    [Name("razor.codestart")]
    sealed class RazorCodeStart : ClassificationFormatDefinition {
        public RazorCodeStart() {
            this.IsBold = true;
            this.BackgroundColor = Color.FromArgb(255, 205, 205, 205);
            this.ForegroundColor = Color.FromArgb(255, 255, 255, 45);

        }
    }


That's pretty much it. The bulk of the code is in the actual parsing. 

This is by no means complete but should give someone the basics to do this themselves. Any clarification issues comment and I'll reply. <em>feel free to be confused...</em> :)

###- Ben