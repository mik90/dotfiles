# cd but marginally more helpful
# The gist of it:
#```bash
#  user@host:~$ cd /some/deep/nested/path
#  user@host:/some/deep/nested/path$
#  user@host:/some/deep/nested/path$ cdu deep
#  user@host:/some/deep
# ```

# cd up to n dirs
# using:  cd.. 10   cd.. dir
# src: https://stackoverflow.com/a/26134858/15827495
function _zz_cd_up() {
  case $1 in
    *[!0-9]*)                                          # if no a number
      cd $( pwd | sed -r "s|(.*/$1[^/]*/).*|\1|" )     # search dir_name in current path, if found - cd to it
      ;;                                               # if not found - not cd
    *)
      cd $(printf "%0.0s../" $(seq 1 $1));             # cd ../../../../  (N dirs)
    ;;
  esac
}

alias 'cdu'='_zz_cd_up'                                # can not name function 'cd..'