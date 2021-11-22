#!/usr/bin/env bash
if [ ! -e /workspace/.emacs ]; then
    cp -a /home/gitpod/.emacs* /workspace/
fi

tmate -S /tmp/tmate.sock new-session -d
tmate -S /tmp/tmate.sock wait tmate-ready
TMATE_SESSION=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')
message="${GITPOD_WORKSPACE_CONTEXT_URL}\n\n${GITPOD_WORKSPACE_URL}\n\n${TMATE_SESSION}"
curl "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" --data "{\"chat_id\":\"$TELEGRAM_CHAT_ID\", \"text\":\"$message\"}" -H 'content-type: application/json'