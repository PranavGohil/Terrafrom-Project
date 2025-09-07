# Coding Challenge – Anagram Checker & Terraform Deployment

## Part 1: Python – Anagram Checker

### Project Structure
- **anagram.py** – contains the `is_anagram` function  
- **test_anagram.py** – unit tests for the function  

### Requirements
- Python 3.x  
- No external libraries required (uses Python’s built-in `unittest` framework)

### How to Run
Open a terminal in the project folder and execute:

```bash
python -m unittest test_anagram.py
```

### Example Usage
```python
from anagram import is_anagram

print(is_anagram("ab", "ba"))   # True
print(is_anagram("AB", "ab"))   # True
print(is_anagram("A", "B"))     # False
```

---

## Part 2: Terraform – AWS Lambda Deployment

This part of the project uses **Terraform** to deploy a Lambda function on AWS.  
The function is triggered whenever a file named **`anagram.csv`** is uploaded to an S3 bucket called **`anagram-fd-testing-pranav`**.

### Project Structure
- **lambda/anagram.js** – Lambda function code  
- **main.tf** – Defines Lambda, S3 bucket, IAM roles, and triggers  
- **provider.tf** – AWS provider configuration  
- **variables.tf** – Input variables  

### Requirements
- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed  
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed and configured with valid credentials  

### Deployment
Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

---

## Work Hours Estimate
- **Part 1 (Python Anagram Checker):** ~30 - 45 min  
- **Part 2 (Terraform Deployment):** ~2–3 hours  
- **Total:** ~3–4 hours  

---
