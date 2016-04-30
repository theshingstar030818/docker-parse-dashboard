#!/usr/bin/env bash

#PARSE_DASHBOARD_CONFIG="${PARSE_DASHBOARD_CONFIG:-${PARSE_HOME}/Parse-Dashboard/parse-dashboard-config.json}"
parse_dashboard_config="${PARSE_HOME}/Parse-Dashboard/parse-dashboard-config.json"

if [ -f "$PARSE_DASHBOARD_CONFIG" ]; then
  exec "$@"
else
  for app in apps/*/; do
    if [ -f "${app}/config-template.json" ]; then
      envsubst < "${app}/config-template.json" > "${app}/config.json"
    fi

    [ -d /icons/ ] || mkdir -p /icons
    cp "${app}"/*.png /icons/

  done

  cat << EOF > "$parse_dashboard_config"
{
  "apps": [
EOF

  for app in apps/*/; do
    config="`cat ${app}/config.json`"
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
EOF
> "$parse_dashboard_config"

fi

exec "$@"

