
## Usage

**Build the container:**

- Build the docker-ansible container: `docker build -t ansible_docker -f docker-ansible/Dockerfile .`

**Use the container:**

Here is how to use the container to run a playbook:

Add an alias like this to ~/bash_profile:
```
alias ansible_docker='docker run --rm -it -v $(pwd):/ansible/playbooks ansible_docker'
```

Refresh it with:
```
source ~/.bash_profile
```

Then run something like this:
```bash
ansible_docker -i hosts-qa.yml playbooks/<playbook name> --limit <target>
```
