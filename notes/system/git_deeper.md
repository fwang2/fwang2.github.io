# Understanding Git

This is to cover some fundamental concepts in Git for better understanding.

## Git Objects

We need to know the four type of objects:

 * blob object
 * tree object
 * commit object
 * tag object


Git is so-called content-addressable file system. What that means: each piece
of content are save in `.git/objects` identified by 40 characters SHA-1 value.
The first 2 letter used for sub-directory and remaining 38 character as
filename.

    echo "my test" | git hash-object -w --stdin

`--stdin` is to read from standard input instead of file, `-w` is to actually
write the object.

You can read this content back by giving the identifier:

    git cat-file -p [hash identifer]

The object are grouped as **blob object**, **tree object** and **commit
object**. 

- the **blob** object is similar to inode in file system that is holding the
  content.

- the **tree** object is similar to directory, that is, a container that
  contains other objects, including the tree object itself.

  The tree object is generated off the staging area which you can update with
  `git update-index`. You can generate the tree object by `git write-tree`,
  which will take what you have in staging area and write out the tree object
  for you.

- once you have the tree object, you can call `git commit-tree` and specify
  the single tree SHA-1 to generate **commit** object. Among other things, a
  commit object will record: the top-level tree for the snapshot of the
  project at that point; the author/committer info; current timestamp; commit
  message.



## Git References

*References* or *refs* are just names or labels that help you remember where
your latest commits are, so you don't have to use SHA-1 value all the time.

    $ find ./git/refs
    .git/refs
    .git/refs/heads
    .git/refs/tags

To create a new reference, you can technically do something like this:

    echo "93db4dc5e3b5b2b1f2a272b4cf8bc16c328bb4fa" > .git/refs/heads/master

Now, you can use the head reference instead of SHA-1 value:

    git log --pretty=oneline master

Git provides a command to do this sort of update:

    git update-ref refs/heads/featureA  ca0b

This essentially what a branch is: a reference pointing to a commit,
supposedly the head of the work.

### HEAD

The `HEAD` file is a symbolic reference to the branch you are on:

    cat .git/HEAD
    ref: refs/heads/master

Now, if you run `git checkout featureA`, then

    cat .git/HEAD
    ref: refs/heads/featureA

When you run `git commit`, it creates the commit object, specifying the parent
of that commit object to whatever SHA-1 value the reference `HEAD` pointing
to.

## Tags

This type of reference contains a tagger, message, date, and a pointer. The
main difference is that a tag object points to a commit rather than a tree. It
gives that commit a friendly name.

     cat .git/refs/tags/v0.0.1-alpha.3 
     d2d20cf14693e8c8d8156d14996a95564fd827c3

## Remotes

If you add a remote and push to it, Git store the value you just pushed to
that remote for each bran in the `refs/remotes` directory. For example, you
have a remote called `origin` and push your `master` branch to it:

    git remote add origin git@github.com:fwang2/test.git
    git push origin master

    cat .git/refs/remotes/origin/master
    10f3c45185dea3722e03c717bbcce3bef922b48a


Remote references differ from branches (`refs/heads` references) maininly in
that they can not be checked out. Git moves them around as bookmarks to the
last known state where those branches were on servers.


## The Refspec

The refspec refers to mapping from remote branches to local references.

Assume you add a remote like this:

    git remote add origin git@github.com:fwang2/notes.git
    
The refspec in `.git/config` is like this:

    [remote "origin"]
    url = git@github.com:fwang2/notes
    fetch = +refs/heads/*:refs/remotes/origin/*

The format of the refspec is an optional `+`, followed by `src:dst`, where
`src` is the pattern for references on the remote side, and `dst` is where
those references will be written locally. 

In the above default case, Git will fetches all referneces under `refs/heads/`
on the server, and writes them to `refs/remotes/origin/` locally. 

Now if you want Git pull down only master branch each time, and not every
other branch on the remote server, you can change the fetch line:

    fetch = +refs/heads/master:refs/remotes/origin/master
    fetch = +refs/heads/experiment:refs/remotes/origin/experiment

With command line, you can pull `master` branch of remote to `origin/mymaster`
locally like this:

    git fetch origin master:refs/remotes/origin/mymaster

