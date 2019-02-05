#!/bin/bash

package_deps_file=""
if [ $# -lt 2 ] || [ $# -gt 3 ] ; then
	echo "usage: $0 iso_name script_file [requirements_file]"
	exit 0;
fi

isoname=$1
package_name=$2

### We have a requirements file
if [[ $# -eq 3 ]] ; then
	package_deps_file=$3
fi

#sanity checking
if [[ ! -f /build/$package_name ]] ; then
	echo "Could not find script file: $package_name";
	exit 1;
fi

cd /tmp/rumprun-packages/python3
mkdir -p python/lib
cp -r build/pythondist/lib/python3.5 python/lib/.

### Copy the Python script we are building in the site-packages
cp /build/${package_name} python/lib/python3.5/site-packages/.

### Fetch the dependencies and put them as well in the site-packages
if [[ $package_deps_file != "" ]] ; then
	#sanity checking
	if [[ ! -f /build/$package_deps_file ]] ; then
		echo "Could not find requirements file : $package_deps_file";
		exit 1;
	fi

	pyvenv-3.5 newpackage-env
	bash -c "source newpackage-env/bin/activate; pip install -r ${package_deps_file}; deactivate"
	cp -r newpackage-env/lib/python3.5/site-packages/* python/lib/python3.5/site-packages/.
fi

### Generate the image
genisoimage -l -r -o /build/$isoname python


### Copy the python unikernels
cp python.{spt,hvt} /build
