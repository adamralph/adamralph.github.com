---
layout: post
title: Razor without mvc part iv parser error messages
---

I'm sensing a theme here...

Continuing the progress of the Razor Compiler being written by <a href='http://www.fidelitydesign.net/'>Matthew Abbot</a> and myself. I offer the next update....wait for it....

##Parser error messages!

<em>(not that you didn't already see it in the title)</em>

By default, the <strong>RazorCodeGenerator</strong> seems to suppress error messages. It's up to us to capture them by overriding the VisitError method. In order to do that I've had to override the RazorCodeGenerator class. (Which resulted in the overriding of several other classes)

    public class CSharpRazorCodeGenerator : RazorCodeGenerator {
        public CSharpRazorCodeGenerator(string className, 
                             string rootNamespaceName, 
                             string sourceFileName, 
                             RazorEngineHost host)
            : base(className, rootNamespaceName, sourceFileName, host) {

        }

        protected override CodeWriter CreateCodeWriter() {
            return new CSharpCodeWriter();
        }

        public override void VisitError(RazorError err) {
            throw new RazorParserException(err);
        }
    }


All of the above is the minimum needed. The key here is the override for VisitError which we then throw our ParserException.

The next step was to override <strong>RazorCodeLanguage</strong> to return our new <strong>RazorCodeGenerator</strong> from above.

    public class CSharpRazorCodeGeneratorLanguage : RazorCodeLanugage {

        public override Type CodeDomProviderType {
            get {
                return typeof(CSharpCodeProvider); ;
            }
        }

        public override ParserBase CreateCodeParser() {
            return new CSharpCodeParser();
        }

        public override string LanguageName {
            get {
                return "csharp";
            }
        }

        public override RazorCodeGenerator CreateCodeGenerator(string className,
                                string rootNamespaceName, 
                                string sourceFileName, 
                                RazorEngineHost host) {
            return new CSharpRazorCodeGenerator(className, 
                                            rootNamespaceName, 
                                            sourceFileName, host);
        }

    }


The only thing in this override we really needed to do was override <strong>CreateCodeGenerator</strong> to return our new <strong>CSharpRazorCodeGenerator</strong>. The rest were just required overrides and I use the default returns for those.

Since the Razor Compiler also includes the VB language the same classes above were created using VB types instead of c#.

Now we have more information to better explain to the user what's going on if there's a template error but doesn't cause a compiler error.

###- Ben