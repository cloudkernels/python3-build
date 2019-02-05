python3-build
=============

This is a Docker image that helps you build an image for running an arbitrary
python snippet as a [rumprun unikernel](https://github.com/cloudkernels/rumprun)
on top of [Solo5](https://github.com/Solo5/solo5).

### How to

Our goal is to build the `hello.py` python script inside an image that we can
later deploy as a unikernel on top of Solo5 or using a [Nabla container](https://blog.cloudkernels.net/posts/building-nabla-aarch64/).

The Docker image expects to find the script file under the `/build` directory of the container.
So we need to bind a host directory to the `/build` directory of the container.

Finally, we need to let the container know the names of the script file and the output iso
image that we want the container to build, so we pass them as argument when invoking `docker run`

Assuming we have on the current directory the python file `hello.py` that we want to build
we run:

```
docker run --rm -v $(pwd):/build cloudkernels/python3-build hello.iso hello.py 
```

This will create two files in our current directory. The `hello.iso` file which is the image
that contains our python installation and `python.spt` and `python.hvt` which are the Python3
rumprun kernels for the `spt` and `hvt` Solo5 targets respectively.


#### Handling python dependencies
If our python script imports python packages we need to let the build system know
about these. Our Docker image handles these dependencies through an extra `requirements` file
we pass at run time as an extra argument.

The `requirements` file includes the dependencies of our python script in the form of one dependency
per line.

For example image we want to run a simple script that uses the `requests` python package and looks like
this:

```
import requests

r = requests.get('https://www.example.com')
print(r.status_code)
print(r.text)
```

In order to build the image for this script we need to provide the `requirements.txt` file
which includes a single line looking like this:

```
bchalios@localhost:~$ cat requirements.txt
requests
```

Like before, we invoke our container:

```
docker run --rm -v $(pwd):/build cloudkernels/python3-build requests.iso requests_main.py requirements.txt
```
