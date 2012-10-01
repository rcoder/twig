Twig lets you track progress on your topic branches.


Installation
============

    cd /usr/local/src
    git clone git://github.com/rondevera/twig
    ./install


Usage
=====

* List branches: `twig`
* Get current branch key: `twig <key>`
* Set current branch key: `twig <key> <value>`
* Get any branch key: `twig <key> -b <branch>`
* Set any branch key: `twig <key> <value> -b <branch>`


Examples
--------

List your branches, and highlight the current branch:

    $ twig

    2011-11-23 18:00:21 -0800 (7m ago)  * refactor_all_the_things
    2011-11-24 17:12:09 -0800 (4d ago)    development
    2011-11-26 19:45:42 -0800 (6d ago)    master

Set info about the current branch, e.g., which ticket it refers to. Just run
`twig <your key> <your value>`:

    $ twig issue 159

                                          issue    branch
                                          -----    ------
    2011-11-23 18:00:21 -0800 (7m ago)    159    * refactor_all_the_things
    2011-11-24 17:12:09 -0800 (4d ago)    -        development
    2011-11-26 19:45:42 -0800 (6d ago)    -        master

Show a single property of the current branch (`twig <your key>`):

    $ twig issue

    159

Set more info about the current branch (`twig <another key> <another value>`):

    $ twig status "Shipped"

                                          issue    status     branch
                                          -----    ------     ------
    2011-11-23 18:35:21 -0800 (3d ago)    159      Shipped  * refactor_all_the_things
    2011-11-24 17:12:09 -0800 (4d ago)    -        -          development
    2011-11-26 19:45:42 -0800 (6d ago)    -        -          master

Over time, track progress on multiple topic branches in parallel:

    $ twig

                                          issue    status         branch
                                          -----    ------         ------
    2011-12-01 18:00:21 -0800 (7m ago)    486      In progress    optimize_all_the_things
    2011-12-01 16:49:21 -0800 (2h ago)    268      In progress    whitespace_all_the_things
    2011-11-23 18:35:21 -0800 (3d ago)    159      Shipped      * refactor_all_the_things
    2011-11-24 17:12:09 -0800 (4d ago)    -        -              development
    2011-11-26 19:45:42 -0800 (6d ago)    -        -              master
