#!/usr/bin/env bats
export KUBECONFIG=/home/ubuntu/.kube/_config

@test "0  Init  " {
  echo ''>/var/work/tests/result/all
  echo ''>/var/work/tests/result/ok
  [ "$?" -eq 0 ]
}

# 1 (mock 01, question 12)
@test "1 falco , sysdig " {
  echo '6'>>/var/work/tests/result/all
  cat /var/work/tests/artifacts/1/log  | grep default| grep deployment4
  result=$?
  if [[ "$result" == "0" ]]; then
   echo '6'>>/var/work/tests/result/ok
  fi
  [ "$result" == "0" ]
}

# 2 (mock 02, question 12)
@test "2.1 falco log" {
  echo '5'>>/var/work/tests/result/all
  cat /var/work/tests/artifacts/2/log |  grep '/etc/shadow ' | grep 'ns=default' |  grep 'Warning read ' |  grep ' pod_name=deployment1' |  grep 'user_name=root' | grep 'container_image=docker.io/viktoruj/cks-lab:cks_mock2_12_app1'
  result=$?
  if [[ "$result" == "0" ]]; then
   echo '5'>>/var/work/tests/result/ok
  fi
  [ "$result" == "0" ]
}

@test "2.2 scale deployment to 0 replicas" {
  echo '1'>>/var/work/tests/result/all
  result=$( kubectl get deployments.apps deployment1 -o jsonpath='{.spec.replicas}' --context cluster8-admin@cluster8)
  if [[ "$result" == "0" ]]; then
   echo '1'>>/var/work/tests/result/ok
  fi
  [ "$result" == "0" ]
}

@test "3.1 check private api from finance namespace  " {
  echo '1'>>/var/work/tests/result/all
  kubectl  exec  -n finance finance --context cluster11-admin@cluster11  --  curl http://portal.production/private/api123 --connect-timeout 1 | grep 'http://portal.production/private/api123'
  result=$?
  if [[ "$result" == "0" ]]; then
   echo '1'>>/var/work/tests/result/ok
  fi
  [ "$result" == "0" ]
}

@test "3.2 check public api from finance namespace  " {
  echo '1'>>/var/work/tests/result/all
  kubectl  exec  -n finance finance   --context cluster11-admin@cluster11 --  curl http://portal.production/public/api123  --connect-timeout 1 | grep 'http://portal.production/public/api123'
  result=$?
  if [[ "$result" == "0" ]]; then
   echo '1'>>/var/work/tests/result/ok
  fi
  [ "$result" == "0" ]
}

@test "3.3 check private api from external namespace  " {
  echo '1'>>/var/work/tests/result/all
  kubectl  exec  -n external external  --context cluster11-admin@cluster11 --  curl http://portal.production/private/api123   --connect-timeout 1 | grep 'Access denied'
  result=$?
  if [[ "$result" == "0" ]]; then
   echo '1'>>/var/work/tests/result/ok
  fi
  [ "$result" == "0" ]
}

@test "3.4 check public api from external namespace  " {
  echo '1'>>/var/work/tests/result/all
  kubectl  exec  -n external external  --context cluster11-admin@cluster11 --  curl http://portal.production/public/api123  --connect-timeout 1 | grep 'http://portal.production/public/api123'
  result=$?
  if [[ "$result" == "0" ]]; then
   echo '1'>>/var/work/tests/result/ok
  fi
  [ "$result" == "0" ]
}



@test "4.1  disable sa secret auto-mount. " {
  echo '1'>>/var/work/tests/result/all
  result=$(kubectl  get sa team20   -n team-20  -o jsonpath='{.automountServiceAccountToken}'  --context cluster6-admin@cluster6)
  if [[ "$result" == "false" ]]; then
   echo '1'>>/var/work/tests/result/ok
  fi
  [ "$result" == "false" ]
}

@test "4.2 check mount secret " {
  echo '2'>>/var/work/tests/result/all
  pod=$(kubectl get  po  -n team-20    --context cluster6-admin@cluster6  -l app=team20 -o jsonpath={.items..metadata.name})
  kubectl exec $pod -ti -n  team-20    --context cluster6-admin@cluster6 -- bash -c ' cat /var/team20/secret/token'
  result=$?
  if [[ "$result" == "0" ]]; then
   echo '2'>>/var/work/tests/result/ok
  fi
  [ "$result" == "0" ]
}

# 5 (mock 03, question 12)
@test "5 Falco. Check that proper deployment was scaled to 0" {
  echo '2'>>/var/work/tests/result/all
  app1_replicas=$(kubectl get deployments.apps --context cluster9-admin@cluster9 -n north app1 -o jsonpath='{.spec.replicas}')
  app2_replicas=$(kubectl get deployments.apps --context cluster9-admin@cluster9 -n north app2 -o jsonpath='{.spec.replicas}')
  app3_replicas=$(kubectl get deployments.apps --context cluster9-admin@cluster9 -n north app3 -o jsonpath='{.spec.replicas}')
  if [[ "$app1_replicas" == "1" && "$app2_replicas" == "1" && "$app3_replicas" == "0" ]]; then
   echo '2'>>/var/work/tests/result/ok
  fi
  [[ "$app1_replicas" == "1" && "$app2_replicas" == "1" && "$app3_replicas" == "0" ]]
}

# 6 (mock 03, question 22)
@test "6.1. Check if user was removed from docker group" {
  echo '1'>>/var/work/tests/result/all
  set +e
  timeout 2s ssh -oStrictHostKeyChecking=no docker-worker "groups user " | grep docker
  result=$?
  set -e
  if [[ "$result" == "1" ]]; then
   echo '1'>>/var/work/tests/result/ok
  fi
  [ "$result" == "1" ]
}

@test "6.2. Check docker socket configuration" {
  echo '1' >>/var/work/tests/result/all
  timeout 2s ssh -oStrictHostKeyChecking=no docker-worker "stat -c %G /var/run/docker.sock" | grep root
  result=$?
  if [[ "$result" == "0" ]]; then
    echo '1'>>/var/work/tests/result/ok
  fi
  [ "$result" == "0" ]
}


@test "6.3. Docker is NOT exposed on TCP 2375" {
  echo '1' >>/var/work/tests/result/all
  set +e
  timeout 2s ssh -oBatchMode=yes -oStrictHostKeyChecking=no -oConnectTimeout=5 docker-worker 'ss -ltn  | grep -qE "[:.]2375(\\s|$)"'
  result=$?
  set -e
  if [[ "$result" == "1" ]]; then
   echo '1'>>/var/work/tests/result/ok
  fi
  [ "$result" == "1" ]
}

@test "6.4. Docker daemon is running" {
  echo '1' >>/var/work/tests/result/all
  timeout 2s ssh -oStrictHostKeyChecking=no docker-worker "systemctl is-active docker" | grep active
  result=$?
  if [[ "$result" == "0" ]]; then
    echo '1'>>/var/work/tests/result/ok
  fi
  [ "$result" == "0" ]
}

@test "6.5. Docker socket is active" {
  echo '1' >>/var/work/tests/result/all
  timeout 2s ssh -oStrictHostKeyChecking=no docker-worker "systemctl is-active docker.socket" | grep active
  result=$?
  if [[ "$result" == "0" ]]; then
    echo '1'>>/var/work/tests/result/ok
  fi
  [ "$result" == "0" ]
}
