#!/usr/bin/env bash

appFiles=${1-1}
packageAFiles=${2-0}
packageBFiles=${3-0}

# App level file generator
rm -rf ../../imports/fake/*js
echo "" > "../../imports/fake/index.js"
for i in `seq 1 $appFiles`;
        do
                echo "export default () => {}" > "../../imports/fake/$i.js"
                echo "export { default as x$i } from './$i';" >> "../../imports/fake/index.js"
        done
echo "" > "../../imports/index.js"
echo "import { x1 } from './fake';" >> "../../imports/index.js"
echo "import { x1 as xA } from 'meteor/a';" >> "../../imports/index.js"
echo "import { x1 as xB } from 'meteor/b';" >> "../../imports/index.js"

# Package #A level file generator
rm -rf ../../packages/a/fake/*js
echo "" > "../../packages/a/fake/index.js"
for i in `seq 1 $packageAFiles`;
        do
                echo "export default () => {}" > "../../packages/a/fake/$i.js"
                echo "export { default as x$i } from './$i';" >> "../../packages/a/fake/index.js"
        done
echo "" > "../../packages/a/index.js"
echo "import { x1 } from './fake';" >> "../../packages/a/index.js"
echo "import { x1 as x1B } from 'meteor/b';" >> "../../packages/a/index.js"

# Package #B level file generator
rm -rf ../../packages/b/fake/*js
echo "" > "../../packages/b/fake/index.js"
for i in `seq 1 $packageBFiles`;
        do
                echo "export default () => {}" > "../../packages/b/fake/$i.js"
                echo "export { default as x$i } from './$i';" >> "../../packages/b/fake/index.js"
        done
echo "" > "../../packages/b/index.js"
echo "import { x1 } from './fake';" >> "../../packages/b/index.js"
