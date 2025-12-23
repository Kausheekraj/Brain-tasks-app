#!/usr/bin/env bash
cd $(dirname "${0}") || exit 1
usage () {
  echo "[Usage]: <${0}> [-d] [-s] [-b] "
  echo "   ============================== "
  echo "    -b   - building image"
  echo "    -d   - Deploy Container"
  echo "    -s   - Stop Container"
  echo "    -r   - Remove Container image"
  echo "   ============================== "
  exit 1
}
no_opts () {
  echo "Pls provide a valid option to run the script"
  echo " use ${0} '-h' or '--help' for more "
  exit 1
}
for arg in "${@}"; do
  if [[ "$arg" == '--help' ]]; then
    usage
    exit 1
  fi
done
  while getopts "bsrdh" opts; do
    case  "${opts}" in
    b) ./build.sh ;;
    d) ./deploy.sh ;;
    s) ./stop.sh ;;
    r) ./stop.sh rmi ;;
    h) usage ;;
    ?) no_opts ;;
  esac
done

if [[ $OPTIND -eq 1 ]]; then
  usage
fi
