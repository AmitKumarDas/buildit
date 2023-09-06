### Update All Submodules & Commit the Parent Repository
```sh
git submodule foreach "(git checkout master; git pull; cd ..; git add '$path'; git commit -m 'Submodule Sync')"
```

#### Better Alternative?
```sh
git submodule update --remote --merge
git add project/submodule_proj_name
git commit -m 'gitlink to submodule_proj_name was updated'
git push                                                     # Missing in Above Snippet
```
