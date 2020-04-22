# Deploying Vault with integrated storage on GKE

First clone the Terraform code in any location and then also clone the Vault helm chart.

'''
$ git clone https://github.com/ArctiqTeam/vault-gke-raft
$ cd vault-gke-raft
$ git clone https://github.com/hashicorp/vault-helm 
'''

Setup gcloud authentication for your account, create a service account which has access to use resources in your project and store the json for this account in the `creds` folder. After that modify the `terraform.tfvars` accordingly and deploy the stack.

```
terraform init
terraform apply
```

After completion Terraform code will output the URL for accessing the newly deployed Vault. We can check status of the pods using `kubectl` but for that first get the credentials for the GKE cluster.

```
$ gcloud container clusters get-credentials demo-cluster
Fetching cluster endpoint and auth data.
kubeconfig entry generated for demo-cluster.
$ 
$ kubectl get pods -n vault
NAME                                    READY   STATUS    RESTARTS   AGE
vault-0                                 0/1     Running   0          24m
vault-1                                 0/1     Running   0          24m
vault-2                                 0/1     Running   0          24m
vault-agent-injector-7d4cccc866-7qfkx   1/1     Running   0          24m
$ 
```

The pods will not become ready until they are bootstraped and unsealed which will involve making one of the pod as Raft leader and joining others to this pod. First we will make `Vault-0` as the leader to do that we will run the following commands to initialize Vault and unseal it.

```
$ kubectl exec -ti vault-0 -n vault -- vault operator init
```

We will use the unseal keys from the output of above command to unseal Vault.

```
$ kubectl exec -ti vault-0 -n vault -- vault operator unseal
```

After the Vault is unsealed the pod will become ready and will be elected as leader (you can verify by checking logs `kubectl logs vault-0 -n vault`).

```
$ kubectl exec -ti vault-0 -n vault -- vault status
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.4.0
Cluster Name    vault-cluster-5d640d05
Cluster ID      4d9f4351-52ac-4819-b0a0-ce9e2949aa87
HA Enabled      true
HA Cluster      https://vault-0.vault-internal:8201
HA Mode         active
$ 
$ kubectl get pods -n vault
NAME                                    READY   STATUS    RESTARTS   AGE
vault-0                                 1/1     Running   0          2m18s
vault-1                                 0/1     Running   0          2m18s
vault-2                                 0/1     Running   0          2m18s
vault-agent-injector-7d4cccc866-fbmz4   1/1     Running   0          2m19s
$ 
```

Now we will make other pods join the cluster leader `Vault-0` so that they can become part of the Raft cluster and then we have to unseal them. This step will be done for all the remaining pods.

```
$ kubectl exec -ti vault-1 -n vault --  vault operator raft join -leader-ca-cert="$(cat ./tls/ca-certificate.cert)" --address "https://vault-1.vault-internal:8200" "https://vault-0.vault-internal:8200" 
Key       Value
---       -----
Joined    true
$ 

# Unseal vault-1
kubectl exec -ti vault-1 -n vault -- vault operator unseal
```

```

```

After all the pods become part of the Raft cluster and unsealed, all pods will become ready and Vault cluster will be ready to serve any requests.

## Cleaning up

```
$ terraform destroy
```
