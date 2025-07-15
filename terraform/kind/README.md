# ☸️ Kubernetes Local: KIND + Terraform para Meus Testes Avançados

Este repositório foi desenvolvido para provisionar um cluster Kubernetes local usando **KIND (Kubernetes in Docker)**, com controle total e automação via **Terraform**. A intenção é ter um ambiente ágil e fiel à ambientes produtivo para testar e validar aplicações e infraestrutura complexas, simulando cenários que encontramos em ambientes de nuvem ou on-premises. Este recurso visa beneficiar qualquer pessoa que precise de um ambiente Kubernetes local para testes.

---

## 🎯 Motivação do Projeto

Este projeto tem como objetivo fornecer um ambiente de desenvolvimento e testes **robusto**, **realista** e **versátil**. A estrutura permite:

- ✅ **Testar implantações de aplicações:** Validar o comportamento de aplicações em um ambiente Kubernetes completo.
- 🔌 **Experimentar ferramentas e serviços:** Integrar e testar serviços que operam em Kubernetes, como bancos de dados e sistemas de mensageria.
- 🌐 **Validar Ingress Controllers:** Implementar e testar soluções de roteamento de tráfego, como Istio e NGINX.
- 🏗️ **Simular topologias de produção:** Reproduzir cenários com múltiplos nós workers e alta disponibilidade, semelhantes aos encontrados em ambientes de nuvem.
- 🐞 **Desenvolvimento e troubleshooting local:** Depurar aplicações e infraestrutura em um ambiente isolado, sem impactar ambientes de produção.
- 🧠 **Avaliar padrões e arquiteturas:** Verificar resiliência, escalabilidade e comunicação entre microsserviços.

---

## ⚙️ Pré-requisitos

Para usar este cluster, você precisará ter as seguintes ferramentas instaladas:

- [Docker](https://docs.docker.com/get-docker/) – Essencial para o KIND
- [Kind](https://kind.sigs.k8s.io/) – O "Kubernetes in Docker"
- [Terraform](https://developer.hashicorp.com/terraform) – Gerencia o ciclo de vida do cluster

### ✅ Verificação Rápida

Execute o script abaixo para verificar as dependências:

```bash
./bootstrap.sh
```

> ⚠️ Este script apenas **verifica** se as dependências estão instaladas. Ele **não realiza** a instalação automática.

---

## 🚀 Como Provisionar o Cluster

1. **Configure as variáveis:** edite o arquivo `variables.tfvars` com suas preferências.
2. **Execute o Terraform:**

```bash
terraform init
terraform apply -var-file="variables.tfvars"
```

Em questão de segundos, seu cluster Kubernetes local estará pronto e funcional!

---

## 🧹 Como Destruir o Cluster

Para remover todos os recursos do cluster e limpar o ambiente:

```bash
terraform destroy -var-file="variables.tfvars"
```

---

## 📝 Observações Importantes

- Este projeto **não é um módulo genérico**; ele provisiona um cluster **local e opinativo**, voltado para **testes e desenvolvimento**.
- A configuração atual está otimizada para **integração com Istio**, mas pode ser adaptada facilmente para outros Ingress Controllers, como o **NGINX**, ajustando o arquivo `kind-config.yaml.tmpl`.

---

## 💡 Cenários de Uso

A flexibilidade deste cluster permite a aplicação em diversos cenários de desenvolvimento e validação:

- 🚢 **Validação de Novas Aplicações:** Possibilita testar aplicações Kubernetes antes da promoção para ambientes de stage ou produção.
- 🐛 **Debug de Microsserviços:** Facilita a reprodução e análise de problemas de integração em ambiente isolado.
- 📦 **Testes de IaC:** Permite validar módulos Terraform ou Helm Charts destinados ao Kubernetes.
- 🔬 **Experimentação com Ferramentas Cloud-Native:** Suporta a avaliação de service meshes, operadores, gerenciadores de segredos, pipelines de CI/CD, entre outros.
- 🧪 **Prototipagem de Arquiteturas:** Viabiliza o desenvolvimento e a iteração ágil de novas arquiteturas baseadas em Kubernetes.

---

> 💬 Este cluster pode ser utilizado como um ambiente de testes local, servindo como base para desenvolvimento e validações de infraestrutura, com a capacidade de simular com fidelidade a complexidade de ambientes reais.