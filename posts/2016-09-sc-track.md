---
title: "Software Carpentry: SC Track; hunt those bugs!"
description: "For the SC Track competition entrants were asked to design a better bug-tracker."
slug: sc-track
date: 2016-09-12T08:50:15+01:00
draft: false
type: post
topics:
- Technology
tags:
- Software Carpentry
- Web archaeology
- Bug trackers
- GitHub
series: swc-archaeology
---

> This competition will be an opportunity for the next wave of developers to show their skills to the world --- and to companies like ours.
> --- *Dick Hardt, ActiveState (quote taken from [SC Track page][SC Track])*

[SC Track]: https://web.archive.org/web/20071014042747/http://software-carpentry.com/sc_track/index.html

All code contains bugs,
and all projects have features that users would like
but which aren't yet implemented.
Open source projects tend to get more of these
as their user communities grow and start requesting improvements to the product.
As your open source project grows,
it becomes harder and harder to keep track of and prioritise
all of these potential chunks of work.
What do you do?

The answer, as ever,
is to make a to-do list.
Different projects have used different solutions,
including mailing lists, forums and wikis,
but fairly quickly a whole separate class of software evolved:
the [bug tracker][],
which includes such well-known examples as
[Bugzilla](https://www.bugzilla.org/),
[Redmine](http://www.redmine.org/)
and the mighty [JIRA](https://www.atlassian.com/software/jira).

[bug tracker]: https://en.wikipedia.org/wiki/Bug_tracking_system

Bug trackers are built entirely around such requests for improvement,
and typically track them through workflow stages
(planning, in progress, fixed, etc.)
with scope for the community to discuss and add various bits of metadata.
In this way,
it becomes easier both to prioritise problems against each other
and to use the hive mind to find solutions.

Unfortunately most bug trackers are big, complicated beasts,
more suited to large projects with dozens of developers and hundreds or thousands of users.
Clearly a project of this size
is more difficult to manage and requires a certain feature set,
but the result is that the average bug tracker
is non-trivial to set up for a small single-developer project.

The [SC Track][] category asked entrants to propose a better bug tracking system.
In particular,
the judges were looking for something
easy to set up and configure
without compromising on functionality.

The winning entry was a [bug-tracker called Roundup][Roundup],
proposed by Ka-Ping Yee.
Here we have another tool which is still in active use and development today.
Given that there is now a huge range of options available in this area,
including the mighty [github][],
this is no small achievement.

[Roundup]: http://roundup.sourceforge.net/index.html
[github]: https://github.com/

These days, of course,
github has become something of a *de facto* standard
for open source project management.
Although ostensibly a version control hosting platform,
each github repository also comes with
a built-in issue tracker,
which is also well-integrated with the "pull request" workflow system
that allows contributors to submit bug fixes and features themselves.

Github's competitors,
such as GitLab and Bitbucket,
also include similar features.
Not everyone wants to work in this way though,
so it's good to see that there is still a healthy ecosystem
of open source bug trackers,
and that Software Carpentry is still having an impact.
