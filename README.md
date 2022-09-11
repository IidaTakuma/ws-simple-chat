## ws-simple-chat

This repository is a simple WebSocket Chat composed by ServerlessFramework + AWS + Ruby Lang.

== demo gif here ==

### Get Started

1. Install serverless and wscat via npm.(wscat is used by testing websocket.)

```
npm install -g serverless wscat
```

2. Setup your AWS Certificate

```
export AWS_ACCESS_KEY_ID=<your-key>
export AWS_SECRET_ACCESS_KEY=<your-secret-key>
```

3. Deploy the functions

```
sls deploy
```
