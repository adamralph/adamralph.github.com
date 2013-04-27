---
layout: post
title: Alternate Code for dotnetConf Test Driving .NET
location: Zurich
tags:
- dotnetConf
- TDD
- FakeItEasy
- xBehave.net
---

[Keith Burnell](http://www.dotnetdevdude.com/) gave a great talk today titled [Test Driving .NET](http://www.youtube.com/watch?v=_m41mTIPLIE&feature=c4-feed-u) at [dotnetConf](http://live.dotnetconf.net/).

For anyone who might be interested in using alternate frameworks for TDD in .NET, I thought I'd reproduce the code shown during his talk using a couple of my own OSS projects, [FakeItEasy](https://github.com/FakeItEasy/FakeItEasy) and [xBehave.net](https://github.com/xbehave/xbehave.net). I've taken the version of the code before the IoC was introduced in the last part of the talk because this is not affected by the changes which I'd like to demonstrate.

<!--excerpt-->

The original code from Keith's talk (using [NUnit](http://www.nunit.org/), [RhinoMocks](http://hibernatingrhinos.com/oss/rhino-mocks) and [FluentAssertions](https://fluentassertions.codeplex.com/)) looked something like this (using `var` where possible):

	[Test]
	public void Add_ShouldReturn_12_When_Passed_8_And_4()
	{
		//Arrange
		const decimal input1 = 8;
		const decimal input2 = 4;
		var mockRepository = new MockRepository();
		var validationServiceMock = mockRepository
			.StrictMock<IValidationService>();
		validationServiceMock
			.Expect(x => x.ValidateForAdd(input1, input2))
 			.Return(True).Repeat.Once;
		var classUnderTest =
			new CalculatorService(validationServiceMock);
		//Act
		var result = classUnderTest.Add(input1, input2);
		//Assert
		mockRepository.VerifyAll();
		result.Should().Be(12);
	}

Here is the test re-written using [FakeItEasy](https://github.com/FakeItEasy/FakeItEasy) instead of RhinoMocks:
	
	[Test]
	public void Add_ShouldReturn_12_When_Passed_8_And_4()
	{
		//Arrange
		const decimal input1 = 8;
		const decimal input2 = 4;
		var validationService = A.Fake<IValidationService>();
		A.CallTo(() => validationService.Add(input1, input2))
 			.Returns(true);
		var classUnderTest = new CalculatorService(validationService);
		//Act
		var result = classUnderTest.Add(input1, input2);
		//Assert
		A.CallTo(() => validationService.Add(input1, input2))
 			.MustHaveHappened(Repeated.Exactly.Once);
		result.Should().Be(12);
	}

And here is the test (now a scenario) re-written using [xBehave.net](https://github.com/xbehave/xbehave.net):

	[Scenario]
	public void Addition(
		decimal input1,
		decimal input2,
		IValidationService validationService,
		CalculatorService classUnderTest,
		decimal result)
	{
		"Given an input of 8"
			.Given(() => input1 = 8);

		"And an input of 4"
			.And(() => input2 = 4);

		"And a validation service"
			.And(() =>
			{
				validationService = A.Fake<IValidationService>();
				A.CallTo(() => validationService.Add(input1, input2))
 					.Returns(true);
			});

		"And a calculation service"
			.And(() => classUnderTest =
 				new CalculatorService(validationService);
		
		"When I add the inputs"
			.When(() => result = classUnderTest.Add(input1, input2);
		
		"Then the input must have been validated"
			.Then(() => A.CallTo(() =>
 					validationService.Add(input1, input2))
				.MustHaveHappened(Repeated.Exactly.Once));
 		
		"And the result should be 12"
			.And(() => result.Should().Be(12));
	}

It's also easy to add further examples when using xBehave.net with the `Example` attribute:

	[Scenario]
	[Example(8, 4, 12)]
	[Example(7, 9, 16)]
	[Example(100, 200, 300)]
	public void Addition(
		decimal input1,
		decimal input2,
		decimal expectedResult,
		IValidationService validationService,
		CalculatorService classUnderTest,
		decimal result)
	{
		"Given an input of {0}"
			.Given(() => { });

		"And an input of {1}"
			.And(() => { });

		"And a validation service"
			.And(() =>
			{
				validationService = A.Fake<IValidationService>();
				A.CallTo(() => validationService.Add(input1, input2))
 					.Returns(true);
			});

		"And a calculation service"
			.And(() => classUnderTest =
 				new CalculatorService(validationService);
		
		"When I add the inputs"
			.When(() => result = classUnderTest.Add(input1, input2);
		
		"Then the input must have been validated"
			.Then(() => A.CallTo(() =>
 					validationService.Add(input1, input2))
 				.MustHaveHappened());
 		
		"And the result should be {2}"
			.And(() => result.Should().Be(expectedResult));
	}
