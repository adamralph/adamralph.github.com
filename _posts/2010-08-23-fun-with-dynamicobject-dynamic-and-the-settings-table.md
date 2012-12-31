---
layout: post
title: Fun with dynamicobject dynamic and the settings table
---

##What came before

In my <a href='http://buildstarted.com/2010/08/13/update-settings-table-with-extension-methods/'>previous post</a> I discussed ways of making the settings table using Generics to have typed access to our properties. This required us to still pass in the name of our property as a string to a method.

    User user = db.Users.First();
    if (user.Setting<bool>("IsAdministrator")) {
        //yay, this user is an admin!
    }


Today we're going to take advantage of <strong>dynamic</strong> to take it one step further.

##The Goal

    User user = db.Users.First();
    if (user.Settings.IsAdministrator) {
        //yay, this user is an admin!
    }


We're going to create a new class that inherits from <strong>DynamicObject</strong>. Doing so will allow us to utilize all the power of dynamics such as getting/setting members, calling methods, or type conversions. <a 

<a href='http://msdn.microsoft.com/en-us/library/dd233052(VS.100).aspx'>The dynamic language runtime</a> first checks to see if the property of our DynamicObject already exists and if it doesn't find the property it calls <strong>TryGetMember</strong> or <strong>TrySetMember</strong>. This is what we're going to use to return our settings property. Here is a barebones DynamicObject that uses a <strong>Dictionary&lt;string, object&gt;</strong> to store values.

    //These are essentially the same
    //user.Settings["IsAdministrator"]
    //user.Settings.IsAdministrator

    class SettingsDynamicObject : DynamicObject {
        //used for caching
        Dictionary<string, object> _dictionary;

        public SettingsDynamicObject(User user) {
            _dictionary = new Dictionary<string, object>();
        }

        public override bool TrySetMember(SetMemberBinder binder, object value) {
            _dictionary[binder.Name] = value;
            return true;
        }

        public override bool TryGetMember(GetMemberBinder binder, out object result) {
            if ( _dictionary.TryGetValue(binder.Name, out result)) {
                return true;
            }
        }
    }


##Adding our new database overrides

We're now going to modify our overrides to pull values from the database if they don't already exist in the _dictionary object and add our code to save the new values.

	public override bool TrySetMember(SetMemberBinder binder, object value) {
		SetDatabaseValue(binder.Name, value);
		_dictionary[binder.Name] = value;
		return true;
	}

	public override bool TryGetMember(GetMemberBinder binder, out object result) {
		//check to see if the property already exists
		if ( _dictionary.ContainsKey(binder.Name) && _dictionary.TryGetValue(binder.Name, out result)) {
			return true;
		} else {
			var setting = this.user
				.UserSettings
				.SingleOrDefault(s => s.Name == binder.Name);
			if (setting == null) {
				result = null;
			} else {    
				result = new BinaryFormatter()
						.Deserialize(new System.IO.MemoryStream(setting.Value));
				_dictionary[binder.Name] = result;
			}

			return true;
		}
	}

	private void SetDatabaseValue(string name, object value) {
		var setting = this.user.UserSettings.SingleOrDefault(s => s.Name == name);
		System.IO.MemoryStream ms = new System.IO.MemoryStream();
		new BinaryFormatter().Serialize(ms, value);

		if (setting == null) {
			setting = new UserSetting() { 
							  Name = name,
							  Type = value.GetType().ToString(),
			setting.Value = ms.ToArray();
			this.user.UserSettings.Add(setting);
		} else {
			if (value != null && setting.Type != value.GetType().FullName)
				throw new InvalidCastException(
					string.Format("Unable to cast: {0} to {1}",
							value.GetType().FullName, setting.Type));
			setting.Value = ms.ToArray();
		}
	}


##Modifying our existing user object

Now we have a new DynamicObject class that we can use to populate our settings but we'll need to modify our existing User class to utilize the new Settings. One of the downsides is that we'll have two exposed properties instead of one but I think it's negligable.

    public class User {
        public Int32 UserID { get; set; }
        public string LoginID { get; set; }
        public string Name { get; set; }
        public string Page { get; set; }
        public string Password { get; set; }
    
        public virtual ICollection<UserSetting> UserSettings { get; set; }

        public virtual dynamic Settings { get; set; }
    
        public User() {
            //We need to initialize the Settings to our new DynamicObject
            Settings = new SettingsDynamicObject(this);
        }
    }


And there you have it. We now have a dynamic enabled settings property that makes our code slightly easier to read. I hope this helps you on your way to understanding c# 4.0's new dynamic namespace.

###- Ben

###Update: 

Fixed Constructor - thanks yesthatmcgurk