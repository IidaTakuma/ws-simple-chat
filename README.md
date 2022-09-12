## ws-simple-chat

This repository is a Simple WebSocket Chat composed of ServerlessFramework + AWS + Ruby Lang.

<img src="https://github.com/IidaTakuma/ws-simple-chat/blob/media/websocket_demo.gif" width=85%>

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
