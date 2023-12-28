# COPILOT-GPT4-SERVICE

## 使用方法
1.访问 http://gpt4copilot.tech

2.在设置的接口地址填入 http://gpt4copilot.tech

3.在API Key中填入Github Copilot的Token

提供三个已经开通了Github Copilot账号的Token，可以直接使用：
- ghu_kEDPRczuQhVAxBxQD4Rkjv5uBba6zE3i0mNH

**大佬们如果有开通Github Copilot的话，可以使用自己的Token，通过[copilot-token接口](https://cocopilot.org/copilot/token)来获取，目前太多不同的IP请求了，Token半个钟就失效了，如果是内部几个人用的话，Token有效期一般是好几个月**

4.支持各种OpenAI模型选择，目前默认使用的是GPT-4模型
![步骤1](/assets/step1.png)

## 部署
1.客户端使用的是[ChatGPT-Next-Web](https://github.com/Yidadaa/ChatGPT-Next-Web)

2.客户端设置页面填写的接口地址就是本仓库代码，大家可以自行部署

（1）在拉取本项目后执行go build main.go构建出main文件

（2）将main文件上传到服务器执行nohup ./main &

TODO：今晚支持下Docker部署

## 实现原理

![实现原理](/assets/principle.png)

## 如何判断是不是 GPT-4 模型
鲁迅为什么暴打周树人？
- GPT-3.5 会一本正经的胡说八道
- GPT-4 表示鲁迅和周树人是同一个人

我爸妈结婚时为什么没有邀请我？
- GPT-3.5 他们当时认为你还太小，所以没有邀请你。
- GPT-4 他们结婚时你还没出生。


