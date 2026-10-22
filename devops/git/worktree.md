# Worktree

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Worktree](#worktree)
    - [Ovewview](#ovewview)
      - [1.What](#1what)
      - [2.Usage](#2usage)

<!-- /code_chunk_output -->


### Ovewview

#### 1.What

under the hood, a worktree is just multiple directories **sharing the same Git repo**

so if someone commits in a worktree, all worktrees can access these commits without pushing or pulling

#### 2.Usage

* create worktree
```shell
git worktree add <path> <branch>      # check out an existing branch in a new folder
git worktree add -b <new-branch> <path>  # create a new branch and check it out there
git worktree list                     # show all worktrees
```

* remove worktree
```shell
git worktree remove <path>            # delete a worktree
git worktree prune                    # clean up stale entries (e.g. if you deleted the folder manually)
```