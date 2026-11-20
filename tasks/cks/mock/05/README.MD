# CKS Mock Exam 05

Selected questions from mocks [01](../01/README.MD) and [02](../02/README.MD):

| Mock 05 | Source | Topic | Cluster |
| :-----: | :----: | :---- | :------ |
| 1 | 01 / 12 | Falco, sysdig | cluster7 |
| 2 | 02 / 12 | Falco | cluster8 |
| 3 | 02 / 16 | Cilium NetworkPolicy | cluster11 |
| 4 | 02 / 20 | ServiceAccount token mount | cluster6 |

> **Before deployment:** every node downloads its setup scripts from `repo_raw_url` in [env.hcl](env.hcl).
> Push this directory to the repository/branch that URL points to (for example your fork) before running `make`.

## Deployment

Prepare AWS access, Terraform state storage, and the required tools using the [Docker quick start](../../../../docs/run_from_docker.MD). Run all `make` commands below from the **repository root on the controlling machine**. Check this mock's [env.hcl](env.hcl), including its region and instance settings, before deployment.

```bash
TASK=05 make run_cks_mock
```

To display the Terraform connection details again:

```bash
TASK=05 make output_cks_mock
```

## Connect and start working

Use the `worker_pc_ssh` value from the **worker** module, the workstation prepared for this mock exam. A password-enabled environment prints a value in this form:

```text
worker_pc_ssh = "ssh ubuntu@<IP> password=<PASSWORD>"
```

Use only the address in the SSH command:

```bash
ssh ubuntu@<IP>
```

Enter the printed password when prompted; `password=...` is output metadata, not part of the SSH command. If password authentication is disabled, use the SSH key configured for the environment, for example `ssh ubuntu@<IP> -i <key_path>`.

After connecting, wait for initialization to finish and reload the shell settings:

```bash
sudo cloud-init status --wait
source ~/.bashrc
```

Work from the workstation. Select the Kubernetes context named in each task; use `ssh <node_name>` from the workstation when a task requires access to a cluster node. Check the remaining time with:

```bash
time_left
```

Follow the questions below. If initialization reports an error, inspect `/var/log/cloud-init-output.log` before starting the tasks.

## Check the result

Run on the workstation:

```bash
check_result
```

After your attempt, review the [reference solutions](worker/files/solutions) and [automated checks](worker/files/tests.bats).

## Delete the environment

AWS resources are billed to your account. After practice, return to the **controlling machine and repository root**, then run:

```bash
TASK=05 make delete_cks_mock
```

<details>
<summary>Independent environments for multiple users or attempts</summary>

Use the same identifiers for launch, output, and deletion:

```bash
USER_ID='user1' ENV_ID='01' TASK=05 make run_cks_mock
USER_ID='user1' ENV_ID='01' TASK=05 make output_cks_mock
USER_ID='user1' ENV_ID='01' TASK=05 make delete_cks_mock
```

[More about independent environments and CMDB](../../../../docs/environments.md).

</details>

---

## Allowed resources
**Kubernetes Documentation:**

https://kubernetes.io/docs/ and their subdomains

https://kubernetes.io/blog/ and their subdomains

This includes all available language translations of these pages (e.g. https://kubernetes.io/zh/docs/)

**Tools:**

**Falco** documentation https://falco.org/docs/
This includes all available language translations of these pages (e.g. https://falco.org/zh/docs/)

**Cilium**:
Documentation  https://docs.cilium.io/en/stable

- run ``time_left`` on work pc to **check time**
- run ``check_result`` on work pc to **check result**

# Questions

---
|       **1**        | **Falco, sysdig**                                                                                                                                                                                                                                       |
| :-----------------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
|     Task weight     | 6%                                                                                                                                                                                                                                                      |
|       Cluster       | cluster7 (`kubectl config use-context cluster7-admin@cluster7`)                                                                                                                                                                                         |
| Acceptance criteria | use `falco` or `sysdig`, prepare logs in format:<br/><br/>`time-with-nanosconds,container-id,container-name,user-name,kubernetes-namespace,kubernetes-pod-name`<br/><br/>for pod with image `nginx` and store log to `/var/work/tests/artifacts/1/log` |
---

|         **2**           | **Falco**                                                                                                                                                                                                                                                                                                                                             |
|:------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|       Task weight        | 6%                                                                                                                                                                                                                                                                                                                                                    |
|         Cluster          | cluster8 (`kubectl config use-context cluster8-admin@cluster8`)                                                                                                                                                                                                                                                                                       |
|   Acceptance criteria    | using  `falco`  , prepare logs in format: <br/>` Warning read /etc/shadow ns={k8s namespace} pod_name={k8s pod name} user_name={user name} container_image={container image}`<br/>- for pod with read file `/etc/shadow` <br/> and store log to `/var/work/tests/artifacts/2/log` <br/>- Scale down the Deployment to 0 pods for the detected issue. |
---

|       **3**        | You need to create  [Cilium NetworkPolicy](https://editor.networkpolicy.io/) **api-access** provide these requirements                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
|:-------------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     Task weight     | 4%                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
|       Cluster       | cluster11 (`kubectl config use-context cluster11-admin@cluster11`)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| Acceptance criteria | the portal  **APIs**: <br/>- /public/*  - open all **method**  from  all cluster   <br/>-  /private/* - open all **method** from all in  **finance** namespace  <br/> **for checking access** you can use curl from pod in  the **finance** namespace or **external**  namespace <br/>- **private** api from **finance** namespace `k exec  -n finance finance  --  curl -s http://portal.production/private/api123 --connect-timeout 1` <br/>- **public** api from **finance** namespace `k exec  -n finance finance  --  curl -s http://portal.production/public/api123  --connect-timeout 1 ` <br/>- **private** api from **external** namespace `k exec  -n external external  --  curl -s http://portal.production/private/api123 --connect-timeout 1` |
---

|         **4**          | disable sa secret auto-mount.  mount it to specific path.                                                                                                                                               |
|:-----------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     **Task weight**     | 3%                                                                                                                                                                                                      |
|       **Cluster**       | cluster6 (`kubectl config use-context cluster6-admin@cluster6`)                                                                                                                                         |
| **Acceptance criteria** | - ns  team-20  , deployment `team20`   <br/> -  create sa `team20` <br/>- update deployment `team20` to use sa `team20` <br/> disable automount sa secret <br/> mount sa secret to `/var/team20/secret` |
---
