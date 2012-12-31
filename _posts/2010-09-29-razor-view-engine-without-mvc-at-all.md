---
layout: post
title: Razor view engine without mvc at all
---

Update: <a href='http://buildstarted.com/2010/11/02/razor-without-mvc-part-ii/'>Razor without MVC part II</a> contains anonymous types

Please visit: <a href='http://www.fidelitydesign.net/?p=208'>Here</a> to find a great rewrite of this article with a very well written project that includes a VB compiler!

In my <a href='http://buildstarted.com/2010/09/28/mvc-3-razor-view-engine-without-a-controller/'>previous post</a> I discuss using the Razor View Engine to create views from string templates using a simple call.

    string Template = "Hello, @Model.Name";
    Models.User user = new Models.User() { Name = "Billy Boy" };
    RazorViewEngineRender view = new RazorViewEngineRender(Template);
    string Results = view.Render(user); //pass in your model


Not happy with relying on so much MVC I've decided to redo this and use only what is necessary to produce results.

##BaseWriter

First I needed to find out the basic requirements for using Razor. I found that Razor Code Generator creates a class with a single method called <strong>Execute</strong> that overrides some base class. Other methods that are called are <strong>WriteLiteral</strong> and <strong>Write</strong>. So i created a BaseWriter class that contains these methods

    public class BaseWriter {
        StringBuilder sb;

        public BaseWriter() {
            sb = new StringBuilder();
        }

        public string Output {
            get {
                return this.sb.ToString();
            }
        }

        public void WriteLiteral(string literal) {
            sb.Append(literal);
        }

        public void Write(object obj) {
            sb.Append(obj);
        }

        public virtual void Execute() { }
    }


Internally I just write to a StringBuilder, just simpler for now.

##Model support

Next I needed to add model support to the BaseWriter class. Simple enough to use generics.

    public class BaseWriter<T> : BaseWriter {
        T Model;

        public void SetModel(T Model) {
            this.Model = Model;
        }
    }


##The compiler

Next I needed to take the template and convert it to an assembly. Thanks goes to <a href='http://blog.andrewnurse.net/CommentView,guid,6acc0b07-0db5-4353-b375-fbe60a209bb1.aspx'>Andrew Nurse</a> for his base example. We pass in the object we're going to use as the model for statements like @Model.Name We then alter our baseClass to add the model generic if it's not null. The rest of the code is just a basic dynamic code compiler and it returns a <strong>CompilerResult</strong>.

    private CompilerResults Compile(object Model) {
        string baseClass = "Razor.Compiler.BaseWriter" + (Model == null ? "" : "&lt;" + Model.GetType().FullName + "&gt;");

        CodeLanguageService languageService = CodeLanguageService.GetServiceByExtension(".cshtml");
        System.CodeDom.Compiler.CodeDomProvider provider = new CSharpCodeProvider();
        InlinePageParser parser = new InlinePageParser(languageService.CreateCodeParser(), new HtmlMarkupParser());
        Microsoft.WebPages.Compilation.CodeGenerator codeGenerator = languageService.CreateCodeGeneratorParserListener(ClassName, "RazorBlade.Dynamic", "object", ClassName + ".cs", baseClass);

        using (StreamReader reader = new StreamReader(new System.IO.MemoryStream(System.Text.ASCIIEncoding.ASCII.GetBytes(Template)))) {
            parser.Parse(reader, codeGenerator);
        }

        codeGenerator.GeneratedCode.Namespaces[0].Types[0].Members.RemoveAt(0);
        codeGenerator.GeneratedCode.Namespaces[0].Imports.Clear();

        System.Text.StringBuilder sb = new StringBuilder();
        using (StringWriter writer = new StringWriter(sb)) {
            provider.GenerateCodeFromCompileUnit(codeGenerator.GeneratedCode, writer, new System.CodeDom.Compiler.CodeGeneratorOptions());
        }

        CompilerParameters @params = new CompilerParameters();
        foreach (var assembly in AppDomain.CurrentDomain.GetAssemblies()) {
            @params.ReferencedAssemblies.Add(assembly.Location);
        }

        @params.GenerateInMemory = true;
        @params.IncludeDebugInformation = false;
        @params.GenerateExecutable = false;
        @params.CompilerOptions = "/target:library /optimize";

        return new CSharpCodeProvider().CompileAssemblyFromSource(@params, new string[] { sb.ToString() });
    }


##The generated code

Here's a sample of the generated code. It's very basic and only includes the method Execute(); The template for this particular set of code

    string Template = "Hello @Model";

    namespace RazorBlade.Dynamic {
        public class bcbcebecbcff : Razor.Compiler.BaseWriter {

            public override void Execute() {
                this.WriteLiteral("Hello ");
                this.WriteLiteral(Model);
            }

        }
    }


##Execute

This method calls the compiler and based on the result throwing an exception on any errors. We then create an instance of our newly generated class. If we've passed in a model let's call our SetModel method and then we execute and grab the output.

    public string Execute(object Model) {
        CompilerResults results = Compile(Model);

        if (results.Errors.HasErrors) {
            string console = "";
            foreach (CompilerError error in results.Errors) { console += error.ErrorText + "\r\n"; }

            throw new Exception(console);
        }

        object reference = results.CompiledAssembly.CreateInstance("RazorBlade.Dynamic." + ClassName);
        if (Model != null)
            reference.GetType().InvokeMember("SetModel",
                System.Reflection.BindingFlags.Public |
                System.Reflection.BindingFlags.InvokeMethod |
                System.Reflection.BindingFlags.FlattenHierarchy |
                System.Reflection.BindingFlags.Instance |
                System.Reflection.BindingFlags.IgnoreCase, null, reference, new object[] { Model });

        reference.GetType().InvokeMember("Execute",
            System.Reflection.BindingFlags.Public |
            System.Reflection.BindingFlags.InvokeMethod |
            System.Reflection.BindingFlags.FlattenHierarchy |
            System.Reflection.BindingFlags.Instance |
            System.Reflection.BindingFlags.IgnoreCase, null, reference, null);

        var value = reference.GetType().InvokeMember("Output",
            System.Reflection.BindingFlags.Public |
            System.Reflection.BindingFlags.FlattenHierarchy |
            System.Reflection.BindingFlags.GetProperty |
            System.Reflection.BindingFlags.Instance |
            System.Reflection.BindingFlags.IgnoreCase, null, reference, null);

        this.Output = value.ToString();

        return this.Output;
    }


##Final code call

    string Template = "Hello @Model";

    Razor.Compiler.RazorBlade blade = new Razor.Compiler.RazorBlade(Template);
    var results = blade.Execute("World");


This is very simple and produces good results with more complex templates. It doesn't support any of the @parameters such as @inherits or @using. However I don't think it's really necessary.

##Conclusion

The only additional reference this project requires is <strong>Microsoft.WebPages.Compilation.dll</strong>
This is a fairly simple class for what I initially thought would be much more complicated. The razor parser is really well done. 

You probably shouldn't use this code anywhere as I haven't gone though and looked for any obvious errors or glaring code issues or memory-leaks. 

I hope someone takes this code to the next level.

##Update

By request I've created a really quick sample project. You can download it <a href='http://buildstarted.com/wp-content/uploads/2010/09/Razor.Compiler.zip'>here</a>.

###- Ben