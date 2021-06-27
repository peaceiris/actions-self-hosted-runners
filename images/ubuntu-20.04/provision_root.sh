# Install Google Chrome
sudo curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
sudo echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update -y
sudo apt-get install -y google-chrome-stable

# Install ChromeDriver
export CHROMEDRIVER_TEMPDIR=$(mktemp -d)
wget -O ${CHROMEDRIVER_TEMPDIR}/LATEST_RELEASE http://chromedriver.storage.googleapis.com/LATEST_RELEASE
export CHROMEDRIVER_LATEST_VERSION=$(cat ${CHROMEDRIVER_TEMPDIR}/LATEST_RELEASE)
wget -O ${CHROMEDRIVER_TEMPDIR}/chromedriver.zip "http://chromedriver.storage.googleapis.com/${CHROMEDRIVER_LATEST_VERSION}/chromedriver_linux64.zip"
sudo unzip ${CHROMEDRIVER_TEMPDIR}/chromedriver.zip chromedriver -d /usr/local/bin/

# Install terraform
TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)
curl -sLO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip -qq "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin
rm -f "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

apt-get autoremove -y
