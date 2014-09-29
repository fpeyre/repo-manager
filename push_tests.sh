#!/bin/bash

for repo in $(python list_modules.py); do
    git clone $repo
    name=$(echo $repo | awk -F '/?\\.?' '{print $3}')
    # Add new files
    if [ -d "$name/test" ]; then
        [ -f "src_to_cp/test/${name}_dep_modules.txt" ] && cp src_to_cp/test/${name}_dep_modules.txt $name/test/dep_modules.txt
        cp src_to_cp/test/setup_module_test.sh $name/test/
        chmod +x $name/test/setup_module_test.sh
    fi
    # Update Travis file
    cp src_to_cp/.travis.yml $name/
    cd $name
    if [[ $(grep '-e.*egg=shinken' requirements.txt | wc -l) -eq 1 ]]; then
        git rm requirements.txt
    fi
    
    if [ -f README.md ]; then
        if [[ $(grep "travis-ci.org" README.md | wc -l) -eq 0 ]]; then
            echo -e "<a href='https://travis-ci.org/shinken-monitoring/"$name"'><img src='https://api.travis-ci.org/shinken-monitoring/"$name".svg?branch=master' alt='Travis Build'></a>" > tmp.md
            cat README.md >> tmp.md
            mv tmp.md README.md
        fi
    fi

    if [ -f README.rst ]; then
        if [[ $(grep "travis-ci.org" README.rst | wc -l) -eq 0 ]]; then
            echo -e ".. image:: https://api.travis-ci.org/shinken-monitoring/${name}.svg?branch=master\n  :target: https://travis-ci.org/shinken-monitoring/$name" > tmp.rst
            cat README.rst >> tmp.rst
            mv tmp.rst README.rst
        fi
    fi


    # Read before pressing enter
    git status
    read
    git add .
    git commit -m "Enh: Travis build"
    git push origin master
    cd ..
done
    
