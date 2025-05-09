# 🏡 Homelab Automation with Proxmox

Welkom in mijn persoonlijke homelab repository. Deze repository bevat de volledige broncode en documentatie voor mijn persoonlijke homelab. 
De architectuur is ontworpen met een focus op professionaliteit, automatisering en reproduceerbaarheid.

Deze setup voorziet in:
- Volledige provisioning en configuratie via Ansible.
- Automatisering van VM-creatie en infrastructuurbeheer met Terraform.
- Beheer van Kubernetes-resources door middel van GitOps met ArgoCD.
- Monitoring en logging met behulp van Prometheus, Grafana en Loki.
- Veilige en eenvoudige remote toegang via Tailscale VPN.
- Robuust en veilig secret management, geschikt voor publieke repositories.

> 💡 Doelstelling: Een professioneel, schaalbaar en volledig reproduceerbaar homelab-platform creëren dat als portfolio-project kan dienen.

## 🛠️ Technologieën

- Kubernetes via [k3s](https://k3s.io/)
- GitOps met [ArgoCD](https://argoproj.github.io/argo-cd/)
- Monitoring met [Prometheus](https://prometheus.io/), [Grafana](https://grafana.com/)
- Logging met [Loki](https://grafana.com/oss/loki/)
- Automatisering via [Ansible](https://www.ansible.com/) en [Terraform](https://developer.hashicorp.com/terraform)
- Secrets via [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)

## 📂 Structuur

Zie `ansible/`, `cluster/`, en `inventory/` voor het volledige overzicht.

> Coming Soon - Work in Progress.

## ⚙️ Hardware

Om een start te maken met mijn homelab gebruik mijn oude laptop (Asus ZenBook Pro UX550VE), dit zal ik later uitbreiden met Mini PCs.

## 🏗 Architecture

### Ansible + Terraform
- Control Node: MacBook (Ansible + Terraform geïnstalleerd via Homebrew)
- Managed Nodes: Proxmox servers, alleen SSH-enabled, geen Ansible of Terraform lokaal geïnstalleerd.

## 🚀 Security First

In dit project wordt automatisch password-based SSH login uitgeschakeld na eerste configuratie, zodat alleen SSH key-authenticatie mogelijk is.
Secrets zoals Tailscale AuthKeys zijn veilig versleuteld via Ansible Vault.

---