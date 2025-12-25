eksctl create cluster \
--name brain-tasks-eks \
--region us-east-2 \
--version 1.29 \
--nodegroup-name brain-tasks-nodes \
--node-type t3.micro \
--nodes 2 \
--nodes-min 1 \
--nodes-max 5 \
--managed
