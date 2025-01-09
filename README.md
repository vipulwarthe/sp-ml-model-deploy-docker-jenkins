# Deploy the ML Model with Docker: (UPDATED)

### first create one ec2 instance with ubuntu 22.04/t2.medium/20gb

### upgrade the packages and dependancies and install python ENV:

    1  sudo apt-get update && sudo apt-get upgrade -y
    2  sudo apt install python3-venv -y
    3  python3 -m venv MLPRO
    4  source MLPRO/bin/activate

### clone the repo:

    5  git clone https://github.com/vipulwarthe/sp-repo.git
    6  ls

### install docker:

    7  vi docker.sh 
    8  sudo chmod +x docker.sh
    9  ./docker.sh

### chnage the directory:

    10  cd sp-repo/

### build the image and run the container:

    11  docker build -t my-app-image .
    12  docker run -d --name app-container -p 5000:5000 my-app-image
    13  docker images
    14  docker ps

### access the application with public ip:5000/predictdata

