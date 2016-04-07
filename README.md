# Parse Dashboard

[![Docker Pulls](https://img.shields.io/docker/pulls/yongjhih/parse-dashboard.svg)](https://hub.docker.com/r/yongjhih/parse-dashboard/)
[![Docker Stars](https://img.shields.io/docker/stars/yongjhih/parse-dashboard.svg)](https://hub.docker.com/r/yongjhih/parse-dashboard/)
[![Docker Size](https://img.shields.io/imagelayers/image-size/yongjhih/parse-dashboard/latest.svg)](https://imagelayers.io/?images=yongjhih/parse-dashboard:latest)
[![Docker Layers](https://img.shields.io/imagelayers/layers/yongjhih/parse-dashboard/latest.svg)](https://imagelayers.io/?images=yongjhih/parse-dashboard:latest)
[![Docker Tag](https://img.shields.io/github/tag/yongjhih/docker-parse-dashboard.svg)](https://hub.docker.com/r/yongjhih/parse-dashboard/tags/)
[![Travis CI](https://img.shields.io/travis/yongjhih/docker-parse-dashboard.svg)](https://travis-ci.org/yongjhih/docker-parse-dashboard)
[![Gitter Chat](https://img.shields.io/gitter/room/yongjhih/docker-parse-dashboard.svg)](https://gitter.im/yongjhih/docker-parse-dashboard)

[![Deploy to Docker Cloud](https://github.com/yongjhih/docker-parse-server/raw/master/art/deploy-to-docker-cloud.png)](https://cloud.docker.com/stack/deploy/?repo=https://github.com/yongjhih/docker-parse-dashboard)
[![Deploy to Tutum](https://s.tutum.co/deploy-to-tutum.svg)](https://dashboard.tutum.co/stack/deploy/?repo=https://github.com/yongjhih/docker-parse-dashboard)

Parse Dashboard is standalone dashboard for managing your Parse apps. You can use it to manage your [Parse Server](https://github.com/ParsePlatform/parse-server) apps and your apps that are running on [Parse.com](https://Parse.com).

## Getting Started With Docker

```sh
docker run -d -e APP_ID={appId} -e MASTER_KEY={masterKey} -e SERVER_URL={http://localhost:1337/parse} -p 4040:4040 yongjhih/parse-dashboard
```

or
```sh
wget https://github.com/yongjhih/docker-parse-dashboard/raw/master/docker-compose.yml
APP_ID={appId} MASTER_KEY={masterKey} SERVER_URL={http://localhost:1337/parse} docker-compose up -d
```

### Usage of letsencrypt for parse-dashboard with https certificated domain

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

## Getting Started

[Node.js](https://nodejs.org) version >= 4.3 is required to run the dashboard. You also need to be using Parse Server version 2.1.4 or higher. Install the dashboard from `npm`.

```
npm install -g parse-dashboard
```

You can launch the dashboard for an app with a single command by supplying an app ID, master key, URL, and name like this:

```
parse-dashboard --appId yourAppId --masterKey yourMasterKey --serverURL "https://example.com/parse" --appName optionalName
```

You can then visit the dashboard in your browser at http://localhost:4040. If you want to use a different port you can supply the --port option to parse-dashboard. You can use anything you want as the app name, or leave it out in which case the app ID will be used.

If you want to manage multiple apps from the same dashboard, you can start the dashboard with a config file. For example, you could put your info into a file called `parse-dashboard-config.json` and then start the dashboard using `parse-dashboard --config parse-dashboard-config.json`. The file should match the following format:

```
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

You can also manage apps that on Parse.com from the same dashboard. In your config file, you will need to add the `restKey` and `javascriptKey` as well as the other paramaters, which you can find on `dashboard.parse.com`. Set the serverURL to `http://api.parse.com/1`:

```
{
  "apps": [
    {
      "serverURL": "https://api.parse.com/1",
      "appId": "myAppId",
      "masterKey": "myMasterKey",
      "javascriptKey": "myJavascriptKey",
      "restKey": "myRestKey",
      "appName": "My Parse.Com App"
    },
    {
      "serverURL": "http://localhost:1337/parse",
      "appId": "myAppId",
      "masterKey": "myMasterKey",
      "appName": "My Parse Server App"
    }
  ]
}
```

![Parse Dashboard](.github/dash-shot.png)

# Advanced Usage

## Other options

You can set `appNameForURL` in the config file for each app to control the url of your app within the dashboard. This can make it easier to use bookmarks or share links on your dashboard.

## Deploying the dashboard

Make sure the server URLs for your apps can be accessed by your browser. If you are deploying the dashboard, then `localhost` urls will not work.

In order to securely deploy the dashboard without leaking your apps master key, you will need to use HTTPS and Basic Auth. You can do this by adding usernames and passwords for HTTP Basic Auth to your configuration file.
```
{
  "apps": [...],
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

The deployed dashboard detects if you are using a secure connection. If you are deploying the dashboard behind a load balancer or proxy that does early SSL termination, then the app won't be able to detect that the connection is secure. In this case, you can start the dashboard with the `--allowInsecureHTTP=1` option. You will then be responsible for ensureing that your proxy or load balancer only allows HTTPS.

## Run with Docker

It is easy to use it with Docker. First pull the image:

```
docker pull yongjhih/parse-dashboard
```

Run the image with your ``config.json`` mounted as a volume

```
docker run -d -p 8080:4040 -v host/path/to/config.json:/src/Parse-Dashboard/parse-dashboard-config.json yongjhih/parse-dashboard
```

By default, the container will start the app at port 4040 inside the container. However, you can run custom command as well (see ``Deploying in production`` for custom setup).

In this example, we want to run the application in production mode at port 80 of the host machine.

```
docker run -d -p 80:8080 -v host/path/to/config.json:/src/Parse-Dashboard/parse-dashboard-config.json yongjhih/parse-dashboard --port 8080
```

If you are not familiar with Docker, ``--port 8080`` with be passed in as argument to the entrypoint to form the full command ``npm start -- --port 8080``. The application will start at port 8080 inside the container and port ``8080`` will be mounted to port ``80`` on your host machine.

## Contributing

We really want Parse to be yours, to see it grow and thrive in the open source community. Please see the [Contributing to Parse Dashboard guide](CONTRIBUTING.md).
