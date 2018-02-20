#!/usr/bin/env bash
# to run
# yarn run start-speed > ../../../running-app-logs-5_000-fake-files.txt

# to tail
# tail -f -n 5000 Documents/pathable/running-app-logs-5_000-fake-files.txt

# to generate fake files and import then (just import index from fake folder somewhere)
rm -rf ../imports/fake/*js
echo "" > "../imports/fake/index.js"
for i in `seq 1 3`;
        do
                echo "export const x$i = () => {}" > "../imports/fake/$i.js"
                echo "import './$i';" >> "../imports/fake/index.js"
        done