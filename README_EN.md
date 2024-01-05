<h1 align="center">copilot-gpt4-service</h1>

<p align="center">
⚔️ Convert Github Copilot to ChatGPT
</p>

<p align="center">
English | <a href="README.md">简体中文</a>
</p>

## How to use
1. Visit https://gpt4copilot.tech

2. Fill in the interface address provided by this repository's deployed API: `https://gpt4copilot.tech`

3. Enter your Github Copilot Plugin Token in the API Key field

Three pre-registered tokens for Github Copilot accounts are available for direct use:
- ~~**ghu_kEDPRczuQhVAxBxQD4Rkjv5uBba6zE3i0mNH**~~

**If you already have a Github Copilot account, you can use your own token by obtaining it through the [copilot-token API](https://cocopilot.org/copilot/token)，Currently, due to the high number of different IP requests, the tokens I provide become invalid within half an hour. If it's for internal use within a few people, the token is generally valid for several months.**

![step](/assets/step1_EN.png)

4. Switch models on your own, support the GPT-4 model. **(Based on testing, the model parameters only support GPT-4 and GPT-3.5-turbo. Other models tested were processed with the default 3.5 version (compared to the returned results from the OpenAI API, it is speculated that they are likely the earliest versions, GPT-4-0314 and GPT-3.5-turbo-0301)).**

5. Now, we can make unlimited use of the GPT-4 model.

## Self-Deployment

### Client

The client uses [ChatGPT-Next-Web](https://github.com/Yidadaa/ChatGPT-Next-Web), where detailed deployment instructions are available

### Server

#### Docker Deployment

##### One-click Deployment

```bash
docker run -d \
  --name copilot-gpt4-service \
  --restart always \
  -p 8080:8080 \
  aaamoon/copilot-gpt4-service:latest
```

##### Real-time Build

```bash
git clone https://github.com/aaamoon/copilot-gpt4-service && cd copilot-gpt4-service
# You can modify the port in `docker-compose.yml`  
docker compose up -d
```

If you need to update the container, you can re-pull the code and build the image in the source code folder. The commands are as follows:

```bash
git pull
docker compose up -d --build
```

#### Cloudflare Worker Deployment

If Docker deployment is inconvenient, you can use the [Cloudflare Worker](https://github.com/wpv-chan/cf-copilot-service) version for deployment.

## Implementation Principle

<a href="principle.md">Principle Link</a>

Principle process image:
![Implementation Principle](/assets/principle.png)

## How to Determine if It's the GPT-4 Model

There are 9 birds in the tree, the hunter shoots one, how many birds are left in the tree？

- GPT-3.5 8 birds(Only able to answer eight.)
- GPT-4 None (other birds scared away, there may be no birds left in the trees.)

Why weren't I invited when my parents got married?

- GPT-3.5 They considered you too young at that time, so they didn't invite you.
- GPT-4 They got married before you were born.

## Special Thanks

### Contributor

<a href="https://github.com/aaamoon/copilot-gpt4-service/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=aaamoon/copilot-gpt4-service" />
</a>


## LICENSE

[MIT](https://opensource.org/license/mit/)
