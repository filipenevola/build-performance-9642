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

packageASrc=../../packages/a/src
# Package #A level file generator
rm -rf $packageASrc/fake/*js
echo "" > "$packageASrc/fake/index.js"
for i in `seq 1 $packageAFiles`;
        do
                echo "export default () => {}" > "$packageASrc/fake/$i.js"
                echo "export { default as x$i } from './$i';" >> "$packageASrc/fake/index.js"
        done
echo "" > "$packageASrc/index.js"
echo "import { x1 } from './fake';" >> "$packageASrc/index.js"
echo "import { x1 as x1B } from 'meteor/b';" >> "$packageASrc/index.js"

packageBSrc=../../packages/b/src
# Package #B level file generator
rm -rf $packageBSrc/fake/*js
echo "" > "$packageBSrc/fake/index.js"
for i in `seq 1 $packageBFiles`;
        do
                echo "export default () => {}" > "$packageBSrc/fake/$i.js"
                echo "export { default as x$i } from './$i';" >> "$packageBSrc/fake/index.js"
        done
echo "" > "$packageBSrc/index.js"
echo "import { x1 } from './fake';" >> "$packageBSrc/index.js"
