# Local k8s deployment

0. Add to `/etc/hosts`: `127.0.0.1 ritotalks.ru`
1. Run `./.devops/deploy/test_init_k8s.sh`
2. Run `./.devops/deploy/test_deploy_mongo.sh` and setup using the console output commands
3. Run `./.devops/deploy/test_deploy_ingress.sh`
4. Update `./.devops/deploy/test_build_backend.sh` with your correct `GITHUB_TOKEN`
5. Run `./.devops/deploy/test_build_backend.sh`
6. Run `./.devops/deploy/test_deploy_backend.sh`
7. Run `kubectl exec -it NODEBB_POD_NAME bash -n local` and run `./nodebb setup --skip-build`
8. Copy admin username and password from the console output!!!
9. Run `kubectl delete pod NODEBB_POD_NAME -n local`
10. Open `http://ritotalks.ru/`
