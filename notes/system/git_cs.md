# My Git Cheat Sheet

Everyone seems to have one, this is mine.


## Remorse

If you want to revert the change made to working directory:

    git checkout .

If you want to revert the change made to index (by `git add`):

    git reset

If you want to revert the changes made by _local_ commit:

    git revert ...


## Commit history

    git log -- filename

    # for content change
    git log -p filename

    # for more fine grained control
    git log --pretty="%h.%s" --author=fwang2 --no-merges -since=2.weeks --graph


## Merge 


### See the merge

You create a branch `featureA`, did some development. Now you want to compare
what `dev` has changed since your branch diverged:

    git diff master...dev

The above command will compare the **common ancestor**, and report what has
changed since the branch point.

If you are currently on master branch, you can also run this command to see
what has changed on branch `dev` before, say, performing a merge.

    git diff ...dev


## Rebase

The rebase rule is **don't rebase commits that you have pushed to the public**.
In other words, if you have shared a topic branch to the public, don't do
rebase on that topic branch.

On your topic branch:

    git rebase [base branch] [topic branch]

Say you base your topic branch `featureA` off `master` branch, then:

    git rebase master featureA

If rebase is successful, then you *can* fast forward your `master` branch` by:

    git checkout master
    git merge featureA

This way, from `master` point of view, all development work on `featureA` is
linear, applied cleanly on top of what it has before.


## Branch Management


* Create a feature branch, off a devel branch

        git checkout -b featureA devel

* Rename a branch

        git branch -m old_branch new_branch

* Share a branch

        git push origin featureA

* To delete a remote branch

        git push origin  :featureA

    Even after you remove a remote branch, there might be remote tracking
    branch when you do `git branch -r`. To remove such branches as well:

        git branch -r -d origin/bug/15
        git branch -r -d origin/tag-view

## Remote Management

* show what remote you have

        git remote -v

* fetch from remote

        git fetch remote-name

* push to remote

        git push remote-name branch-name

    
* inspect a remote, and show local branch tracking information.

        git remote show remote-name

        # origin as remote-name
        git remote show origin


* add new remote

        git remote add bb-sys git@bitbucket.org:fwang2/sys.git
        git push bb-sys master

    This will create a new remote named `test`, pointing to the given link.

* remove a remote

        git remote rm origin

* rename a remote

        git remote rename bb-sys origin

* changing remote URL

        git remote set-url bb-sys git@github.com:fwang2/sys.git



## Recovery

### Abort all changes

Say you check out something, made bunch of changes, then you screwed it up,
and want to reset it to where you were:

    git checkout -f


    


## Tagging

* Create tag

      git tag -a v1.4 -m "my version information"
      git show v1.4

* Remove tag

      git tag -d v1.4
      git push origin :refs/tags/v1.4

* Rename tag. For this, you need to first create an alias for the new name,
then remove old tag as shown before. Say you want to change from `rel-v0.2`
(old) to `v0.2` (new):

      git tag v0.2 rel-v0.2   
      git tag -d rel-v0.2
      git push origin :refs/tags/rel-v0.2 
      git push origin v0.2    

* Work with tag under a new branch:

      git checkout -b new_branch tag_name


--- 


