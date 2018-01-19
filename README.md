[![Gem Version](https://badge.fury.io/rb/any_good.svg)](http://badge.fury.io/rb/any_good)

## What's this?

A thing to quickly evaluate Ruby gem maturity and answer "Is it any good?". Like this:

![](https://raw.githubusercontent.com/zverok/any_good/master/doc/example.png)

Just a report of some numbers and facts from rubygems.org and GitHub repo of the gem in
question, to understand how risky it would be to use it.

## Usage

```
$ gem install any_good
$ any_good <gem_name>
```

## Why?

I find myself constantly repeating this process for some new gems I spotted somewhere: going to
their gem page and repo page to understand how well it maintained, or is it abandoned, and is it
something new that still have to get its ways and popularity.

This gem is just a quick one-evening experiment on whether it can be automated in a helpful manner.

## What are the colors? Are you criticizing gems?..

The colors (green-yellow-red) is just based on my own subjective "thresholds". Maybe they could become
configurable in a future versions, if any. "Yellow" and "red" aren't, in fact, "bad", it is "point
of attention" when judging whether you'll give a chance to some gem, and how important are they,
depends on the situation.

The colors DO NOT meant to "score" the gems (this gem is bad) or to compare "which gem is better",
but the typically DO give some insights on the gem's current status in community.

Those insights aren't that accurate: for example, [tzinfo](https://rubygems.org/gems/tzinfo)
is used by literally everyone, yet its GitHub repo has just ~200 stars. For another,
[inflecto](https://rubygems.org/gems/inflecto) is explicitly abandoned by its author, last version
have been released 4 years ago, yet it is robust and widely used.

## GitHub?

Yes, the gem is not required to have the link to sources published. Yes, there are gems with sources
on GitLab, BitBucket, or even SourceForge, God forbid. But again, as with colors, my _subjective_
experience says me to check its GitHub, if it is accessible. So the `any_good` does.

BTW, `any_good` connects to GitHub API anonymously, and anonymous connections are subject to harsh
rate limiting, so if you use it a lot through one day, you may want to provide `GITHUB_ACCESS_TOKEN`
environment variable (tokens are obtained [here](https://github.com/settings/tokens)).

## Is it any good?

Well, it is a quick one-evening experiment. So, no tests, no docs except this README, no config,
and just hard-coded thresholds. But it works for me.

## Who are you anyways?

Just a humble [@zverok](http://zverok.github.io).
