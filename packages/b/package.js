Package.describe({
  version: '1.0.0',
  name: 'b',
});

Package.onUse((api) => {
  api.versionsFrom('1.6.1');

  api.use('ecmascript');

  api.addFiles('index.js', ['client']);
});
