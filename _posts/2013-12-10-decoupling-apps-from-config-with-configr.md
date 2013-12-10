---
layout: post
title: Decoupling Apps from Config with ConfigR
location: Zurich
tags:
- ConfigR
- configuration
---

ConfigR is a [NuGet](https://www.nuget.org/packages/ConfigR/) package based on [scriptcs](http://scriptcs.net/) and [Roslyn](http://msdn.microsoft.com/en-us/vstudio/roslyn.aspx) which allows writing configuration files in C# instead of XML.

For example, the stringy XML soup:

```xml
	<?xml version="1.0"?>
	<!-- app.config or web.config -->
	<configuration>
	  <appSettings>
	    <add key="Uri" value="http://tempuri.org/myservice"/>
		<add key="Timeout" value ="10000"/>
	  <appSettings>
	</configuration>
```

can become

```C#
// MyApp.exe.csx or Web.csx 
Add("Uri", new Uri("http://tempuri.org/myservice"));
Add("Timeout", 10000);
```

In the real world configuration is often more complex than this, e.g. multiple dev, test and production environments, per machine configuration, etc.

<!--excerpt-->

In their great book, *Continuous Delivery*\*, Jez Humble and David Farley describe how such configuration can be injected into your application at the **build time**, **packaging time**, **deployment time** and **run time**.

### Run Time Configuration

The most flexible of these strategies is **run time** configuration which allows identical building, packaging and deployment of your application in all environments by deferring all configuration decisions until run time. This is easy to achieve using ConfigR since the configuration script is executed at runtime and allows any C# you like, as long as it can be executed by scriptcs\**.

First, let's see what the application has to do to retrieve one of the configuration values:

```C#
var uri = Configurator.Get<Uri>("Uri");
```
In the simple case above, we chose to hardcode our URI into the configuration script. Later, we may choose to look up the URI from a database based on the current machine name:

```C#
// MyApp.exe.csx or Web.csx
using System.Data.SqlClient;
using(var connection = new SqlConnection("..."))
{
	connection.Open();
	using(var command = connection.CreateCommand())
	{
		command.CommandText =
            "select Uri from Uris where Machine = '{@Machine}'";
		
		command.Parameters.AddWithValue(
			"Machine", Environment.MachineName);
		
		Add("Uri", new Uri(command.ExecuteScalar().ToString()));
	}
}
```
Let's see how the application code has to change in order to support this:

```C#
var uri = Configurator.Get<Uri>("Uri");
```
The application code hasn't changed at all. This because the application is completely *decoupled* from the choice of configuration strategy.

Later, we may wish to fetch our configuration from the file system or from an HTTP endpoint, perhaps based not only on the machine name but the current application version, or the current user. We may invent other weird and wonderful configuration strategies.

By implementing your configuration strategy in a ConfigR configuration script, *the application code never needs to change.*

### Get ConfigR

ConfigR is available at [NuGet](https://www.nuget.org/packages/ConfigR/). For more information see the [quickstart](https://github.com/config-r/config-r/wiki/Quickstart), [samples](https://github.com/config-r/config-r-samples) and [wiki](https://github.com/config-r/config-r/wiki). Fork ConfigR at [GitHub](https://github.com/config-r/config-r).

\* Humble, J. & Farley D. (2011). *Continuous Delivery.* Boston: Pearson Education, Inc.

\** At the time of writing, scriptcs will run any valid C# with the exception of `async/await` and `dynamic` due to limitations in the current release of Roslyn.