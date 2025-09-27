# Argo CD Apps
This is the App of Apps directory.

The `root-app.yaml` creates an Application to applies all manifests within this directory.

Argo CD can search sub directories, so apps or appsets can also be installed automatically the next time new Application manifests are created here.

## Chicken and Egg Problem
The root app cannot manage itself unless we first install it manually once.

**IMPORTANT:** Only perform this ONCE the code has been merged into main.
```
kubectl apply -f root-app.yaml
```

## Moving Forward
Once the root-app is installed and is monitoring the default branch, all needs to be done is add the manifests into this directory and ArgoCD will automatically pick them up.

Note: When the following is used, it searches for sub-directories for manifests
```yaml
- name: root-app
  repoURL: https://github.com/88lexd/website-astro
  targetRevision: HEAD
  path: infra/argo-cd-apps # Here it searches and applies manifests from all sub-dirs
```

# Debugging the Root App
To debug issues with the root app, the following can be used
```
$ kubectl describe appset -n argocd root-app | grep Status -A10
Status:
  Conditions:
    Last Transition Time:  2025-09-27T12:07:05Z
    Message:               failed to execute go template {{.url}}: template: :1:2: executing "" at <.url>: map has no entry for key "url"
    Reason:                RenderTemplateParamsError
    Status:                True
    Type:                  ErrorOccurred
    Last Transition Time:  2025-09-27T12:07:05Z
    Message:               failed to execute go template {{.url}}: template: :1:2: executing "" at <.url>: map has no entry for key "url"
    Reason:                ErrorOccurred
    Status:                False
    Type:                  ParametersGenerated
    Last Transition Time:  2025-09-27T12:07:05Z
    Message:               failed to execute go template {{.url}}: template: :1:2: executing "" at <.url>: map has no entry for key "url"
    Reason:                RenderTemplateParamsError
    Status:                False
    Type:                  ResourcesUpToDate
Events:                    <none>
```

We can also use the `argocd` CLI to check.
```
$ argocd appset get root-app --port-forward --port-forward-namespace argocd
Name:               argocd/root-app
Project:            default
Server:             {{.url}}
Namespace:          argocd
Source:
- Repo:             {{.repoURL}}
  Target:           {{.targetRevision}}
  Path:             {{.path}}
SyncPolicy:         <none>

CONDITION            STATUS  MESSAGE                                                                                                         LAST TRANSITION
ErrorOccurred        True    failed to execute go template {{.url}}: template: :1:2: executing "" at <.url>: map has no entry for key "url"  2025-09-27 22:07:05 +1000 AEST
ParametersGenerated  False   failed to execute go template {{.url}}: template: :1:2: executing "" at <.url>: map has no entry for key "url"  2025-09-27 22:07:05 +1000 AEST
ResourcesUpToDate    False   failed to execute go template {{.url}}: template: :1:2: executing "" at <.url>: map has no entry for key "url"  2025-09-27 22:07:05 +1000 AEST
```
