# R-Project

A Rails solution for the R-Project challange. It's done via one DB model that stores all the versions, and markes the latest of them.

## Syncing

* Done via a rake task that can be scheduled on a crontab.
* It loops the server list of versions every time and **only** fetches the info of the new versions and indexes them. 
* It depends on the versions table to determine whether a certain version was indexed or not.
* **It can be optimized later on by**:
 * Caching the HTML of a processed server list
 * Fetching the HTML of a new fetched server list
 * Doing a diff on both files to determine what new versions we have.
 * Adding those new versions only.
 * Replacing the cached HTML list with the new one.



## Install

To run the app do the following:

* clone the project, then cd to the cloned folder
* bundle
* rake db:create
* rake db:migrate
* rake syncing:perform MAX_PACKAGES=50 *#if MAX_PACKAGES is not provided, then it will index all versions*
* rails s
