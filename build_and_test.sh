# Usage: ./build_and_test.sh [--clean] [--skip_test:false]
# Set clean and test arguments

# Exit when any command fails.
set -e

#Colors.
BLUE='\033[0;34m'
NOCOLOR='\033[0m'
GREEN='\033[0;32m'

clean=false
skip_test=false
help=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --clean)
      clean=true
      shift
      ;;
    --skip_test)
      skip_test=true
      shift
      ;;
    --help)
      help=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

if [ "$help" = true ]; then
  echo "Usage: ./build_and_test.sh [--clean] [--skip_test]"
  exit 0
fi

if [ "$clean" = true ]; then
  echo -e "${BLUE}Cleaning...${NOCOLOR}"
  rm -rf _build
fi

if [ ! -d "_build" ]; then
  echo -e "${BLUE}Running cmake...${NOCOLOR}"
  mkdir _build && cmake -B _build
fi

echo -e "${BLUE}Building...${NOCOLOR}"
make -C _build

if [ "$skip_test" = false ]; then
  make test -C _build
  echo -e "${BLUE}Running unittest...${NOCOLOR}"
  _build/bin/gflags_unittest --test_tmpdir="Testing" --srcdir="../../"
fi

echo -e "\n\n${GREEN}Done!${NOCOLOR}"