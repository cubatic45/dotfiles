# README

![copilot gpt4 service](assets/copilot%20gpt4%20service.svg)

该`HLEM Chart`用于部署一个提供公开的或内部的API服务，作为Chat GPT Next的调用代理，将请求转换为GitHub Copilot API。

## 快速安装
使用`helm`命令安装`HLEM Chart`，命令如下：
```bash
git clone https://github.com/aaamoon/copilot-gpt4-service.git
# git clone git@github.com:aaamoon/copilot-gpt4-service.git
cd copilot-gpt4-service/.chart
helm upgrade copilot-gpt4-service . --namespace copilot-gpt4-service --create-namespace --install  
```

## Values 字段说明
下面是`HLEM Chart`中`Values`字段的详细解释：
下面是对`hlem chart`中Values字段的解释：
请根据实际需求调整`Values`字段的值，以满足您的部署需求。
以下是使用Markdown的表格格式输出对默认值进行解释的文档：

| 字段 | 类型 | 默认值 | 解释 |
| --- | --- | --- | --- |
| replicaCount | 整数 | 1 | 副本数量，用于指定部署的副本数量。默认为1，表示只部署一个副本。 |
| image.repository | 字符串 | 空 | 镜像仓库地址，用于指定部署所使用的镜像的仓库地址。请根据实际情况填写正确的镜像仓库地址。 |
| image.pullPolicy | 字符串 | IfNotPresent | 镜像拉取策略，用于指定镜像拉取的策略。默认为IfNotPresent，表示如果镜像已经存在则不再拉取。 |
| tag | 字符串 | latest | 镜像标签，用于指定部署所使用的镜像的标签。默认为latest，表示使用最新的镜像标签。 |
| imagePullSecrets | 列表 | 空 | 镜像拉取的凭证，用于从私有镜像仓库拉取镜像。请根据实际情况填写正确的镜像拉取凭证。 |
| nameOverride | 字符串 | 空 | 重写名称，用于覆盖生成的名称。默认为空，表示不进行名称重写。 |
| fullnameOverride | 字符串 | 空 | 完整名称重写，用于覆盖生成的完整名称。默认为空，表示不进行完整名称重写。 |
| serviceAccount.create | 布尔值 | true | 是否创建ServiceAccount。默认为true，表示创建ServiceAccount。 |
| serviceAccount.automount | 布尔值 | true | 是否自动挂载ServiceAccount的API凭证。默认为true，表示自动挂载API凭证。 |
| serviceAccount.annotations | 字典 | 空 | ServiceAccount的注解列表，用于添加额外的元数据。默认为空，表示没有额外的注解。 |
| serviceAccount.name | 字符串 | 空 | 使用的ServiceAccount的名称。如果未设置且`serviceAccount.create`为true，则使用fullname模板生成名称。 |
| podAnnotations | 字典 | 空 | Pod的注解列表，用于添加额外的元数据。默认为空，表示没有额外的注解。 |
| podLabels | 字典 | 空 | Pod的标签列表，用于组织和筛选Pod。默认为空，表示没有额外的标签。 |
| podSecurityContext | 字典 | 空 | Pod的安全上下文，用于指定Pod的安全策略。默认为空，表示没有额外的安全上下文。 |
| fsGroup | 整数 | 空 | 文件系统组ID，用于指定Pod中所有容器的文件系统组ID。默认为空，表示不指定文件系统组ID。 |
| securityContext | 字典 | 空 | 安全上下文，用于指定容器的安全策略。默认为空，表示不指定额外的安全上下文。 |
| capabilities.drop | 列表 | 空 | 容器的能力列表，用于指定容器所拥有的能力。默认为空，表示不指定额外的能力。 |
| readOnlyRootFilesystem | 布尔值 | 空 | 是否将根文件系统设置为只读。默认为空，表示不将根文件系统设置为只读。 |
| runAsNonRoot | 布尔值 | 空 | 是否以非root用户身份运行容器。默认为空，表示以root用户身份运行容器。 |
| runAsUser | 整数 | 空 | 容器运行的用户ID。默认为空，表示使用默认的用户ID。 |
| service.type | 字符串 | ClusterIP | 服务的类型，用于指定服务的访问方式。默认为ClusterIP，表示通过集群内部的IP地址访问服务。 |
| service.port | 整数 | 空 | 服务的端口号，用于指定服务的访问端口。默认为空，表示没有指定端口号。 |
| ingress.enabled | 布尔值 | 空 | 是否启用Ingress。如果启用，则可以通过Ingress访问服务。 |
| ingress.className | 字符串 | 空 | Ingress的类名，用于指定Ingress的类。默认为空，表示没有指定类名。 |
| ingress.annotations | 字典 | 空 | Ingress的注解列表，用于添加额外的元数据。默认为空，表示没有额外的注解。 |
| ingress.hosts | 列表 | 空 | Ingress的主机列表，用于指定Ingress的访问域名。默认为空，表示没有指定主机。 |
| ingress.paths | 列表 | 空 | Ingress的路径列表，用于指定Ingress的访问路径。默认为空，表示没有指定路径。 |
| ingress.pathType | 字符串 | 空 | Ingress的路径类型，用于指定Ingress的路径类型。默认为空，表示没有指定路径类型。 |
| ingress.tls | 列表 | 空 | Ingress的TLS配置列表，用于指定Ingress的TLS配置。默认为空，表示没有指定TLS配置。 |
| resources | 字典 | 空 | 资源配置，用于指定容器的资源需求和限制。默认为空，表示没有指定资源配置。 |
| autoscaling.enabled | 布尔值 | 空 | 是否启用自动扩缩容。如果启用，则可以根据资源利用率自动调整副本数量。 |
| autoscaling.minReplicas | 整数 | 空 | 自动扩缩容的最小副本数量，用于指定自动扩缩容的下限。 |
| autoscaling.maxReplicas | 整数 | 空 | 自动扩缩容的最大副本数量，用于指定自动扩缩容的上限。 |
| autoscaling.targetCPUUtilizationPercentage | 整数 | 空 | 自动扩缩容的目标CPU利用率百分比，用于指定自动扩缩容的目标。 |
| autoscaling.targetMemoryUtilizationPercentage | 整数 | 空 | 自动扩缩容的目标内存利用率百分比，用于指定自动扩缩容的目标。 |
| volumes | 列表 | 空 | 附加到输出的Deployment定义的卷列表，用于挂载额外的存储卷。默认为空，表示没有附加的卷。 |
| volumeMounts | 列表 | 空 | 附加到输出的Deployment定义的卷挂载列表，用于指定存储卷的挂载路径。默认为空，表示没有附加的卷挂载。 |
| nodeSelector | 字典 | 空 | 节点选择器，用于指定部署所在的节点。默认为空，表示没有指定节点选择器。 |
| tolerations | 列表 | 空 | 允许的污点列表，用于容忍指定的节点污点。默认为空，表示没有指定允许的污点。 |
| affinity | 字典 | 空 | 亲和性设置，用于指定部署的亲和性，如与指定的节点亲和等。默认为空，表示没有指定亲和性设置。 |
