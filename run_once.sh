if [ -z ${TARGET_CONTAINER_IMAGE+x} ]; then TARGET_CONTAINER_IMAGE=false; fi
if [ -z ${TARGET_CONTAINER_STARTUP+x} ]; then TARGET_CONTAINER_STARTUP=false; fi

# Loop through arguments, two at a time for key and value
while [[ $# > 0 ]]
do
    key="$1"

    case $key in
        -i|--image)
            TARGET_CONTAINER_IMAGE="$2"
            shift # past argument
            ;;
        -s|--startup-command)
            TARGET_CONTAINER_STARTUP="$2"
            shift # past argument
            ;;
        *)
            echo 'bad arguments'
            exit 2
        ;;
    esac
    shift # past argument or value
done

# Make sure we have all the variables needed:
if [ $TARGET_CONTAINER_IMAGE == false ]; then
    echo "TARGET_CONTAINER_IMAGE is required. Set it as an ENV variable"
    exit 1
fi
if [ $TARGET_CONTAINER_STARTUP == false ]; then
    echo "TARGET_CONTAINER_STARTUP is required. Set it as an ENV variable"
    exit 1
fi

sleep 15
DOCKER_CONTAINERS_RUNNING=`docker ps | awk '{print $2}' | grep -v ID | grep -v run_once | grep -v ecs-agent |  grep -v $TARGET_CONTAINER_IMAGE`

while [[ ! -z $DOCKER_CONTAINERS_RUNNING ]]
do

  if ! docker ps | awk '{print $2}' | grep -q $TARGET_CONTAINER_IMAGE; then
    eval $TARGET_CONTAINER_STARTUP
  fi

  sleep 15
  DOCKER_CONTAINERS_RUNNING=`docker ps | awk '{print $2}' | grep -v ID | grep -v run_once | grep -v ecs-agent | grep -v $TARGET_CONTAINER_IMAGE`
done
