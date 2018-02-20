##  Reproduction: Meteor build/rebuild performance issue

- [issue](https://github.com/meteor/meteor/issues/9642)
- [report](https://gist.github.com/Gywem/f8fd9a4b3207359eb7970c2cad1d689e)
- [profile logs](https://github.com/filipenevola/build-performance-9642/tree/master/private)

We think Meteor build tool start to be slow when it has to take care of a lot of files, more than 1,000.

We have created this repo to show that in a simple repository, follow are the steps that we used:

```bash 
meteor create build-performance-9642 --full
```

After that we installed @babel/runtime because Meteor asked for it

```bash 
meteor npm install --save @babel/runtime
``` 

Experiment: Then we ran Meteor and change the counter quantity on hello.js (to trigger one rebuild) and changed a text on fixtures.js (to trigger another rebuild). You can see that on the files inside private folder.

After that we did the same thing for 1000 fake-files, 2000 and 5000. We used private/fakeFiles.sh to generate those and to import them on /imports/fake/index.js

Between each Experiment we did the commands below to clean up Meteor/NPM stuff:

```bash 
rm -rf node_modules
meteor reset
meteor npm install
```  

See in the [profile logs](https://github.com/filipenevola/build-performance-9642/tree/master/private) with a lot of files how Meteor build/rebuild becomes very slow.

Note that we have only simple files with a single empty function but in our real application with have real files that will take longer to be parsed, create the hash, etc
