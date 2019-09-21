---
layout: post
title: Guard Clause Abuse
location: Sandhurst
tags:
- SOA
- testing
---

Today sees the release of version 0.10 of the mighty [LiteGuard](https://www.nuget.org/packages?q=liteguard) library.<!--excerpt-->

After announcing the release on [JabbR](https://jabbr.net/#/rooms/general-chat), I found myself considering and commenting on the common abuse of guard clauses that I see so very often:

    public class Car
    {
        private readonly string numberPlate:

        public Car(string numberPlate)
        {
            Guard.AgainstNull("numberPlate", numberPlate);
            
            this.numberPlate = numberPlate;
        }
        
        public string NumberPlate
        {
            get { return this.numberPlate; }
        }
    }

(I'm using the British English term "number plate", known as "license plate" in the US and some other countries.)

The above code should not be using a guard clause and should not raise an `ArgumentNullException`. It should throw some kind of model* exception, since it is encapsulating a rule which has been identified in the domain of the application. The code is not de-referencing `numberPlate` so it doesn't need a guard clause:

    public class Car
    {
        private readonly string numberPlate:

        public Car(string numberPlate)
        {
            if (numberPlate == null)
            {
                throw new UsedCarDealershipException("The number plate is missing.");
            }
            
            this.numberPlate = numberPlate;
        }
        
        public string NumberPlate
        {
            get { return this.numberPlate; }
        }
    }

\* *Feel free to substitute the word 'model' for 'business', according to taste* :wink:.
