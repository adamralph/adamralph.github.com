---
layout: post
title: Metadatatypes and why theyre useful
---

##MetadataType

You have a linq dbml file created and you wish to add some attributes to the properties. However, if you update your dbml file for any reason all your changes will disappear.

You'll have 3 separate classes after you're done with one Linq object

###Linq Object

    public partial class YourLinqObject {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int Age { get; set; }
    }


###Your attribute class holder

    [MetadataType(typeof(YourLinqObjectMetadata))]
    public partial class YourLinqObject {

    }


###Your metadata class

    public class YourLinqObjectMetadata {
        [MaximumLength(50)]
        public string FirstName { get; set; }
    
        [MaximumLength(50)]
        public string LastName { get; set; }
    
        [Range(13, 100)]
        public int Age { get; set; }
    }


Whenever you update your dbml it won't affect your partial class and you'll keep your attributes. It does cause a bit of code duplication, however with relation to the properties but it's effective none-the-less.

###- Ben