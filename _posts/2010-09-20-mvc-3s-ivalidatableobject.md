---
layout: post
title: Mvc 3s ivalidatableobject
---

I've come across a couple ways to do validation in MVC. My favorite is the IValidatableObject method. It's fairly simple to setup.

    public class User : IValidatableObject {
        public string Name { get; set; }

        public string Email { get; set; }
        public string Password { get; set; }
        public string VerifyPassword { get; set; }

        public IEnumerable<ValidationResult> Validate(ValidationContext validationContext) {
            if ((!string.IsNullOrWhiteSpace(Password) || !string.IsNullOrWhiteSpace(VerifyPassword)) 
            && Password != VerifyPassword)
                yield return new ValidationResult("Passwords must match", new string[] { "Password" });
        }
    }


This particular method is only called after all other validations have passed. If you have any DataAnnotations attributes such as [Required] or [StringLength] on your properties that fail then your Validate implementation will not be called.

The order of operations for the IValidatableObject to get called:

1. Property attributes
2. Class attributes
3. Validate interface

If any of the steps fail it will return immediately and not continue processing.

One of the things I don't like with this particular method is that it puts validation in the model. I currently use the MetadataType attribute on all my models and put all DataAnnotations attributes in there. You can't implement IValidatableObject on your MetadataType, which is a shame. (Though I could be wrong but testing shows otherwise)

###- Ben