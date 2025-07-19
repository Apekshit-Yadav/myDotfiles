#!/bin/bash
swaync-client -g | jq -c '[.[] | {summary, body, app_name}]'
