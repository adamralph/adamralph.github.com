---
layout: post
title: Metadatatypeattribute with dataannotations and unit testing
---

Ok, this has been causing me to pull my hair out. Consider the following setup and unit test.

    //Metadata class
    public class Signup {
        [Required]
        [EmailAddress(ErrorMessage="Email address appears to be invalid")]
        public string Email { get; set; }
    }

    //class to validate
    [MetadataType(typeof(Metadata.Signup))]
    public partial class Signup {
        public string Email { get; set; }
    }

    public void SignupModelTestValidationSucceedsWithValidEmailAddress() {
        var signup = new Signup();
        signup.Email = "test@test.com";

        var context = new ValidationContext(signup, null, null);
        var results = new List<ValidationResult>();

        var validated = Validator.TryValidateObject(signup, context, results, true);

        Assert.IsFalse(validated);
    }


This should work just fine and seems to do in code but not in the unit test. If I move the DataAnnotations (of which EmailAddress isn't one of them) to the class itself then it works just fine. So there seems to be a disconnect between MVC and the Test Project. It turns out that MVC wires up all the necessary mappings and what not for the DataAnnotations validations to work. To test the model validator I had to provide the Metadata from DataAnnotations to the TypeDescriptor for that type.

    TypeDescriptor.AddProviderTransparent(
        new AssociatedMetadataTypeTypeDescriptionProvider(
                typeof(Signup),
                typeof(Metadata.Signup)),
            typeof(Signup));

The above tells the TypeDescriptor that we have a MetadataAttribute and registers it using the DataAnnotations AssociatedMetadataTypeTypeDescriptionProvider.

The final test method looks like this:

    public void SignupModelTestValidationSucceedsWithValidEmailAddress() {
        TypeDescriptor.AddProviderTransparent(
            new AssociatedMetadataTypeTypeDescriptionProvider(
                    typeof(Signup),
                    typeof(Metadata.Signup)),
                typeof(Signup));

        var signup = new Signup();
        signup.Email = "test@test.com";

        var context = new ValidationContext(signup, null, null);
        var results = new List<ValidationResult>();

        var validated = Validator.TryValidateObject(signup, context, results, true);

        Assert.IsFalse(validated);
    }


I hope this saves someone some grief out there.

###- Ben