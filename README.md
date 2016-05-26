# Parse Dashboard

[![Docker Pulls](https://img.shields.io/docker/pulls/yongjhih/parse-dashboard.svg)](https://hub.docker.com/r/yongjhih/parse-dashboard/)
[![Docker Stars](https://img.shields.io/docker/stars/yongjhih/parse-dashboard.svg)](https://hub.docker.com/r/yongjhih/parse-dashboard/)
[![Docker Size](https://img.shields.io/imagelayers/image-size/yongjhih/parse-dashboard/latest.svg)](https://imagelayers.io/?images=yongjhih/parse-dashboard:latest)
[![Docker Layers](https://img.shields.io/imagelayers/layers/yongjhih/parse-dashboard/latest.svg)](https://imagelayers.io/?images=yongjhih/parse-dashboard:latest)
[![Docker Tag](https://img.shields.io/github/tag/yongjhih/docker-parse-dashboard.svg)](https://hub.docker.com/r/yongjhih/parse-dashboard/tags/)
[![Travis CI](https://img.shields.io/travis/yongjhih/docker-parse-dashboard.svg)](https://travis-ci.org/yongjhih/docker-parse-dashboard)
[![npm version](https://img.shields.io/npm/v/parse-dashboard.svg?style=flat)](https://www.npmjs.com/package/parse-dashboard)
[![Gitter Chat](https://img.shields.io/gitter/room/yongjhih/docker-parse-dashboard.svg)](https://gitter.im/yongjhih/docker-parse-dashboard)

[![Deploy to Docker Cloud](https://github.com/yongjhih/docker-parse-server/raw/master/art/deploy-to-docker-cloud.png)](https://cloud.docker.com/stack/deploy/?repo=https://github.com/yongjhih/docker-parse-dashboard)
[![Deploy to Tutum](https://s.tutum.co/deploy-to-tutum.svg)](https://dashboard.tutum.co/stack/deploy/?repo=https://github.com/yongjhih/docker-parse-dashboard)

Parse Dashboard is a standalone dashboard for managing your Parse apps. You can use it to manage your [Parse Server](https://github.com/ParsePlatform/parse-server) apps and your apps that are running on [Parse.com](https://Parse.com).

* [Getting Started](#getting-started)
* [Local Installation](#local-installation)
  * [Configuring Parse Dashboard](#configuring-parse-dashboard)
  * [Managing Multiple Apps](#managing-multiple-apps)
  * [Other Configuration Options](#other-configuration-options)
* [Running as Express Middleware](#running-as-express-middleware)
* [Deploying Parse Dashboard](#deploying-parse-dashboard)
  * [Preparing for Deployment](#preparing-for-deployment)
  * [Security Considerations](#security-considerations)
    * [Configuring Basic Authentication](#configuring-basic-authentication)
    * [Separating App Access Based on User Identity](#separating-app-access-based-on-user-identity)
  * [Run with Docker](#run-with-docker)
* [Contributing](#contributing)


## Getting Started With Docker

```sh
docker run -d -e APP_ID={appId} -e MASTER_KEY={masterKey} -e SERVER_URL={http://localhost:1337/parse} -p 4040:4040 yongjhih/parse-dashboard
```

or
```sh
wget https://github.com/yongjhih/docker-parse-dashboard/raw/master/docker-compose.yml
APP_ID={appId} MASTER_KEY={masterKey} SERVER_URL={http://localhost:1337/parse} docker-compose up -d
```

or specific version 1.0.10:

```sh
docker run -d -e APP_ID={appId} -e MASTER_KEY={masterKey} -e SERVER_URL={http://localhost:1337/parse} -p 4040:4040 yongjhih/parse-dashboard:1.0.10
```

or specific dev image for latest commit:

```sh
docker run -d -e APP_ID={appId} -e MASTER_KEY={masterKey} -e SERVER_URL={http://localhost:1337/parse} -p 4040:4040 yongjhih/parse-dashboard:dev
```

## Usage of letsencrypt for parse-dashboard with https certificated domain

```sh
$ git clone https://github.com/yongjhih/docker-parse-server
$ cd docker-parse-server

$ USER1=yongjhih \
  USER1_PASSWORD=yongjhih \
  LETSENCRYPT_EMAIL=yongjhih@example.com \
  LETSENCRYPT_HOST=yongjhih.example.com \
  VIRTUAL_HOST=yongjhih.example.com \
  APP_ID=myAppId MASTER_KEY=myMasterKey docker-compose -f docker-compose-le.yml up
```

Open your https://yongjhih.example.com/ url and unblock browser protected scripts, that's it.

BTW, you can remove unused 80 port after volumes/proxy/certs generated:

```sh
sed -i -- '/- "80:80"/d' docker-compose-le.yml
```

# Getting Started

[Node.js](https://nodejs.org) version >= 4.3 is required to run the dashboard. You also need to be using Parse Server version 2.1.4 or higher.

# Local Installation

Install the dashboard from `npm`.

```
npm install -g parse-dashboard
```

You can launch the dashboard for an app with a single command by supplying an app ID, master key, URL, and name like this:

```
parse-dashboard --appId yourAppId --masterKey yourMasterKey --serverURL "https://example.com/parse" --appName optionalName
```

You may set the host, port and mount path by supplying the `--host`, `--port` and `--mountPath` options to parse-dashboard. You can use anything you want as the app name, or leave it out in which case the app ID will be used.

After starting the dashboard, you can visit http://localhost:4040 in your browser:

![Parse Dashboard](.github/dash-shot.png)

## Configuring Parse Dashboard
You can also start the dashboard from the command line with a config file.  To do this, create a new file called `parse-dashboard-config.json` inside your local Parse Dashboard directory hierarchy.  The file should match the following format:

```json
{
  "apps": [
    {
      "serverURL": "http://localhost:1337/parse",
      "appId": "myAppId",
      "masterKey": "myMasterKey",
      "appName": "MyApp"
    }
  ]
}
```

You can then start the dashboard using `parse-dashboard --config parse-dashboard-config.json`.

## Managing Multiple Apps

Managing multiple apps from the same dashboard is also possible.  Simply add additional entries into the `parse-dashboard-config.json` file's `"apps"` array.

You can manage self-hosted [Parse Server](https://github.com/ParsePlatform/parse-server) apps, *and* apps that are hosted on [Parse.com](http://parse.com/) from the same dashboard. In your config file, you will need to add the `restKey` and `javascriptKey` as well as the other paramaters, which you can find on `dashboard.parse.com`. Set the serverURL to `http://api.parse.com/1`:

```js
{
  "apps": [
    {
      "serverURL": "https://api.parse.com/1", // Hosted on Parse.com
      "appId": "myAppId",
      "masterKey": "myMasterKey",
      "javascriptKey": "myJavascriptKey",
      "restKey": "myRestKey",
      "appName": "My Parse.Com App",
      "production": true
    },
    {
      "serverURL": "http://localhost:1337/parse", // Self-hosted Parse Server
      "appId": "myAppId",
      "masterKey": "myMasterKey",
      "appName": "My Parse Server App"
    }
  ]
}
```

## App Icon Configuration

Parse Dashboard supports adding an optional icon for each app, so you can identify them easier in the list. To do so, you *must* use the configuration file, define an `iconsFolder` in it, and define the `iconName` parameter for each app (including the extension). The path of the `iconsFolder` is relative to the configuration file. If you have installed ParseDashboard globally you need to use the full path as value for the `iconsFolder`. To visualize what it means, in the following example `icons` is a directory located under the same directory as the configuration file:

```json
{
  "apps": [
    {
      "serverURL": "http://localhost:1337/parse",
      "appId": "myAppId",
      "masterKey": "myMasterKey",
      "appName": "My Parse Server App",
      "iconName": "MyAppIcon.png",
    }
  ],
  "iconsFolder": "icons"
}
```

## Other Configuration Options

You can set `appNameForURL` in the config file for each app to control the url of your app within the dashboard. This can make it easier to use bookmarks or share links on your dashboard.

To change the app to production, simply set `production` to `true` in your config file. The default value is false if not specified.

# Running as Express Middleware

Instead of starting Parse Dashboard with the CLI, you can also run it as an [express](https://github.com/expressjs/express) middleware.

```
var express = require('express');
var ParseDashboard = require('parse-dashboard');

var dashboard = new ParseDashboard({
  "apps": [
    {
      "serverURL": "http://localhost:1337/parse",
      "appId": "myAppId",
      "masterKey": "myMasterKey",
      "appName": "MyApp"
    }
  ]
});

var app = express();

// make the Parse Dashboard available at /dashboard
app.use('/dashboard', dashboard);

var httpServer = require('http').createServer(app);
httpServer.listen(4040);
```

If you want to run both [Parse Server](https://github.com/ParsePlatform/parse-server) and Parse Dashboard on the same server/port, you can run them both as express middleware:

```
var express = require('express');
var ParseServer = require('parse-server').ParseServer;
var ParseDashboard = require('parse-dashboard');

var api = new ParseServer({
	// Parse Server settings
});

var dashboard = new ParseDashboard({
	// Parse Dashboard settings
});

var app = express();

// make the Parse Server available at /parse
app.use('/parse', api);

// make the Parse Dashboard available at /dashboard
app.use('/dashboard', dashboard);

var httpServer = require('http').createServer(app);
httpServer.listen(4040);
```

# Deploying Parse Dashboard

## Preparing for Deployment

Make sure the server URLs for your apps can be accessed by your browser. If you are deploying the dashboard, then `localhost` urls will not work.

## Security Considerations
In order to securely deploy the dashboard without leaking your apps master key, you will need to use HTTPS and Basic Authentication.

The deployed dashboard detects if you are using a secure connection. If you are deploying the dashboard behind a load balancer or proxy that does early SSL termination, then the app won't be able to detect that the connection is secure. In this case, you can start the dashboard with the `--allowInsecureHTTP=1` option. You will then be responsible for ensureing that your proxy or load balancer only allows HTTPS.

### Configuring Basic Authentication
You can configure your dashboard for Basic Authentication by adding usernames and passwords your `parse-dashboard-config.json` configuration file:

```json
{
  "apps": [{"...": "..."}],
  "users": [
    {
      "user":"user1",
      "pass":"pass"
    },
    {
      "user":"user2",
      "pass":"pass"
    }
  ]
}
```

### Separating App Access Based on User Identity
If you have configured your dashboard to manage multiple applications, you can restrict the management of apps based on user identity.

To do so, update your `parse-dashboard-config.json` configuration file to match the following format:

```json
{
  "apps": [{"...": "..."}],
  "users": [
     {
       "user":"user1",
       "pass":"pass1",
       "apps": [{"appId1": "myAppId1"}, {"appId2": "myAppId2"}]
     },
     {
       "user":"user2",
       "pass":"pass2",
       "apps": [{"appId1": "myAppId1"}]
     }  ]
}
```
The effect of such a configuration is as follows:

When `user1` logs in, he/she will be able to manage `appId1` and `appId2` from the dashboard.

When *`user2`*  logs in, he/she will only be able to manage *`appId1`* from the dashboard.


## Deploy Docker

Getting npm versions of parse-dashboard:

```sh
docker run -it node npm view parse-dashboard
```

If you are not familiar with Docker, ``--port 8080`` will be passed in as argument to the entrypoint to form the full command ``npm start -- --port 8080``. The application will start at port 8080 inside the container and port ``8080`` will be mounted to port ``80`` on your host machine.

# Contributing

We really want Parse to be yours, to see it grow and thrive in the open source community. Please see the [Contributing to Parse Dashboard guide](CONTRIBUTING.md).
