podman run --rm --privileged -v $(pwd)/mozilla:/root/.mozilla --env-file=.env_LGA --sysctl net.ipv6.conf.all.disable_ipv6=0 -it -p 8888:8888 -p 8118:8118 -p 8889:8889 -p 5900:5901 -p 6080:6080 
openconnect-proxy-browser:latest
