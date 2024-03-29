```shell
#!/bin/bash

#please set variables depending on your environment
#local registry address
my_registry=harbor.test.com
#other registry,use | to match multiple registries
match_pattern="t1.harbor.com|t2.harbor.com"
registry_prefix="${my_registry}/library"


if [ "$match_pattern" != "" ]
  then
    images=$(docker images | grep -vE ^$my_registry | grep -vE $match_pattern | awk 'NR!=1{print $1":"$2}')
  else
    images=$(docker images | grep -vE ^$my_registry | awk 'NR!=1{print $1":"$2}')
fi
# images=$(docker images | grep -vE ^$my_registry | grep -vE $match_pattern | awk 'NR!=1{print $1":"$2}')

## retag images and then push to my-registry
for image in ${images}; do
  # if ! echo ${image} | grep "/"
  #   then
  #     docker image tag ${image} ${my_registry}/docker.io/${image}
  #     docker push ${my_registry}/docker.io/${image}
  #   else
  #     docker image tag ${image} ${my_registry}/${image}
  #     docker push ${my_registry}/${image}
  # fi
  docker image tag ${image} ${registry_prefix}/${image}
  docker push ${registry_prefix}/${image}

done

if [ -n "$match_pattern" ];then
  tagged_images=$(docker images | grep -E $match_pattern | awk '{print $1":"$2}')
  ## retag images and then push to my-registry
  for image in ${tagged_images}; do
    localImage=`echo ${image} | sed 's/^[^/]*//g'`
    docker image tag ${image} ${registry_prefix}${localImage}
    docker push ${registry_prefix}${localImage}
  done
fi
```
