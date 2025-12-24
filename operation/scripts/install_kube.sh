echo " Installing kubectl (OS / pkgs.k8s.io)"

sudo install -m 0755 -d /etc/apt/keyrings

if [ ! -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg ]; then
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  sudo chmod a+r /etc/apt/keyrings/kubernetes-apt-keyring.gpg
else
  echo " - Kubernetes key already exists"
fi

if [ ! -f /etc/apt/sources.list.d/kubernetes.list ]; then
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list >/dev/null
else
  echo " - Kubernetes repo already exists"
fi

if ! command -v kubectl >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y kubectl
  echo  " kubectl installed"
else
  echo " - kubectl already installed"
fi

