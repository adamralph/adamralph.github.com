---
layout: post
title: Openid login database schema
---

I've been working on a photo uploading website off and on for the past month or so - just a few hours a week (if that) and I was working on the Login portion and decided now would be a good time to get into <a href="http://www.dotnetopenauth.net/" title="Dot Net Open Auth" target="&#95;new">OpenId</a>. However, it's not the most user friendly method of logging in. I wanted a way to use OpenId <strong>or</strong> a local login. In case people don't want to use OpenId or just simply don't know what it is. I plan on looking into <a href="http://developers.facebook.com/docs/guides/web" target="&#95;new">Facebook Connect</a> or <a href="http://apiwiki.twitter.com/OAuth-FAQ" target="&#95;new">Twitter auth</a>, as well, and may post that how to integrate it in a future article.

To support OpenId <strong>and</strong> a local login I had to modify my table structure slightly. This will allow us to use only OpenId or local login should I decide to use one over the other. To accomplish this I moved the authentication portion of my User into a separate table.

    public class User {
        public int UserID { get; set; }
        public string Name { get; set; }
        public string Page { get; set; }

        public virtual Authentication Authentication { get; set; }
    }

    public class Authentication {
        public int Id { get; set; }
        public string LoginId { get; set; }
        public string OpenIdProvider { get; set; }
        public string Password { get; set; }

        public virtual User User { get; set; }
    }


    //login methods
    User StandardUserLogin(string id) {
        IDataContext db = new DataContext();
        var user = db.Users.SingleOrDefault(u => u.Authentication.LoginId == username);
        if (user != null) {
            if (user.Authentication.Password == password) {
                SetAuthenticationTicket(user);
                return user;
            }
        }
    }

    User OpenIdUserLogin(string id) {
        IDataContext db = new DataContext();
        var user = db.Users.SingleOrDefault(u => u.Authentication.LoginId == username);
        if (user == null) {
            //create new openid user
        }

        if (user.Authentication.LoginId == id) {
            SetAuthenticationTicket(user);
            return user;
        }
    }


I actually do two different logins based on whether or not it's an OpenId user. If it's an OpenId User I automagically create a new user save it and return the new user (unless it has an existing login associated with it already)

###- Ben