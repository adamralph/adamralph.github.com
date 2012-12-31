---
layout: post
title: Creating a settings table that can handle almost any type of value
---

<strong>Update: <a href='http://buildstarted.com/2010/08/13/update-settings-table-with-extension-methods/'>Updated article here</a>.</strong>

Today I wanted to be able to have a table store any type of value as a way to store some settings for an application.
The table needed to be able to store basically a name/value pair.

I designed the object using a code-first approach

##Initial Idea

    public class Setting {
        [Key]
        public string Name { get; set; }
        public object Value { get; set; }
        public string Type { get; set; }
    }


Simple and to the point.

Here is a snippet from my DataContext

    public class DataContext : DbContext, IDataContext {
        public DbSet<Setting> Settings { get; set; }
    }


To access the data I would simply cast Value to whatever type I expected it to be.

    var x = (string)Settings.Single(s => s.Name == "sitename").Value;

##Problems

However, with EF and probably Linq (I didn't test that) the Value was <em>always</em> null after I called <em>SaveChanges</em>.
At first I couldn't understand why but then it hit me. There's no direct relationship between object and SQL. So I switched the Value to a byte[]. Here is my new class.

    public class Setting {
        [Key]
        public string Name { get; set; }
        public byte[] Value { get; set; }
        public string Type { get; set; }
    }


This caused a few problems with the first method since it's not possible to typecast from a byte[] to a DateTime, int, string...and so on. So I added a few helper methods to my DataContext.

##Solution

	public T Setting<T>(string Name) {
		//grab the the setting if it exists otherwise
		var value = Settings.SingleOrDefault(s => s.Name == Name);

		//return the default value for typeof(T)
		if (value == null) return default(T);

		//If they're trying to cast to a different type we should throw an error
		//They can to another type conversion after grabbing the value
		if (Type != typeof(T).FullName)
			throw new InvalidCastException(
				string.Format("Unable to cast: {0} to {1}",
					typeof(T).FullName, Type));

		//Using the BinaryFormatter, return a typecast value
		return (T)(
			new BinaryFormatter()
				.Deserialize(
					new System.IO.MemoryStream(value.Value)));
	}

	public void Setting<T>(string Name, T Value) {
		//check for an existing value
		var setting = Settings.SingleOrDefault(s => s.Name == Name);

		//serialize the new value
		System.IO.MemoryStream ms = new System.IO.MemoryStream();
		new BinaryFormatter().Serialize(ms, Value);

		if (setting != null) {
			//for consistency let's make sure we're assigning the same type
			if (Type != typeof(T).FullName)
				throw new InvalidCastException(
				string.Format("Unable to cast: {0} to {1}", 
					typeof(T).FullName, Type));
			setting.Value = ms.ToArray();
		} else {
			//add a new value to the database
			value = new Models.Setting() {
				Name = Name,
				Type = typeof(T).Fullname,
				Value = ms.ToArray()
			};
			Settings.Add(value);
		}
	}


Now instead of calling the above cast we can now use the following

    var x = DataContext.Setting<string>("sitename"); //get
    DataContext.Setting<string>("sitename", "buildstarted.com"); //set

Hope this is helpful and inspires someone. Please comment if you have a better method. I'm not too keen on serializing all the time but it's the best method I've come up with so far.

One of the problems with having values stored in byte[] form is lack of searchability of values. However, you're unlikely to select all settings with values of "true".

##-Ben