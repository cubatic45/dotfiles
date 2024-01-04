# 引言

&emsp;&emsp;在代码编辑器中使用 Github Copilot Chat 时我们通过抓包可以发现 Github Copilot Chat 底层其实是调用了 OpenAI 的 ChatGPT 接口，那么我们可不可以将 Github Copilot Chat 的请求转换为 ChatGPT 请求呢？本篇文章我们来一起了解下，如何通过 Github Copilot Chat 来使用 OpenAI 的 ChatGPT。只要我们拥有 Github Copilot 账号，就能无限制免费使用 GPT-4 模型。

## Github Copilot Chat 介绍

&emsp;&emsp;GitHub Copilot Chat 原生集成在 VS Code 和 Visual Studio 中，为编辑器带来了一个聊天界面，提供类似 ChatGPT 的体验。它可以识别开发人员输入的代码、显示的错误消息，可以深入分析和解释代码块的用途，生成单元测试，甚至获得错误修复建议。目前 GitHub Copilot Chat 已经对所有 Github Copilot 用户开放，无需额外付费。不过 Github Copilot Chat 只能询问编程相关的问题，这是因为它在调用 ChatGPT 时设置了很严格的 prompt，翻译成中文大概如下：
![prompt](https://pica.zhimg.com/80/v2-eb98a375b355c50e895989ea42a62732.png)

## 实现原理

&emsp;&emsp;下面介绍一下如何将 Github Copilot Chat 的请求转换为 ChatGPT 请求，同时自定义 prompt 去绕过只能提问编程问题的限制，自行切换 GPT-4 模型无限制免费使用的实现。

### 获取 ChatGPT Authorization

&emsp;&emsp;我们在代码编辑器中登录 Github 后，会自动获取 GitHub Copilot Plugin Token，不过这需要抓包去获取，其实我们也可以直接通过 `https://cocopilot.org/copilot/token` 根据步骤来获取到 GitHub Copilot Plugin Token。在请求接口 `https://api.github.com/copilot_internal/v2/token` 时会带上 GitHub Copilot Plugin Token， 从返回数据中就可以获取到后续请求 ChatGPT 时需要用到的请求头 Authorization 字段的值。以下是一些通过抓包获得的数据：

请求内容：
![copilot_internal-v2-token请求内容](https://picx.zhimg.com/v2-1746e60866c05abf458547da27b389ae.png)

返回数据：
![copilot_internal-v2-token返回数据](https://pic1.zhimg.com/80/v2-b7e99ae6e26cf9be51b96ccf7631115d.png)

### 请求 ChatGPT

&emsp;&emsp;在拿到 Authorization Token 后，现在我们就可以通过接口 `https://copilot-proxy.githubusercontent.com/v1/chat/completions` 去请求 ChatGPT 了。

请求头：
![ChatGPT请求头](https://pica.zhimg.com/80/v2-79fb261f0f07b095a36c751e08a5b920.png)

请求内容：
![ChatGPT请求内容](https://pic1.zhimg.com/80/v2-95b19c4ea31e236a2178bcd7c53b9b54.png)

返回数据：
![ChatGPT返回数据](https://picx.zhimg.com/80/v2-2196f18e5a550b5a9d5bb768ccf0a88f.png)

以上就是 GitHub Copilot Chat 去请求 ChatGPT 的整个过程。

## 代码实现

&emsp;&emsp;了解完整个流程后，我们将这个过程使用 Golang 去实现将 GitHub Copilot Chat 请求转换为 ChatGPT 请求。我们可以借助第三方开源 ChatGPT 客户端比如 ChatGPT-Next-Web（`https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web`），只需要填入通过 `https://cocopilot.org/copilot/token` 获取到的 GitHub Copilot Plugin Token 后，即可在界面上轻松地使用 GPT-4。同时我们还可以自定义 prompt 去绕过只能提问编程问题的限制，从而提问任何问题。

服务端 Github 源码: `https://github.com/aaamoon/copilot-gpt4-service`

ChatGPT-Next-Web 演示界面：
![ChatGPT-Next-Web](https://picx.zhimg.com/80/v2-1ace5d1d84ca7d6f3a34596847dcc86c_1440w.png)

## 使用流程

&emsp;&emsp;在将客户端和服务端都部署在 `https://gpt4copilot.tech` 后，下面是一个简单的使用流程，建议有条件的朋友可以自行部署客户端和服务端。

1、访问 `https://gpt4copilot.tech`

2、在设置界面的接口地址填入本项目部署的后端服务接口地址 `https://gpt4copilot.tech`

3、在 API Key 中填入 GitHub Copilot Plugin Token（可以通过接口 `https://cocopilot.org/copilot/token` 来获取，Token 的格式以 ghu_ 或者 gho_ 开头）
![步骤1](https://picx.zhimg.com/80/v2-b4e801541500d81ca18fbe5cb8d21b71.png)
4、自行切换模型，支持 GPT-4 模型

5、接下来我们就可以无限制使用 GPT-4 模型了~

## 可使用模型介绍

&emsp;&emsp;据测试：模型参数支持 GPT-4 和 GPT-3.5-turbo，实测使用其他模型均会以默认的 3.5 处理（对比 OpenAI API 的返回结果，猜测应该是最早的版本 GPT-4-0314 和 GPT-3.5-turbo-0301 ）

## 如何判断是不是 GPT-4 模型

鲁迅为什么暴打周树人？

- GPT-3.5 会一本正经的胡说八道
- GPT-4 表示鲁迅和周树人是同一个人

我爸妈结婚时为什么没有邀请我？

- GPT-3.5 他们当时认为你还太小，所以没有邀请你。
- GPT-4 他们结婚时你还没出生。

## 最后

关于如何自行部署，可以在 `https://github.com/aaamoon/copilot-gpt4-service` 查看具体详情，如果大家用得上，可以给个 star ~
