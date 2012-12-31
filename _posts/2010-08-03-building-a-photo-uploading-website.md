---
layout: post
title: Building a photo uploading website
---

##Starting it off

First, we're going to create an empty MVC (Razor) project. (I'm going to be using <a href='http://weblogs.asp.net/scottgu/archive/2010/07/02/introducing-razor.aspx'>razor</a> for my samples here.)

Well, let's start with the data requirements. At the basic level, for now, we'll just need a list of Photos. Rather than start with designing a DataContext we're going to use the new <a href='http://blogs.msdn.com/b/adonet/archive/2010/07/14/ctp4announcement.aspx'>Entity Frameworks</a> for a "code first" approach.

    public Photo {
        public int PhotoId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Filename { get; set; }
        public DateTime DateUploaded { get; set; }
        public byte[] Data { get; set; }
    }
	
Next, we'll need to create a DataContext.

    public class DataContext : System.Data.Entity.DbContext {
        public DbSet<Photo> Photos { get; set; }
    }

	
We inherit from *DbContext* which you'll get by adding a reference to "<em>System.Data.Entity.CTP</em>".

###Sample usage:
    DataContext db = new DataContext();
    var photos = from p in db.Photos where p.PhotoId < 10;


###Adding some photos:
We just need to create a few photos and add them to our db.Photos object
    //Adding a list of photos
    DataContext db = new DataContext();
    var Photos = new List<Models.Photo> {
        new Models.Photo {
            Title = "Photo 1",
            DateUploaded = DateTime.Now,
            Filename = "photo1.png",
            Description = "Description for photo 1"
        },
        new Models.Photo {
            Title = "Photo 2",
            DateUploaded = DateTime.Now,
            Filename = "photo2.png",
            Description = "Description for photo 2"
        },
    };
    Photos.ForEach(p => db.Photos.Add(p));
    db.SaveChanges();

Here we just create a single photo and add it to our db.Photos object

    //adding a single photo
    Photo photo = new Photo() {
            Title = "New Photo",
            DateUploaded = DateTime.Now,
            Filename = "newphoto.png",
            Description = "Description of the new photo"
    };
    db.Photos.Add(photo);
    db.SaveChanges();

###Grabbing a photo and updating it

Here we can take a single photo modify it's title and save the changes to the Entity Framework db.

    DataContext db = new DataContext();
    Photo photo = db.Photos.Single(p => p.PhotoId == 1);
    photo.Title = "Photo 1's new title";
    db.SaveChanges();
	
So here we have a basic Photo Model that we're going to use to bind our Views with. In addition we have an Entity Framework database with which we can do our testing all without creating a database.

In my next post we'll look at integrating this with the Controller &amp; View

###- Ben